import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lift_links/drive_alert.dart';
import 'package:lift_links/main.dart';
import 'package:lift_links/settings.dart';
import 'package:activity_ring/activity_ring.dart';
import 'package:lift_links/theme_config.dart';
import 'package:lift_links/providers.dart';

//testing
final List<Drink> drinks = [];

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  Timer? timer;

  String drinkType = 'Beer';
  int ozLength = 6;
  int abvLength = 6;
  String listName = '';

  bool isBeer = true;
  bool isWine = false;
  bool isLiquor = false;
  double _kItemExtent = 32.0;

  final List<double> _liquorAbv = [
    35.0,
    40.0,
    45.0,
    50.0,
    55.0,
    65.0,
  ];

  final List<double> _beerAbv = [4, 5, 6, 7, 9, 10];
  final List<double> _wineAbv = [9, 10, 11, 12, 13, 14];

  final List<double> _liquorOz = [0.75, 1.25, 1.5, 2.0];
  final List<double> _wineOz = [5, 6, 7, 8, 9, 10, 11, 12];
  final List<double> _beerOz = [12, 16, 17, 18, 19, 20];

  double oz = 0.0;
  double abv = 0.0;

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

  void startTimer() {
    print('Starting timer');
    // Start the timer when the button is pressed
    timer = Timer.periodic(Duration(seconds: 60), (_) {
      // Make sure initialTime is not null before calling updateBac
      if (ref.watch(bacController) <= 0) {
        stopTimer();
      } else {
        ref.read(bacController.notifier).timeDecrement();
      }
    });
  }

  void stopTimer() {
    // Check if the timer is not null and active before stopping
    if (timer != null && timer!.isActive) {
      print('Stopping timer');
      // Stop the timer by canceling it
      timer!.cancel();
      // Set the timer variable to null to indicate it has been stopped
      timer = null;
    }
  }

  //Finds ratio for ring percentage
  double findRatio(
      int recLevel, double bac, double legalLimit, double tolerance) {
    if (recLevel == 1) {
      //return legalLimit * (weight * 454 * genderVal) / 1400;
      return bac / legalLimit;
    } else if (recLevel == 2) {
      //return (0.11 * tolerance) * (weight * 454 * genderVal) / 1400 ;
      return bac / (0.14 * tolerance);
    } else if (recLevel == 3) {
      //return (0.14 * tolerance) * (weight * 454 * genderVal) / 1400;
      return bac / (0.17 * tolerance);
    }

    return 0.0;
  }

  @override
  void dispose() {
    // Cancel the timer and dispose of it when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.

        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Widget _drinkSelector() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
                      ? isBeer
                          ? Colors.black.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1)
                      : isBeer
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white.withOpacity(0.2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    drinkType = 'Beer';
                    isBeer = true;
                    isWine = false;
                    isLiquor = false;
                    ozLength = _beerOz.length;
                  });
                },
                icon: Icon(
                  Icons.local_drink,
                  color: MyApp.themeNotifier.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ),
                label: Text('Beer',
                    style: Theme.of(context).textTheme.displaySmall),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
                      ? isLiquor
                          ? Colors.black.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1)
                      : isLiquor
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white.withOpacity(0.2),
                ),
                onPressed: () {
                  setState(() {
                    drinkType = 'Liquor';
                    isLiquor = true;
                    isBeer = false;
                    isWine = false;
                    ozLength = _liquorOz.length;
                  });
                },
                icon: Icon(
                  Icons.local_drink_outlined,
                  color: MyApp.themeNotifier.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ),
                label: Text('Liquor',
                    style: Theme.of(context).textTheme.displaySmall),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
                      ? isWine
                          ? Colors.black.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1)
                      : isWine
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white.withOpacity(0.2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    drinkType = 'Wine';
                    isWine = true;
                    isBeer = false;
                    isLiquor = false;
                    ozLength = _wineOz.length;
                  });
                },
                icon: Icon(
                  Icons.local_bar,
                  color: MyApp.themeNotifier.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ),
                label: Text('Wine',
                    style: Theme.of(context).textTheme.displaySmall),
              ),
            ),
          ),
        ],
      );

  Widget _countDisplay(double count, Color color, double bacRatio) => Stack(
        alignment: const Alignment(0.6, 0.6),
        children: [
          Ring(
            percent: (bacRatio * 100) > 0 ? (bacRatio * 100) : 0,
            color: RingColorScheme(ringColor: color),
            radius: 120,
            width: 15,
            child: GestureDetector(
              onTap: () {
                print('bac ratio: $bacRatio');
                // Show the snack bar here.
                final snackBar = SnackBar(
                  duration: Duration(seconds: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          20.0), // Adjust the top left corner radius here
                      topRight: Radius.circular(
                          20.0), // Adjust the top right corner radius here
                    ),
                  ),
                  content: Text(
                      'You have consumed ${count.toStringAsFixed(1)} standard drinks.\n\nA standard drink is equivalent to:\n\n-12 ounces of beer at 5% ABV\n\n-5 ounces of wine at 12% ABV\n\n-1.5 oz of hard liquor at 40% ABV',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  backgroundColor: ref.watch(colorController),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Container(
                width: 225,
                height: 225,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.transparent
                            : Colors.grey.shade900,
                        MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.black.withOpacity(0.1)
                            : Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '${count.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _inputPanel(
          double width,
          double height,
          double weight,
          double abv,
          double oz,
          double bac,
          int recLevel,
          double legalLimit,
          double tolerance,
          double count,
          double genderVal) =>
      Column(
        children: [
          Row(
            children: [
              Container(
                width: (width - 32) / 2 - 3, // width - body column padding
                height: 166,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.black.withOpacity(0.2)
                            : Colors.white.withOpacity(
                                0.1), // Change the background color here
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  onPressed: () {
                    if (count == 0) {
                      startTimer();
                    }
                    if (weight != 0.0 &&
                        genderVal != 0.0 &&
                        recLevel != 0 &&
                        legalLimit != 0.0 &&
                        recLevel != 0) {
                      double localc =
                          ref.read(countController.notifier).addDrink(abv, oz);

                      ref
                          .read(bacController.notifier)
                          .updateBac(weight, genderVal, localc);

                      ref
                          .read(colorController.notifier)
                          .changeColor(bac, recLevel, legalLimit, tolerance);

                      ref
                          .read(drinkController.notifier)
                          .logDrink(drinkType, abv, oz, DateTime.now());
                    } else {
                      _infoWarning(context);
                    }
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 6),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width:
                          (width - 32) / 2 - 3, // width - body column padding
                      height: 80,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              MyApp.themeNotifier.value == ThemeMode.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(
                                      0.2), // Change the background color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () => _showDialog(CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: _kItemExtent,
                          // This sets the initial item.
                          scrollController: FixedExtentScrollController(
                            initialItem: 1,
                          ),
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItemIndex) {
                            setState(() {
                              if (drinkType == 'Liquor') {
                                ref
                                    .read(ozController.notifier)
                                    .setOz(_liquorOz[selectedItemIndex]);
                              } else if (drinkType == 'Wine') {
                                ref
                                    .read(ozController.notifier)
                                    .setOz(_wineOz[selectedItemIndex]);
                              } else if (drinkType == 'Beer') {
                                ref
                                    .read(ozController.notifier)
                                    .setOz(_beerOz[selectedItemIndex]);
                              }
                            });
                          },
                          children:
                              List<Widget>.generate(ozLength, (int index) {
                            if (drinkType == 'Liquor') {
                              return Center(child: Text('${_liquorOz[index]}'));
                            } else if (drinkType == 'Wine') {
                              return Center(child: Text('${_wineOz[index]}'));
                            } else if (drinkType == 'Beer') {
                              return Center(child: Text('${_beerOz[index]}'));
                            }

                            return Center(child: Text('Error'));
                          }),
                        )),
                        child: Text('$oz oz',
                            style: Theme.of(context).textTheme.displayMedium),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width:
                          (width - 32) / 2 - 3, // width - body column padding
                      height: 80,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              MyApp.themeNotifier.value == ThemeMode.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(
                                      0.2), // Change the background color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () => _showDialog(CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: _kItemExtent,
                          // This sets the initial item.
                          scrollController: FixedExtentScrollController(
                            initialItem: 1,
                          ),
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItemIndex) {
                            setState(() {
                              if (drinkType == 'Liquor') {
                                ref
                                    .read(abvController.notifier)
                                    .setAbv(_liquorAbv[selectedItemIndex]);
                              } else if (drinkType == 'Wine') {
                                ref
                                    .read(abvController.notifier)
                                    .setAbv(_wineAbv[selectedItemIndex]);
                              } else if (drinkType == 'Beer') {
                                ref
                                    .read(abvController.notifier)
                                    .setAbv(_beerAbv[selectedItemIndex]);
                              }
                            });
                          },
                          children:
                              List<Widget>.generate(abvLength, (int index) {
                            if (drinkType == 'Liquor') {
                              return Center(
                                  child: Text('${_liquorAbv[index]}'));
                            } else if (drinkType == 'Wine') {
                              return Center(child: Text('${_wineAbv[index]}'));
                            } else if (drinkType == 'Beer') {
                              return Center(child: Text('${_beerAbv[index]}'));
                            }

                            return Center(child: Text('Error'));
                          }),
                        )),
                        child: Text('$abv %',
                            style: Theme.of(context).textTheme.displayMedium),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: (width - 32) / 2 - 3, // width - body column padding
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? Colors.black.withOpacity(0.2)
                              : Colors.white.withOpacity(
                                  0.1), // Change the background color here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      double localc =
                          ref.read(countController.notifier).undoDrink(abv, oz);
                      ref
                          .read(bacController.notifier)
                          .updateBac(weight, genderVal, localc);

                      double localBac = ref.watch(bacController);

                      ref.read(colorController.notifier).changeColor(
                          localBac, recLevel, legalLimit, tolerance);

                      ref.read(drinkController.notifier).undoRecent();
                    },
                    child: Icon(
                      Icons.undo,
                      size: 30,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: (width - 32) / 2 - 3, // width - body column padding
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? Colors.black.withOpacity(0.2)
                              : Colors.white.withOpacity(
                                  0.1), // Change the background color here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      ref.read(countController.notifier).reset();
                      ref.read(bacController.notifier).reset();

                      ref.read(drinkController.notifier).clearDrinks();

                      ref
                          .read(colorController.notifier)
                          .changeColor(0, recLevel, legalLimit, tolerance);

                      stopTimer();
                      //dispose();
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 30,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _bacButton(double bac) => SizedBox(
        height: 45,
        width: 180,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
                ? Colors.black.withOpacity(0.1)
                : Colors.white
                    .withOpacity(0.2), // Change the background color here
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
          onPressed: () {},
          child: Text(
            'BAC: ${bac.toStringAsFixed(3)}',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      );

  void _infoWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: Text(
              'Please enter your information in settings before proceeding.',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                // Add code here to handle the action when the user taps on the button
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
          backgroundColor: ref.watch(colorController),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MyApp.themeNotifier.value == ThemeMode.light;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double count = ref.watch(countController);
    double bac = ref.watch(bacController);
    double weight = ref.watch(weightController);
    double abv = ref.watch(abvController);
    double oz = ref.watch(ozController);
    double legalLimit = ref.watch(limitController);
    int recLevel = ref.watch(recController);
    double tolerance = ref.watch(tolController);
    //int unit = ref.watch(unitController);
    Color color = ref.watch(colorController);
    double genderVal = ref.watch(genderController);
    //List<Drink> drinks = ref.watch(drinkController);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: fancyStyle, fontSize: 25),
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
        flexibleSpace: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _bacButton(bac),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Theme(
          data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 80),
                _countDisplay(count, color,
                    findRatio(recLevel, bac, legalLimit, tolerance)),
                Expanded(child: SizedBox()),
                _drinkSelector(),
                SizedBox(height: 6),
                _inputPanel(width, height, weight, abv, oz, bac, recLevel,
                    legalLimit, tolerance, count, genderVal),
                SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
