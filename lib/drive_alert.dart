import 'package:flutter/material.dart';

class ReusableSnackBar extends SnackBar {
  ReusableSnackBar({super.key, 
    required BuildContext context,
    required String timeTillDrive,
    required double bac,
    Color backgroundColor = Colors.transparent,
    Duration duration = const Duration(seconds: 8),
  }) : super(
          content: Column(
            children: [
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
              /*
              Icon(
                bac >= 0.08
                    ? Icons.sentiment_very_dissatisfied
                    : Icons.sentiment_very_satisfied,
                size: 60,
                color: Colors.black,
              ),*/
              Text(
                'BAC will reach the legal driving limit in:\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.01 * 2,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              Text(
                timeTillDrive,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.01 * 10,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              Text(
                'hrs               mins\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.01 * 2,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              Text(
                bac >= 0.08
                    ? 'Call a friend or a ride share service to take you home.'
                    : 'Your estimated BAC is below the indicated legal limit.',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.01 * 2.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This is just an estimate, make sure to use your own judgment to determine if you should drive',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.01 * 2.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1,
                ),
              ),
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          duration: duration,
          backgroundColor: backgroundColor.withOpacity(0.85),
        );
}
