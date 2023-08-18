import 'package:flutter/material.dart';
import 'package:lift_links/main.dart';

//Reusable snack bar for displaying sober countdown, used on every page by clicking Car icon in AppBar
class ReusableSnackBar extends SnackBar {
  ReusableSnackBar({
    super.key,
    required BuildContext context,
    required String timeTillDrive,
    required double bac,
    Color backgroundColor = Colors.transparent,
    Duration duration = const Duration(seconds: 8),
  }) : super(
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
                  'BAC will reach legal limit in:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeTillDrive,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height * 0.1,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                Text(
                  'Hrs               Mins\n',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                Text(
                  bac >= 0.08
                      ? 'It is currently illegal to drive at the moment.'
                      : 'Your estimated BAC is below the indicated legal limit.',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  bac >= 0.08
                      ? 'Call a friend or a ride share service to take you home.'
                      : 'This is just an estimate, make sure to use your own judgment to determine if you should drive.',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            duration: duration,
            backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
                ? Colors.white
                : backgroundColor.withOpacity(0.95));
}
