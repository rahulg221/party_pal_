import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lift_links/drive_alert.dart';
import 'package:lift_links/homepage.dart';
import 'package:lift_links/settings.dart';
import 'package:lift_links/theme_config.dart';
import 'main.dart';
import 'package:intl/intl.dart';
import 'package:lift_links/providers.dart';

class MyFriendsPage extends ConsumerStatefulWidget {
  const MyFriendsPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyFriendsPage> createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends ConsumerState<MyFriendsPage> {
  final ScrollController _scrollController = ScrollController();

  void toggleTheme() {
    MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  String convertToHoursMinutes(double timeInHours) {
    int hours = timeInHours.toInt();
    int minutes = ((timeInHours - hours) * 60).round();

    if (hours <= 0 && minutes <= 0) {
      hours = 0;
      minutes = 0;
    }

    // Pad hours with leading zero if needed
    String paddedHours = hours.toString().padLeft(2, '0');

    // Pad minutes with leading zero if needed
    String paddedMinutes = minutes.toString().padLeft(2, '0');

    return '$paddedHours:$paddedMinutes';
  }

  String formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  Widget _drinkList(double width, List<Drink> drinks) => Material(
        elevation: 6,
        color: MyApp.themeNotifier.value == ThemeMode.light
            ? Colors.white
            : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Container(
          width: width - 32,
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyApp.themeNotifier.value == ThemeMode.light
                    ? ref.watch(colorController).withOpacity(0.7)
                    : Colors.grey.shade900,
                MyApp.themeNotifier.value == ThemeMode.light
                    ? ref.watch(colorController).withOpacity(0.8)
                    : Colors.black,
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              Drink drink = drinks[index];
              String time = formatTimestamp(drink.timestamps);
              return ListTile(
                title: Text(
                  drink.type,
                  style: TextStyle(
                    fontSize: 24,
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? Colors.black.withOpacity(0.9)
                        : ref.watch(colorController),
                    fontFamily: fontStyle,
                  ),
                ),
                subtitle: Text(
                  time,
                  style: TextStyle(
                    fontSize: 22,
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? Colors.black.withOpacity(0.9)
                        : ref.watch(colorController),
                    fontFamily: fontStyle,
                  ),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${drink.percentage}%',
                      style: TextStyle(
                        fontSize: 20,
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.black.withOpacity(0.9)
                            : ref.watch(colorController),
                        fontFamily: fontStyle,
                      ),
                    ),
                    Text(
                      '${drink.size} oz',
                      style: TextStyle(
                        fontSize: 20,
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.black.withOpacity(0.9)
                            : ref.watch(colorController),
                        fontFamily: fontStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

  Widget _drinkDisplay(double count, double width, double height) => Material(
        elevation: 6,
        color: MyApp.themeNotifier.value == ThemeMode.light
            ? Colors.white
            : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
        ),
        child: Container(
          width: width - 32,
          height: height * 3 / 15,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MyApp.themeNotifier.value == ThemeMode.light
                      ? ref.watch(colorController).withOpacity(0.7)
                      : Colors.grey.shade900,
                  MyApp.themeNotifier.value == ThemeMode.light
                      ? ref.watch(colorController).withOpacity(0.8)
                      : Colors.black,
                ],
              ),
              borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'You have consumed: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        '${count.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'std. drinks',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double count = ref.watch(countController);
    double bac = ref.watch(bacController);
    double legalLimit = ref.watch(limitController);
    List<Drink> drinks = ref.watch(drinkController);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: bac >= 0.08
                ? Icon(
                    Icons.car_crash,
                  )
                : Icon(
                    Icons.directions_car,
                  ),
            iconSize: 25,
            onPressed: () {
              final driveAlert = ReusableSnackBar(
                context: context,
                timeTillDrive: convertToHoursMinutes(
                    (ref.watch(bacController) - legalLimit) / 0.015),
                backgroundColor: ref
                    .watch(colorController), // Customize the background color
                duration: Duration(seconds: 5),
                bac: ref.watch(bacController), // Customize the duration
              );

              ScaffoldMessenger.of(context).showSnackBar(driveAlert);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
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
        child: Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: Center(
            child: Container(
              width: width - 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 25),
                  _drinkDisplay(count, width, height),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? "Today's Drinks"
                              : "Tonight's Drinks",
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(child: _drinkList(width, drinks)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
