import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lift_links/helpers/sql_helper.dart';
import 'package:lift_links/widgets/drive_alert.dart';
import 'package:lift_links/main.dart';
import 'package:lift_links/screens/settings.dart';
import 'package:activity_ring/activity_ring.dart';
import 'package:lift_links/helpers/theme_config.dart';
import 'package:lift_links/helpers/providers.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String drinkType = 'Beer';
  int ozLength = 3;
  int abvLength = 6;
  String listName = '';

  //Flags if sms for legal limit has been sent already
  int smsFlag1 = 0;
  //Flags if sms for overall limit has been sent already
  int smsFlag2 = 0;

  int currentIndex = 1;
  int currentAbvIndex = 1;

  bool isBeer = true;
  bool isWine = false;
  bool isLiquor = false;
  final double _kItemExtent = 32.0;

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

  //Changes to other theme option
  void toggleTheme() {
    MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  //Sends text message to specified recipients
  //Note: need to download from flutter sms repo and manually set path in pubspec.yaml
  /*
  void _sendSMS(String message, List<String> recipents) async {
    String result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(result);
  }*/

  void _friendMessage() {
    /*if (ref.watch(recipientController)[0] != '') {
      if (ref.watch(colorController) == Colors.red.shade600) {
        if (smsFlag2 == 0) {
          _sendSMS('[PartyPal] Cut me off! I have surpassed my limit.',
              ref.watch(recipientController));

          smsFlag2 = 1;
        }
      } else if (ref.watch(bacController) >= ref.watch(limitController)) {
        if (smsFlag1 == 0) {
          _sendSMS('[PartyPal] Take away my keys! I am past the legal limit.',
              ref.watch(recipientController));

          smsFlag1 = 1;
        }
      }
    }
    _sendSMS(
        '[PartyPal] I am at ${ref.watch(countController)} drinks and my BAC is ${ref.watch(bacController)}.',
        ref.watch(recipientController)); */
  }

  //Loads in count and bac if app is closed
  void _loadInfo() async {
    try {
      double bac = await SQLHelper.getBac();
      double count = await SQLHelper.getCount();

      ref.read(bacController.notifier).set(bac);
      ref.read(countController.notifier).set(count);
    } finally {
      await SQLHelper.closeDatabase();
    }

    ref.read(colorController.notifier).changeColor(
        ref.watch(bacController),
        ref.watch(recController),
        ref.watch(limitController),
        ref.watch(tolController));
  }

  //Deletes count/bac info in database
  void _deleteInfo() async {
    try {
      await SQLHelper.deleteInfo();
    } finally {
      await SQLHelper.closeDatabase();
    }
  }

  //Calculates ratio of current BAC / max BAC limit to determine Ring percentage
  double findRatio(
      int recLevel, double bac, double legalLimit, double tolerance) {
    if (recLevel == 1) {
      return bac / (legalLimit - 0.02);
    } else if (recLevel == 2) {
      return bac / (0.11 * tolerance);
    } else if (recLevel == 3) {
      return bac / (0.14 * tolerance);
    }

    return 0.0;
  }

  @override
  void initState() {
    //Loads in count/bac and changes color
    //_loadInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Opens size/percentage selector
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  //Widget for selecting Beer, Liquor, or Wine
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

                  currentIndex = 1;
                  currentAbvIndex = 1;
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
          const SizedBox(width: 4),
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

                  currentIndex = 2;
                  currentAbvIndex = 1;
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
          const SizedBox(width: 4),
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

                  currentIndex = 0;
                  currentAbvIndex = 3;
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

  //Widget for Ring and standard drink count display
  Widget _countDisplay(double count, Color color, double bacRatio, double width,
          double height) =>
      Stack(
        alignment: const Alignment(0.6, 0.6),
        children: [
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
                final snackBar = SnackBar(
                  duration: const Duration(seconds: 3),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  content: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          color: Colors.black,
                        ),
                      ),
                      Text(
                          'You have consumed ${count.toStringAsFixed(1)} standard drinks.\n\nA standard drink is equivalent to:\n\n-12 ounces of beer at 5% ABV\n\n-5 ounces of wine at 12% ABV\n\n-1.5 oz of hard liquor at 40% ABV',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  backgroundColor: ref.watch(colorController),
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
                            : Colors.grey.shade900.withOpacity(0.5),
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

  //Widget for inputting drinks and undo/refresh
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
              SizedBox(
                width: (width - 32) / 2 - 3,
                height: height * 3 / 15,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.black.withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  onPressed: () {
                    if (ref.watch(countController) == 0) {
                      ref.read(bacController.notifier).startTimer();
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

                      ref.read(colorController.notifier).changeColor(
                          ref.watch(bacController),
                          recLevel,
                          legalLimit,
                          tolerance);

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
              const SizedBox(width: 4),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: (width - 32) / 2 - 2,
                      height: (height * 3 / 15) / 2 - 2,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              MyApp.themeNotifier.value == ThemeMode.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () => _showDialog(CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: _kItemExtent,
                          scrollController: FixedExtentScrollController(
                            initialItem: currentIndex,
                          ),
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

                            return const Center(child: Text('Error'));
                          }),
                        )),
                        child: Text(sizeDisplay,
                            style: Theme.of(context).textTheme.displayMedium),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: (width - 32) / 2 - 2,
                      height: (height * 3 / 15) / 2 - 2,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              MyApp.themeNotifier.value == ThemeMode.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () => _showDialog(CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: _kItemExtent,
                          scrollController: FixedExtentScrollController(
                            initialItem: currentAbvIndex,
                          ),
                          onSelectedItemChanged: (int selectedItemIndex) {
                            currentAbvIndex = selectedItemIndex;

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

                            return const Center(child: Text('Error'));
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
          const SizedBox(height: 4),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: (width - 32) / 2 - 3,
                  height: height * 0.06,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? Colors.black.withOpacity(0.2)
                              : Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      double localc =
                          ref.read(countController.notifier).undoDrink();

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
              const SizedBox(width: 4),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
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

                      ref.read(bacController.notifier).stopTimer();

                      _deleteInfo();
                      smsFlag1 = 0;
                      smsFlag2 = 0;
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

  //Widget for BAC display at top of screen
  Widget _bacButton(double bac, double width, double height) => SizedBox(
        height: height * 0.05,
        width: width / 2.5,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
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

  //Info warning if user info is not entered
  void _infoWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: const Text(
              'Please enter your information in settings before proceeding.',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK',
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: fancyStyle, fontSize: 25),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: bac >= 0.08
                ? const Icon(
                    Icons.car_crash,
                  )
                : const Icon(
                    Icons.directions_car,
                  ),
            iconSize: 25,
            onPressed: () {
              final driveAlert = ReusableSnackBar(
                context: context,
                timeTillDrive: ref.read(formatController.notifier).getHrsMins(
                    (ref.watch(bacController) - legalLimit) / 0.015),
                backgroundColor: ref.watch(colorController),
                duration: const Duration(seconds: 5),
                bac: ref.watch(bacController),
              );

              ScaffoldMessenger.of(context).showSnackBar(driveAlert);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            iconSize: 25,
            onPressed: () {
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
                Expanded(child: SizedBox(height: height * 0.1)),
                _countDisplay(
                    count,
                    color,
                    findRatio(recLevel, bac, legalLimit, tolerance),
                    width,
                    height),
                SizedBox(height: height * 0.1),
                _drinkSelector(height),
                const SizedBox(height: 4),
                _inputPanel(width, height, weight, abv, oz, bac, recLevel,
                    legalLimit, tolerance, count, genderVal, unit),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
