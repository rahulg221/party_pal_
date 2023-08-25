import 'package:flutter/material.dart';

import 'package:lift_links/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerDialog extends StatelessWidget {
  const DisclaimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: 1.1,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: AlertDialog(
          title: const Text("Disclaimer",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: const SingleChildScrollView(
            child: Text(
              "PartyPal is designed to provide general information and guidance regarding Blood Alcohol Concentration (BAC) levels and responsible drinking behavior. While the app may offer valuable insights and suggestions, it is imperative to recognize that it is not a substitute for professional medical advice, legal counsel, or individual judgment. Users are urged to exercise discretion and common sense when interpreting the app's recommendations and utilizing its features.\n\n"
              "1. BAC Accuracy and Variability:\n"
              "The BAC calculations provided by the app are based on standard algorithms and the information entered by the user. However, individual factors such as metabolism, body composition, and food intake can significantly affect BAC levels. Users should acknowledge that the app's calculations might not always reflect precise real-time BAC levels and should not be used as a definitive measure.\n\n"
              "2. Legal Implications:\n"
              "The app's suggested drinking and stopping points are not a guarantee of legal compliance with local laws and regulations related to alcohol consumption and driving. Users must understand that legal BAC limits vary between jurisdictions and that even being within legal limits does not necessarily ensure safe driving. Always consult local laws and refrain from driving if there is any doubt about sobriety.\n\n"
              "3. Individual Responsibility:\n"
              "The app's recommendations are based on general guidelines and assumptions. Each individual's tolerance to alcohol differs, and the app's suggestions should not override personal judgment. Users are accountable for their own actions and should never drink and drive, regardless of the app's recommendations.\n\n"
              "4. Health Considerations:\n"
              "Certain health conditions, medications, or other factors can influence alcohol's effects on the body and may not be accurately considered by the app. Users with medical concerns should consult a healthcare professional before making decisions about alcohol consumption.\n\n"
              "5. User Accountability:\n"
              "By using the app, users assume full responsibility for their actions and decisions. The app's creators, developers, and affiliates are not liable for any consequences arising from the use or misuse of the app's features or information.\n\n"
              "6. Always Prioritize Safety:\n"
              "The primary goal of the app is to promote responsible drinking behavior and safe decision-making. If at any point users feel impaired or unsure of their ability to drive safely, they should opt for alternate transportation methods or arrange for a sober driver.\n\n"
              "7. App Updates and Accuracy:\n"
              "The app's functionality and features may evolve over time, and its accuracy may improve with updates. However, users should not solely rely on the app's information but instead combine it with common sense, responsible behavior, and awareness of their own physical condition.",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("I Understand and Agree",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                dFlag = 1;
                prefs.setInt('dflag', dFlag);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LifeCycle(
                      child: MainPage(
                        title: 'Party Pal App',
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 72, 186, 131),
        ),
      ),
    );
  }
}
