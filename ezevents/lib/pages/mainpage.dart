import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isEvents = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          "Welcome, User!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // NOTIFICATIONS
              Container(
                padding: const EdgeInsets.all(12),
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
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
                      "• Sarojini Naidu Hall is Under maintenance!",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 25),
                    ),
                    !isEvents
                        ? Text("Send events for approval to see them here!")
                        : Container(
                            height: 300,
                            child: ListView.builder(
                              itemCount: 10,
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  EventTile(index: index),
                            ),
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  final int index;

  const EventTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Event Title: Event $index",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("Date: Sunday 10/10/2025")
          ],
        ),
      ),
    );
  }
}
