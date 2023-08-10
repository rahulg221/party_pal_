import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lift_links/settings.dart';
import 'main.dart';
import 'package:lift_links/providers.dart';

class MyTipsPage extends ConsumerStatefulWidget {
  const MyTipsPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyTipsPage> createState() => _MyTipsPageState();
}

class _MyTipsPageState extends ConsumerState<MyTipsPage> {
  void toggleTheme() {
    MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double bac = ref.watch(bacController);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: bac >= 0.08
                ? const Icon(Icons.car_crash)
                : const Icon(Icons.directions_car),
            iconSize: 25,
            onPressed: () {
              // Navigating to the MyProfilePage when the settings icon is tapped
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: 25,
            onPressed: () {
              // Navigating to the MyProfilePage when the settings icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MySettingsPage(title: 'Settings'),
                ),
              );
            },
          ),
        ],
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 0.0),
            width: width - 12,
            child: const Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 12),
                    Text(
                      'Paragraph 1',
                    ),
                    SizedBox(height: 200),
                    Text(
                      'Paragraph 2',
                    ),
                    SizedBox(height: 200),
                    Text(
                      'Paragraph 3',
                    ),
                    SizedBox(height: 200),
                    Text(
                      'Paragraph 4',
                    ),
                    SizedBox(height: 200),
                    Text(
                      'Paragraph 5',
                    ),
                    SizedBox(height: 200),
                    Text(
                      'Paragraph 6',
                    ),
                    SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
