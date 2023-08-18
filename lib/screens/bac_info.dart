import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lift_links/widgets/drive_alert.dart';
import 'package:lift_links/screens/settings.dart';
import 'package:lift_links/main.dart';
import 'package:lift_links/helpers/providers.dart';

class MyInfoPage extends ConsumerStatefulWidget {
  const MyInfoPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends ConsumerState<MyInfoPage> {
  final ScrollController _scrollController = ScrollController();

  //Changes to other theme option
  void toggleTheme() {
    MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  //Returns different common effects when BAC reaches different levels
  String commonEffects(double bac) {
    if (bac < 0.02) {
      return "Nothing. You're basically sober.";
    } else if (bac >= 0.02 && bac < 0.05) {
      return '• muscle relaxation\n• altered mood\n• increased body warmth\n• decline in visual function\n• diminished capacity to multitask\n• loss of judgment';
    } else if (bac >= 0.05 && bac < 0.08) {
      return '• loss of fine motor control\n• exaggerated behavior\n• reduced coordination\n• lowered reaction time\n• impaired judgment\n• low alertness\n• heightened mood\n• lack of inhibition';
    } else if (bac >= 0.08 && bac < 0.10) {
      return '• small and large motor function decline\n• poor hearing, seeing, speaking, and coordination\n• short-term memory loss\n• inability to concentrate\n• impaired perception\n• reduced cognitive processing speed';
    } else if (bac >= 0.10 && bac < 0.15) {
      return '• noticeable lack of reaction time\n• slurred speech\n• slowed thinking\n• poor coordination';
    } else if (bac >= 0.15) {
      return '• major loss of motor control\n• poor or no balance\n• severe attention and reaction deficits\n• inability to cognitively process sounds or visuals\n• nausea or vomiting';
    }

    return '';
  }

  //Widget to display BAC
  Widget _bacDisplay(double bac, double width, double height) => Material(
        elevation: 6,
        color: MyApp.themeNotifier.value == ThemeMode.light
            ? Colors.white
            : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
                      ? ref.watch(colorController)
                      : Colors.grey.shade900.withOpacity(0.5),
                  MyApp.themeNotifier.value == ThemeMode.light
                      ? ref.watch(colorController).withOpacity(0.9)
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
                    'Your estimated BAC level is: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      '${bac.toStringAsFixed(3)}%',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  //Reusable text widget to display different pieces of information
  Widget _textContainer(double height, double width, String text) => Material(
        elevation: 6,
        color: MyApp.themeNotifier.value == ThemeMode.light
            ? Colors.white
            : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: width - 32,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MyApp.themeNotifier.value == ThemeMode.light
                      ? ref.watch(colorController)
                      : Colors.grey.shade900.withOpacity(0.5),
                  MyApp.themeNotifier.value == ThemeMode.light
                      ? ref.watch(colorController).withOpacity(0.9)
                      : Colors.black,
                ],
              ),
              borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double bac = ref.watch(bacController);
    double legalLimit = ref.watch(limitController);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
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
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Center(
            child: SizedBox(
              width: width - 12,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 25),
                      _bacDisplay(bac, width, height),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('You may experience',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                      ),
                      const SizedBox(height: 5),
                      _textContainer(height, width, commonEffects(bac)),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('What is BAC?',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                      ),
                      const SizedBox(height: 5),
                      _textContainer(
                        height,
                        width,
                        'Blood Alcohol Concentration (BAC) refers to the percent of alcohol in your blood stream. The higher your BAC levels, the more impaired you may feel. Understanding your BAC level is important for making good choices when drinking.',
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('How is BAC calculated?',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                      ),
                      const SizedBox(height: 5),
                      _textContainer(
                        height,
                        width,
                        "Blood Alcohol Concentration (BAC) is most accurately measured by a blood test or a breathalyzer. This app utilizes a modified version of the Widmark's algorithm, which uses the user's gender, weight, and the drinking time span to calculate an estimated BAC level. This number is just an estimate, so never solely rely on this calculation to determine whether or not you should drive.",
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'What is the legal BAC limit for driving?',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                      ),
                      const SizedBox(height: 5),
                      _textContainer(
                        height,
                        width,
                        "The legal BAC limit for driving varies by location, but it's commonly around 0.08%. If your BAC is equal to or higher than this, you could face legal consequences for driving under the influence.",
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('How can I sober up faster?',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                      ),
                      const SizedBox(height: 5),
                      _textContainer(
                        height,
                        width,
                        "Alcohol leaves your system at a rate of about 0.015% BAC per hour. Despite the popular belief that water and food can help you sober up faster, the only way to sober up is through time.",
                      ),
                      const SizedBox(height: 25),
                      Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'What are the signs of alcohol poisoning?',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                          )),
                      const SizedBox(height: 5),
                      _textContainer(height, width,
                          "Signs of alcohol poisoning include confusion, vomiting, slow or irregular breathing, and passing out. If you or someone else shows these signs after drinking, seek immediate medical help. Until help arrives, place them on their side, and keep them warm and hydrated."),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
