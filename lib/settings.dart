import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:lift_links/providers.dart';

class MySettingsPage extends ConsumerStatefulWidget {
  const MySettingsPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends ConsumerState<MySettingsPage> {
  int? themeFlag = -1;
  double tolerance = 1.0;

  String? selectedValue;

  void toggleTheme() {
    MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  void saveInfo(double genderVal, double weight, double age, double legalLimit,
      int recLevel, double tolerance, int unit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (MyApp.themeNotifier.value == ThemeMode.light) {
      themeFlag = 1;
    } else {
      themeFlag = 0;
    }
    prefs.setInt('theme', themeFlag!);
    prefs.setDouble('gender', genderVal);
    prefs.setDouble('weight', weight);
    prefs.setDouble('age', age);
    prefs.setDouble('limit', legalLimit);
    prefs.setInt('rec', recLevel);
    prefs.setDouble('tolerance', tolerance);
    prefs.setInt('unit', unit);
  }

  void resetInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ref.read(genderController.notifier).reset();
    ref.read(weightController.notifier).reset();
    ref.read(ageController.notifier).reset();
    ref.read(limitController.notifier).reset();
    ref.read(recController.notifier).reset();
    ref.read(tolController.notifier).reset();
    ref.read(unitController.notifier).reset();

    prefs.setDouble('gender', 0);
    prefs.setDouble('weight', 0);
    prefs.setDouble('age', 0);
    prefs.setDouble('limit', 0);
    prefs.setInt('rec', 0);
    prefs.setDouble('tolerance', 0.8);
    prefs.setInt('unit', 0);
  }

  Widget _genderButton(double width) => Row(
        children: [
          Container(
            width: (width - 32) / 2 - 3, // width - body column padding
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(genderController) == 0.68
                    ? ref.watch(colorController)
                    : Colors.transparent, // Change the background color here
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                side: BorderSide(
                    // Gets rid of border when selected
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? ref.watch(genderController) == 0.68
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.2)
                        : ref.watch(genderController) == 0.68
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                    width: 2),
              ),
              onPressed: () {
                ref.read(genderController.notifier).setGender(0.68);
              },
              child: Text('Male',
                  style: TextStyle(
                      fontSize: 18,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(genderController) == 0.68
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          SizedBox(width: 6),
          Container(
            width: (width - 32) / 2 - 3, // width - body column padding
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(genderController) == 0.55
                    ? ref.watch(colorController)
                    : Colors.transparent, // Change the background color here
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                side: BorderSide(
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? ref.watch(genderController) == 0.55
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.2)
                        : ref.watch(genderController) == 0.55
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                    width: 2),
              ),
              onPressed: () {
                ref.read(genderController.notifier).setGender(0.55);
              },
              child: Text('Female',
                  style: TextStyle(
                      fontSize: 18,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(genderController) == 0.55
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
        ],
      );

  Widget _unitButtons(double width) => Row(
        children: [
          Container(
            width: (width - 32) / 2 - 3, // width - body column padding
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(unitController) == 2
                    ? ref.watch(colorController)
                    : Colors.transparent, // Change the background color here
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                side: BorderSide(
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? ref.watch(unitController) == 2
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.2)
                        : ref.watch(unitController) == 2
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                    width: 2),
              ),
              onPressed: () {
                ref.read(unitController.notifier).setUnit(2);
              },
              child: FittedBox(
                child: Text('Imperial (oz/lbs)',
                    style: TextStyle(
                        fontSize: 18,
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.black
                            : ref.read(unitController) == 2
                                ? Colors.black
                                : Colors.white)),
              ),
            ),
          ),
          SizedBox(width: 6),
          Container(
            width: (width - 32) / 2 - 3, // width - body column padding
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(unitController) == 1
                    ? ref.watch(colorController)
                    : Colors.transparent, // Change the background color here
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                side: BorderSide(
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? ref.watch(unitController) == 1
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.2)
                        : ref.watch(unitController) == 1
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                    width: 2),
              ),
              onPressed: () {
                ref.read(unitController.notifier).setUnit(1);
              },
              child: Text('Metric (ml/kg)',
                  style: TextStyle(
                      fontSize: 20,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(unitController) == 1
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
        ],
      );

  Widget _saveButton(double width, double weight, double age, double legalLimit,
          double gender, int recLevel, double tolerance, int unit) =>
      Container(
        width: (width - 32), // width - body column padding
        height: 60,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor:
                ref.watch(colorController), // Change the background color here
          ),
          onPressed: () {
            print('Weight: $weight');
            print('Age: $age');
            print('Limit: $legalLimit');
            print('Gender: $gender');
            print('recLevel: $recLevel');
            print('Tolerance: $tolerance');
            print('Unit: $unit');
            saveInfo(
                gender, weight, age, legalLimit, recLevel, tolerance, unit);
            Navigator.pop(context);
          },
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      );

