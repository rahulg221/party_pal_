import 'package:flutter/material.dart';
import 'package:lift_links/bac_info.dart';
import 'package:lift_links/history.dart';
import 'package:lift_links/homepage.dart';
import 'package:lift_links/providers.dart';
import 'package:lift_links/theme_config.dart';
import 'package:lift_links/tips.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';

//Globals for testing purposes
Color selectedItem = Colors.lightBlue;

void main() {
  // wrap the entire app with a ProviderScope so that widgets
  // will be able to read providers
// add these lines
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            theme: createLightTheme(
              ref.watch(colorController),
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            darkTheme: createDarkTheme(
              ref.watch(colorController),
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            themeMode: currentMode,
            home: const MainPage(title: 'Party Pal App'),
          );
        });
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int? themeFlag = -1; // initializers to hold loaded in data from shared pref
  double weight = 0.0;
  double genderVal = 0.0;
  double age = 0.0;
  double legalLimit = 0.0;
  int recLevel = 0;
  double tolerance = 0.0;
  int unit = 0;
  Color color = Colors.transparent;

  var currentIndex = 0;

  var pageController = PageController(initialPage: 0);

  final screensList = [
    const MyHomePage(title: ''),
    const MyFriendsPage(title: 'Drink History'),
    const MyInfoPage(title: 'BAC Information'),
    //const MyTipsPage(title: 'Tips and Tricks'),
  ];

  _loadApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeFlag = prefs.getInt('theme');
    genderVal = prefs.getDouble('gender') ?? 0.0;
    age = prefs.getDouble('age') ?? 0.0;
    weight = prefs.getDouble('weight') ?? 0.0;
    legalLimit = prefs.getDouble('limit') ?? 0.0;
    recLevel = prefs.getInt('rec') ?? 0;
    tolerance = prefs.getDouble('tolerance') ?? 1.0;
    unit = prefs.getInt('unit') ?? 0;

    ref.read(genderController.notifier).setGender(genderVal);
    ref.read(weightController.notifier).setWeight(weight, unit);
    ref.read(ageController.notifier).setAge(age);
    ref.read(weightController.notifier).setWeight(weight, unit);
    ref.read(limitController.notifier).setLimit(legalLimit);
    ref.read(recController.notifier).setRec(recLevel);
    ref.read(tolController.notifier).setTol(tolerance);
    ref.read(unitController.notifier).setUnit(unit);

    if (themeFlag == 1) {
      MyApp.themeNotifier.value = ThemeMode.light;
    } else {
      MyApp.themeNotifier.value = ThemeMode.dark;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  @override
  Widget build(BuildContext context) {
    Color color = ref.watch(colorController);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          iconSize: 27,
          currentIndex: currentIndex,
          onTap: (newIndex) => pageController.jumpToPage(newIndex),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_bar),
              label: 'Add Drinks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined),
              label: 'Drink History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'BAC Info',
            ),
            /*BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb),
              label: 'Tips',
            ),*/
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (newIndex) => setState(() => currentIndex = newIndex),
        children: screensList,
      ),
    );
  }
}
