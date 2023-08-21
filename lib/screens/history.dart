import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lift_links/widgets/drive_alert.dart';
import 'package:lift_links/screens/settings.dart';
import 'package:lift_links/helpers/theme_config.dart';
import '../main.dart';
import 'package:lift_links/helpers/providers.dart';

class MyHistoryPage extends ConsumerStatefulWidget {
  const MyHistoryPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHistoryPage> createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends ConsumerState<MyHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  //Changes to other theme option
  void toggleTheme() {
    MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  //Widget for listing drinks of the night
  Widget _drinkList(double width, double height, List<Drink> drinks) =>
      Material(
        elevation: 6,
        color: MyApp.themeNotifier.value == ThemeMode.light
            ? Colors.white
            : Colors.black,
        shape: const RoundedRectangleBorder(
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
                    ? ref.watch(colorController)
                    : Colors.grey.shade900.withOpacity(0.5),
                MyApp.themeNotifier.value == ThemeMode.light
                    ? ref.watch(colorController).withOpacity(0.9)
                    : Colors.black,
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              Drink drink = drinks[index];
              String time = ref
                  .read(formatController.notifier)
                  .getTimestamp(drink.timestamps);
              return ListTile(
                title: Text(
                  drink.type,
                  style: TextStyle(
                    fontSize: height * 0.01 * 2.5,
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? Colors.black.withOpacity(0.9)
                        : ref.watch(colorController),
                    fontFamily: fontStyle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  time,
                  style: TextStyle(
                    fontSize: height * 0.01 * 2.5,
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? Colors.black.withOpacity(0.9)
                        : ref.watch(colorController),
                    fontFamily: fontStyle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${drink.percentage}%',
                      style: TextStyle(
                        fontSize: height * 0.01 * 2.5,
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.black.withOpacity(0.9)
                            : ref.watch(colorController),
                        fontFamily: fontStyle,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${drink.size} oz',
                      style: TextStyle(
                        fontSize: height * 0.01 * 2.5,
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.black.withOpacity(0.9)
                            : ref.watch(colorController),
                        fontFamily: fontStyle,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

  //Widget to display number of standard drinks
  Widget _drinkDisplay(double count, double width, double height) => Material(
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
                    'You have consumed: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        count.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'std. drinks',
                        style: Theme.of(context).textTheme.headlineSmall,
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
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Center(
            child: SizedBox(
              width: width - 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 25),
                  _drinkDisplay(count, width, height),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? "Today's Drinks"
                              : "Tonight's Drinks",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(child: _drinkList(width, height, drinks)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