  Widget _recLevel(double width, ThemeMode theme) => Row(
        children: [
          Container(
            width: (width - 32) / 3 - 8, // width - body column padding
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(recController) == 1
                    ? ref.watch(colorController)
                    : Colors.transparent, // Change the background color here
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                side: BorderSide(
                    color: theme == ThemeMode.light
                        ? ref.watch(recController) == 1
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.2)
                        : ref.watch(recController) == 1
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                    width: 2),
              ),
              onPressed: () {
                ref.read(recController.notifier).setRec(1);
              },
              child: Text('Light',
                  style: TextStyle(
                      fontSize: 18,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(recController) == 1
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          Spacer(),
          Container(
            width: (width - 32) / 3 - 8, // width - body column padding
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(recController) == 2
                    ? ref.watch(colorController)
                    : Colors.transparent, // Change the background color here
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                side: BorderSide(
                    color: theme == ThemeMode.light
                        ? ref.watch(recController) == 2
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.2)
                        : ref.watch(recController) == 2
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                    width: 2),
              ),
              onPressed: () {
                ref.read(recController.notifier).setRec(2);
              },
              child: Text('Moderate',
                  style: TextStyle(
                      fontSize: 18,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(recController) == 2
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          Spacer(),
          Container(
            width: (width - 32) / 3 - 8, // width - body column padding
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(recController) == 3
                    ? ref.watch(colorController)
                    : Colors.transparent, // Change the background color here
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                side: BorderSide(
                    color: theme == ThemeMode.light
                        ? ref.watch(recController) == 3
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.2)
                        : ref.watch(recController) == 3
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                    width: 2),
              ),
              onPressed: () {
                ref.read(recController.notifier).setRec(3);
              },
              child: Text('Heavy',
                  style: TextStyle(
                      fontSize: 18,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(recController) == 3
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          SizedBox(width: 6),
        ],
      );

  Widget _textField(
          String hintText, String labelText, double value, int unit) =>
      TextField(
        style: TextStyle(
          color: MyApp.themeNotifier.value == ThemeMode.dark
              ? Colors.white
              : Colors.black,
        ),
        onChanged: (newValue) {
          setState(() {
            switch (labelText) {
              case 'Age':
                double newAge = double.parse(newValue);
                ref.read(ageController.notifier).setAge(newAge);
                break;

              case 'Weight':
                double newWeight = double.parse(newValue);
                ref.read(weightController.notifier).setWeight(newWeight, unit);
                break;

              case 'Legal Limit':
                double newLimit = double.parse(newValue);
                ref.read(limitController.notifier).setLimit(newLimit);
                break;
            }
          });
        },
        decoration: InputDecoration(
          labelText: labelText,
          hintText: value == 0 ? hintText : '$value',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ref.watch(colorController),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyApp.themeNotifier.value == ThemeMode.light
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          labelStyle: Theme.of(context).textTheme.bodySmall,
          hintStyle: TextStyle(
            color: MyApp.themeNotifier.value == ThemeMode.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      );

  Widget _tSlider(double currentTol) => SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: ref.watch(colorController),
          inactiveTrackColor: ref.watch(colorController).withOpacity(0.3),
          thumbColor: ref.watch(colorController),
          overlayColor: ref.watch(colorController),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
          trackHeight: 16.0,
        ),
        child: Slider(
          value: currentTol,
          min: 0.8,
          max: 1.2,
          onChanged: (newValue) {
            setState(() {
              tolerance = newValue;
            });

            ref.read(tolController.notifier).setTol(tolerance);
          },
        ),
      );

  Widget _infoIcon(String message, int duration) => GestureDetector(
        onTap: () {
          // Show the snack bar here.

          final snackBar = SnackBar(
            duration: Duration(seconds: duration),
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
                Text(message,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            backgroundColor: ref.watch(colorController).withOpacity(0.85),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.info_outline,
            color: MyApp.themeNotifier.value == ThemeMode.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double weight = ref.watch(weightController);
    double age = ref.watch(ageController);
    double legalLimit = ref.watch(limitController);
    double genderVal = ref.watch(genderController);
    int recLevel = ref.watch(recController);
    double tolerance = ref.watch(tolController);
    int unit = ref.watch(unitController);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(
              color: MyApp.themeNotifier.value == ThemeMode.light
                  ? Colors.black.withOpacity(0.9)
                  : ref.watch(colorController),
            )),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            iconSize: 25,
            onPressed: () {
              resetInfo();
            },
          ),
          IconButton(
              icon: Icon(
                MyApp.themeNotifier.value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              iconSize: 25,
              onPressed: () {
                MyApp.themeNotifier.value =
                    MyApp.themeNotifier.value == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
              }),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
            // Passing the variable back to the previous page when the arrow back icon is tapped
            //Navigator.pop(context, _variableFromProfile);
          },
        ),
        backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
            ? ref.watch(colorController)
            : Colors.black, // over rules theme
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 0.0),
                  alignment: Alignment.topCenter,
                  width: width - 32,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 12),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color:
                                  MyApp.themeNotifier.value == ThemeMode.light
                                      ? Colors.black.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.2),
                            ),
                            height: 50,
                            width: width - 32,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('Gender',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall),
                              ),
                            )),
                        SizedBox(height: 25),
                        _genderButton(width),
                        SizedBox(height: 25),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: MyApp.themeNotifier.value == ThemeMode.light
                                ? Colors.black.withOpacity(0.2)
                                : Colors.white.withOpacity(0.2),
                          ),
                          height: 50,
                          width: width - 32,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Unit System',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        _unitButtons(width),
                        SizedBox(height: 25),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color:
                                  MyApp.themeNotifier.value == ThemeMode.light
                                      ? Colors.black.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.2),
                            ),
                            height: 50,
                            width: width - 32,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('Age',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall),
                              ),
                            )),
                        SizedBox(height: 25),
                        _textField('Please enter your age in years.', 'Age',
                            age, unit),
                        SizedBox(height: 25),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color:
                                  MyApp.themeNotifier.value == ThemeMode.light
                                      ? Colors.black.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.2),
                            ),
                            height: 50,
                            width: width - 32,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('Weight',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall),
                              ),
                            )),
                        SizedBox(height: 25),
                        _textField('Please enter your weight.', 'Weight',
                            weight, unit),
                        SizedBox(height: 25),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: MyApp.themeNotifier.value == ThemeMode.light
                                ? Colors.black.withOpacity(0.2)
                                : Colors.white.withOpacity(0.2),
                          ),
                          height: 50,
                          width: width - 32,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              // Use Stack to overlay widgets.
                              children: [
                                Center(
                                  child: Text(
                                    'Driving Legal Limit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ),
                                _infoIcon(
                                    'The legal driving limit is 0.08% in the majority of states in the U.S.A.\n\nHowever, the legal limit in some states and other countries may vary.\n\nSearch up the legal limit for your country or region and input the percentage in here.',
                                    6)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        _textField('Please enter the legal driving limit.',
                            'Legal Limit', legalLimit, unit),
                        SizedBox(height: 25),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: MyApp.themeNotifier.value == ThemeMode.light
                                ? Colors.black.withOpacity(0.2)
                                : Colors.white.withOpacity(0.2),
                          ),
                          height: 50,
                          width: width - 32,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              // Use Stack to overlay widgets.
                              children: [
                                Center(
                                  child: Text(
                                    'Recommendation Level',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ),
                                _infoIcon(
                                    'Select a level based on your goal for the night.\n\nLight - Pick this setting if you plan to drive home tonight.\n\nModerate - Pick this setting for most situations where you are NOT driving.\n\nHeavy - Pick this setting if you want to get absolutely wasted - but safely.',
                                    10)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        _recLevel(
                          width,
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? ThemeMode.light
                              : ThemeMode.dark,
                        ),
                        SizedBox(height: 25),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: MyApp.themeNotifier.value == ThemeMode.light
                                ? Colors.black.withOpacity(0.2)
                                : Colors.white.withOpacity(0.2),
                          ),
                          height: 50,
                          width: width - 32,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              // Use Stack to overlay widgets.
                              children: [
                                Center(
                                  child: Text(
                                    'Tolerance Level',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ),
                                _infoIcon(
                                    'Use this tolerance scale to finely tune your recommendation system.\n\nIf you feel that the recommendation system stops you too early, increase your tolerance scale and vice versa.',
                                    6)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        _tSlider(tolerance),
                        Container(
                          width: width - 64,
                          child: Center(
                            child: Row(
                              children: [
                                Text('Low', //${tolerance.toStringAsFixed(0)}
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                Spacer(),
                                Text(
                                    'Average', //${tolerance.toStringAsFixed(0)}
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                Spacer(),
                                Text('High', //${tolerance.toStringAsFixed(0)}
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _saveButton(width, weight, age, legalLimit, genderVal,
                    recLevel, tolerance, unit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
