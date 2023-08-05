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

  int currentIndex = 0;

  bool isBeer = true;
  bool isWine = false;
  bool isLiquor = false;
  double _kItemExtent = 32.0;

  String sizeDisplay = '1 Can';

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
  final List<String> _liquorOzStr = [
    '1/2 shot',
    '1 Small Shot',
    '1 Shot',
    '1 Large Shot'
  ];
  final List<String> _liquorOzStr_ = [
    '1/2 shot (0.75 oz / 22ml)',
    '1 Small Shot (1.25 oz / 37ml)',
    '1 Shot (1.5 oz / 44ml)',
    '1 Large Shot (2.0 oz / 59ml)'
  ];
  final List<double> _wineOz = [5, 8, 12];
  final List<String> _wineOzStr = [
    '1 Small Glass',
    '1 Medium Glass',
    '1 Large Glass',
  ];
  final List<String> _wineOzStr_ = [
    '1 Small Glass (5 oz / 148ml)',
    '1 Medium Glass (8 oz / 237ml)',
    '1 Large Glass (12 oz / 355ml)',
  ];

  final List<double> _beerOz = [8.4, 12, 16];
  final List<String> _beerOzStr = [
    '1 Small Can',
    '1 Can',
    '1 Large Can',
  ];
  final List<String> _beerOzStr_ = [
    '1 Small Can (8.4 oz / 250ml)',
    '1 Can (12 oz / 355 ml)',
    '1 Large Can (16 oz / 473 ml)',
  ];

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
    timer = Timer.periodic(Duration(seconds: 1), (_) {
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

  Widget _drinkSelector(double height) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: height * 0.05,
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
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    sizeDisplay = _beerOzStr[1];
                    drinkType = 'Beer';
                  });

                  isBeer = true;
                  isWine = false;
                  isLiquor = false;
                  ozLength = _beerOz.length;

                  ref.read(ozController.notifier).setOz(_beerOz[1]);
                  ref.read(abvController.notifier).setAbv(_beerAbv[1]);
                },
                icon: Icon(
                  Icons.local_drink,
                  size: 18,
                  color: MyApp.themeNotifier.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ),
                label: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('Beer',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: height * 0.05,
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
                    sizeDisplay = _liquorOzStr[2];
                    drinkType = 'Liquor';
                  });

                  isLiquor = true;
                  isBeer = false;
                  isWine = false;
                  ozLength = _liquorOz.length;

                  ref.read(ozController.notifier).setOz(_liquorOz[2]);
                  ref.read(abvController.notifier).setAbv(_liquorAbv[1]);
                },
                icon: Icon(
                  Icons.local_drink_outlined,
                  size: 18,
                  color: MyApp.themeNotifier.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ),
                label: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('Liquor',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: height * 0.05,
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
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    sizeDisplay = _wineOzStr[0];
                    drinkType = 'Wine';
                  });

                  isWine = true;
                  isBeer = false;
                  isLiquor = false;
                  ozLength = _wineOz.length;

                  ref.read(ozController.notifier).setOz(_wineOz[0]);
                  ref.read(abvController.notifier).setAbv(_wineAbv[3]);
                },
                icon: Icon(
                  Icons.local_bar,
                  size: 18,
                  color: MyApp.themeNotifier.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ),
                label: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('Wine',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _countDisplay(double count, Color color, double bacRatio, double width,
          double height) =>
      Stack(
        alignment: const Alignment(0.6, 0.6),
        children: [
          // Sets to 100 if percent goes over 100, sets to 0 if percent goes negative
          Ring(
            percent: (bacRatio) < 1
                ? (bacRatio * 100) > 0
                    ? (bacRatio * 100)
                    : 0
                : 100,
            color: RingColorScheme(ringColor: color),
            radius: height * 0.15,
            width: 13,
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
                  content: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            // Close the SnackBar when the close button is pressed
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          color: Colors.black,
                        ),
                      ),
                      Text(
                          'You have consumed ${count.toStringAsFixed(1)} standard drinks.\n\nA standard drink is equivalent to:\n\n-12 ounces of beer at 5% ABV\n\n-5 ounces of wine at 12% ABV\n\n-1.5 oz of hard liquor at 40% ABV',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  backgroundColor: ref.watch(colorController).withOpacity(0.85),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Container(
                width: height * 0.15 * 2 - 13,
                height: height * 0.15 * 2 - 13,
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
                    count.toStringAsFixed(1),
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
          double genderVal,
          int unit) =>
      Column(
        children: [
          Row(
            children: [
              Container(
                width: (width - 32) / 2 - 3, // width - body column padding
                height: height * 3 / 15,
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

                      ref.read(bacController.notifier).updateBac(
                          weight, genderVal, localc, ref.watch(unitController));

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
                      height: (height * 3 / 15) / 2 - 3,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              MyApp.themeNotifier.value == ThemeMode.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(
                                      0.2), // Change the background color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () => _showDialog(CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: _kItemExtent,
                          // This sets the initial item.
                          scrollController: FixedExtentScrollController(
                            initialItem: currentIndex,
                          ),
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItemIndex) {
                            currentIndex = selectedItemIndex;

                            if (drinkType == 'Liquor') {
                              sizeDisplay = _liquorOzStr[selectedItemIndex];
                              ref
                                  .read(ozController.notifier)
                                  .setOz(_liquorOz[selectedItemIndex]);
                            } else if (drinkType == 'Wine') {
                              sizeDisplay = _wineOzStr[selectedItemIndex];
                              ref
                                  .read(ozController.notifier)
                                  .setOz(_wineOz[selectedItemIndex]);
                            } else if (drinkType == 'Beer') {
                              sizeDisplay = _beerOzStr[selectedItemIndex];
                              ref
                                  .read(ozController.notifier)
                                  .setOz(_beerOz[selectedItemIndex]);
                            }
                          },
                          children:
                              List<Widget>.generate(ozLength, (int index) {
                            if (drinkType == 'Liquor') {
                              return Center(child: Text(_liquorOzStr_[index]));
                            } else if (drinkType == 'Wine') {
                              return Center(child: Text(_wineOzStr_[index]));
                            } else if (drinkType == 'Beer') {
                              return Center(child: Text(_beerOzStr_[index]));
                            }

                            return Center(child: Text('Error'));
                          }),
                        )),
                        child: Text(sizeDisplay,
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
                      height: (height * 3 / 15) / 2 - 3,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              MyApp.themeNotifier.value == ThemeMode.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(
                                      0.2), // Change the background color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
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
                                  child: Text('${_liquorAbv[index]} %'));
                            } else if (drinkType == 'Wine') {
                              return Center(
                                  child: Text('${_wineAbv[index]} %'));
                            } else if (drinkType == 'Beer') {
                              return Center(
                                  child: Text('${_beerAbv[index]} %'));
                            }

                            return Center(child: Text('Error'));
                          }),
                        )),
                        child: Text('${ref.watch(abvController)} %',
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
                  height: height * 0.06,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? Colors.black.withOpacity(0.2)
                              : Colors.white.withOpacity(
                                  0.1), // Change the background color here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      double localc =
                          ref.read(countController.notifier).undoDrink(abv, oz);
                      ref.read(bacController.notifier).updateBac(
                          weight, genderVal, localc, ref.watch(unitController));

                      double localBac = ref.watch(bacController);

                      ref.read(colorController.notifier).changeColor(
                          localBac, recLevel, legalLimit, tolerance);

                      ref.read(drinkController.notifier).undoRecent();
                    },
                    child: Icon(
                      Icons.undo,
                      size: 25,
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
                  height: height * 0.06,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? Colors.black.withOpacity(0.2)
                              : Colors.white.withOpacity(
                                  0.1), // Change the background color here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
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
                      size: 25,
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

  Widget _bacButton(double bac, double width, double height) => SizedBox(
        height: height * 0.05,
        width: width / 2.5,
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
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'BAC: ${bac.toStringAsFixed(3)}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
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
    int unit = ref.watch(unitController);
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
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: height * 0.02),
          child: Center(
            child: _bacButton(bac, width, height),
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
                SizedBox(height: height * 0.1),
                _countDisplay(
                    count,
                    color,
                    findRatio(recLevel, bac, legalLimit, tolerance),
                    width,
                    height),
                Expanded(child: SizedBox(height: height * 0.1)),
                _drinkSelector(height),
                SizedBox(height: 6),
                _inputPanel(width, height, weight, abv, oz, bac, recLevel,
                    legalLimit, tolerance, count, genderVal, unit),
                SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
