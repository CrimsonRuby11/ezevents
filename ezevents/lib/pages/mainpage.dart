import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezevents/pages/loginpage.dart';
import 'package:ezevents/pages/venue_booking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ezevents/pages/event_proposal.dart';

class MainPage extends StatefulWidget {
  final String uid;

  const MainPage({
    super.key,
    required this.uid,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isEvents = true;
  List userEvents = [];
  String email = "";

  logout() async {
    final firebaseAuth = FirebaseAuth.instance;

    try {
      await firebaseAuth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error logging out!"),
      ));
    }
  }

  loadEventsData() async {
    final firestore = FirebaseFirestore.instance;

    try {
      userEvents.clear();

      await firestore
          .collection('events')
          .where('uid', isEqualTo: widget.uid)
          .get()
          .then((query) {
        for (var docSnapshot in query.docs) {
          userEvents.add(docSnapshot.data());
        }
      });

      setState(() {
        userEvents = userEvents;
      });

      debugPrint("SUCCESS: $userEvents");
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error retrieving events"),
        ),
      );
    }
  }

  loadUserdetails() async {}

  @override
  void initState() {
    super.initState();

    // Load events data
    loadEventsData();
    loadUserdetails();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: Icon(Icons.settings),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: logout,
              child: Icon(Icons.logout),
            ),
          ),
        ],
        toolbarHeight: 100,
        title: Text(
          "Welcome, User!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await loadEventsData();
          },
          child: Stack(
            children: [
              ListView(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // NOTIFICATIONS
                        Container(
                          padding: const EdgeInsets.all(12),
                          height: screenHeight * .15,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Notifications",
                                style: TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "• Sarojini Naidu Hall is under maintenance",
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // DASHBOARD
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Dashboard",
                                style: TextStyle(fontSize: 25),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              userEvents.isEmpty
                                  ? Text(
                                      "Send events for approval to see them here!")
                                  : Container(
                                      height: screenHeight * .35,
                                      child: ListView.builder(
                                        itemCount: userEvents.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            EventTile(
                                          index: index,
                                          eventObject: userEvents[index],
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => VenueBooking())),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green),
                            child: Text(
                              "View Venues",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EventProposalPage(
                                        uid: widget.uid,
                                      ))),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.brown),
                            child: Text(
                              "Register New Event",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  final int index;
  final eventObject;

  const EventTile({super.key, required this.index, required this.eventObject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Event Title: ${eventObject['eventName']}",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Date: ${eventObject['date']}",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
