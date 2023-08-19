import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:lift_links/helpers/providers.dart';

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

  //Changes to other theme option
  void toggleTheme() {
    MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  //Saves info to shared preferences
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

  //Sets all values to 0 and saves to shared preferences
  void resetInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ref.read(genderController.notifier).reset();
    ref.read(weightController.notifier).reset();
    ref.read(ageController.notifier).reset();
    ref.read(limitController.notifier).reset();
    ref.read(recController.notifier).reset();
    ref.read(tolController.notifier).reset();
    ref.read(unitController.notifier).reset();
    ref.read(recipientController.notifier).reset();

    prefs.setDouble('gender', 0);
    prefs.setDouble('weight', 0);
    prefs.setDouble('age', 0);
    prefs.setDouble('limit', 0);
    prefs.setInt('rec', 0);
    prefs.setDouble('tolerance', 0.8);
    prefs.setInt('unit', 0);
  }

  //Widget for selecting gender
  Widget _genderButton(double width, double height) => Row(
        children: [
          SizedBox(
            width: (width - 32) / 2 - 3,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(genderController) == 0.68
                    ? ref.watch(colorController)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                side: BorderSide(
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
                      fontSize: height * 0.01 * 2,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(genderController) == 0.68
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: (width - 32) / 2 - 3,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(genderController) == 0.55
                    ? ref.watch(colorController)
                    : Colors.transparent,
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
                      fontSize: height * 0.01 * 2,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(genderController) == 0.55
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
        ],
      );

  //Widget for selecting unit Imperial/Metric
  Widget _unitButtons(double width, double height) => Row(
        children: [
          SizedBox(
            width: (width - 32) / 2 - 3,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(unitController) == 2
                    ? ref.watch(colorController)
                    : Colors.transparent,
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
              child: Text('Imperial (oz/lbs)',
                  style: TextStyle(
                      fontSize: height * 0.01 * 2,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(unitController) == 2
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: (width - 32) / 2 - 3,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(unitController) == 1
                    ? ref.watch(colorController)
                    : Colors.transparent,
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
                      fontSize: height * 0.01 * 2,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(unitController) == 1
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
        ],
      );

  //Widget for the save button
  Widget _saveButton(
          double width,
          double height,
          double weight,
          double age,
          double legalLimit,
          double gender,
          int recLevel,
          double tolerance,
          int unit) =>
      SizedBox(
        width: (width - 32),
        height: 60,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ref.watch(colorController),
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
              fontSize: height * 0.01 * 2.5,
              color: Colors.black,
            ),
          ),
        ),
      );

  //Widget for selecting recommendation level Light, Heavy, Moderate
  Widget _recLevel(double width, double height, ThemeMode theme) => Row(
        children: [
          SizedBox(
            width: (width - 32) / 3 - 8,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(recController) == 1
                    ? ref.watch(colorController)
                    : Colors.transparent,
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
                      fontSize: height * 0.01 * 2,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(recController) == 1
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: (width - 32) / 3 - 8,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(recController) == 2
                    ? ref.watch(colorController)
                    : Colors.transparent,
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
                      fontSize: height * 0.01 * 2,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(recController) == 2
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: (width - 32) / 3 - 8,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ref.watch(recController) == 3
                    ? ref.watch(colorController)
                    : Colors.transparent,
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
                      fontSize: height * 0.01 * 2,
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? Colors.black
                          : ref.read(recController) == 3
                              ? Colors.black
                              : Colors.white)),
            ),
          ),
          const SizedBox(width: 6),
        ],
      );

  //Widget for reusable text fields for Age, Weight, Legal Limit
  Widget _textField(String hintText, String labelText, double value) =>
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
                ref.read(weightController.notifier).setWeight(newWeight);
                break;

              case 'Legal Limit':
                double newLimit = double.parse(newValue);
                ref.read(limitController.notifier).setLimit(newLimit);
                break;

              case 'PhoneNum':
                List<String> newRecipient = [];
                newRecipient.add(newValue);
                ref
                    .read(recipientController.notifier)
                    .setRecipient(newRecipient);
            }
          });
        },
        decoration: InputDecoration(
          hintText: labelText == 'PhoneNum'
              ? ref.watch(recipientController)[0] == ''
                  ? hintText
                  : ref.watch(recipientController)[0]
              : value == 0
                  ? hintText
                  : '$value',
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
        ],
      );

  //Widget for tolerance scale slider
  Widget _tSlider(double currentTol) => SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: ref.watch(colorController),
          inactiveTrackColor: ref.watch(colorController).withOpacity(0.3),
          thumbColor: ref.watch(colorController),
          overlayColor: ref.watch(colorController),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
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

  //Widget for reusable info icons
  Widget _infoIcon(String message, int duration) => GestureDetector(
        onTap: () {
          final snackBar = SnackBar(
            duration: Duration(seconds: duration),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    20.0), // Adjust the top left corner radius here
                topRight: Radius.circular(
                    20.0), // Adjust the top right corner radius here
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
                      // Close the SnackBar when the close button is pressed
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    color: Colors.black,
                  ),
                ),
                Text(message,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            backgroundColor: ref.watch(colorController),
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
            icon: const Icon(
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
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          iconSize: 20,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          },
        ),
        backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
            ? ref.watch(colorController)
            : Colors.black,
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  alignment: Alignment.topCenter,
                  width: width - 32,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 12),
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
                                        .displayMedium),
                              ),
                            )),
                        const SizedBox(height: 25),
                        _genderButton(width, height),
                        const SizedBox(height: 25),
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
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _unitButtons(width, height),
                        const SizedBox(height: 25),
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
                                        .displayMedium),
                              ),
                            )),
                        const SizedBox(height: 25),
                        _textField(
                            'Please enter your age in years.', 'Age', age),
                        const SizedBox(height: 25),
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
                                        .displayMedium),
                              ),
                            )),
                        const SizedBox(height: 25),
                        _textField(
                          unit == 1
                              ? 'Please enter your weight in kgs.'
                              : 'Please enter your weight in lbs.',
                          'Weight',
                          weight,
                        ),
                        const SizedBox(height: 25),
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
                              children: [
                                Center(
                                  child: Text(
                                    'Driving Legal Limit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ),
                                _infoIcon(
                                    'The legal driving limit is 0.08% in the majority of states in the U.S.A.\n\nHowever, the legal limit in some states and other countries may vary.\n\nSearch up the legal limit for your country or region and input the percentage in here.',
                                    6)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _textField('Please enter the legal driving limit.',
                            'Legal Limit', legalLimit),
                        const SizedBox(height: 25),
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
                              children: [
                                Center(
                                  child: Text(
                                    "Buddy System",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ),
                                _infoIcon(
                                    "Enter a trusted friend's phone # to give them updates as you drink.\n\nPartyPal will prompt you to send them a text message when you exceed the driving legal limit, enter the slow-down range, or surpass your limit.\n\nLeave this empty if you do not want to use this feature.",
                                    6)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _textField('Please enter a valid 10 digit phone number',
                            'PhoneNum', 0),
                        const SizedBox(height: 25),
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
                              children: [
                                Center(
                                  child: Text(
                                    'Recommendation Level',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ),
                                _infoIcon(
                                    'Light - This setting will cut you off slightly before you reach the legal driving limit. Ideal for a few drinks with dinner.\n\nModerate - This setting will cut you off at a 0.11% BAC with an average tolerance level. Perfect drunk for a night out with friends.\n\nHeavy - This setting will cut you off at a 0.14% BAC with an average tolerance level. Pick this if you want to get wasted, but safely.',
                                    12)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _recLevel(
                          width,
                          height,
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? ThemeMode.light
                              : ThemeMode.dark,
                        ),
                        const SizedBox(height: 25),
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
                              children: [
                                Center(
                                  child: Text(
                                    'Tolerance Level',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ),
                                _infoIcon(
                                    'Use this tolerance scale to finely tune your recommendation system.\n\nIf you feel that the recommendation system is not accurate for you, you can raise or lower your BAC cut-off by up to 20% with this slider.',
                                    10)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _tSlider(tolerance),
                        SizedBox(
                          width: width - 64,
                          child: Center(
                            child: Row(
                              children: [
                                Text('Low',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                const Spacer(),
                                Text('Average',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                const Spacer(),
                                Text('High',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _saveButton(width, height, weight, age, legalLimit,
                    genderVal, recLevel, tolerance, unit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
