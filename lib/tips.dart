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

  SnackBar _snackBar() => SnackBar(
        duration: Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft:
                Radius.circular(20.0), // Adjust the top left corner radius here
            topRight: Radius.circular(
                20.0), // Adjust the top right corner radius here
          ),
        ),
        content: Text(
            'It is currently illegal to drive.\n\nYou will be fully sober in 5 hrs 30 mins.\n\nThis is merely an estimate, always use your own judgement to determine if you are fit to drive.',
            style: TextStyle(color: Colors.black)),
        backgroundColor: selectedItem,
      );

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
                ? Icon(Icons.car_crash)
                : Icon(Icons.directions_car),
            iconSize: 25,
            onPressed: () {
              // Navigating to the MyProfilePage when the settings icon is tapped
              final snackBar = _snackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
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
            padding: EdgeInsets.only(top: 0.0),
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
