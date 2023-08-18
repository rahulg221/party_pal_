import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Object for drink
class Drink {
  final String type;
  double percentage = 0.0;
  double size = 0.0;
  DateTime timestamps;

  Drink(
      {required this.type,
      required this.percentage,
      required this.size,
      required this.timestamps});
}

class CountNotifier extends StateNotifier<double> {
  CountNotifier() : super(0);

  //Adds drink
  double addDrink(double abv, double oz) {
    state = state + (abv / 100 * oz) / 0.6;
    return state;
  }

  //Removes most recent drink
  double undoDrink(double abv, double oz) {
    if (state - (abv / 100 * oz) / 0.6 >= 0) {
      state = state - (abv / 100 * oz) / 0.6;
    } else {
      state = 0;
    }

    return state;
  }

  //Resets count to 0
  double reset() {
    state = 0;
    return state;
  }
}

class BacNotifier extends StateNotifier<double> {
  BacNotifier() : super(0);
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the notifier is disposed
    super.dispose();
  }

  //Starts timer and decrements bac
  void startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (state > 0) {
          state -= 0.015 * (1 / 3600);
        } else {
          stopTimer();
        }
      });
    }
  }

  //Stops timer
  void stopTimer() {
    _timer?.cancel();
  }

  //Updates bac based on new drinks added
  void updateBac(double weight, double genderVal, double count, int unit) {
    double newBac = 0.0;
    if (weight == 0 || genderVal == 0) {
      return;
    } else {
      if (unit == 1) {
        //Calculation for weight in kgs
        newBac = 100 * (count * 14) / (2.2 * weight * 454 * genderVal);
      } else if (unit == 2) {
        //Calculation for weight in lbs
        newBac = 100 * (count * 14) / (weight * 454 * genderVal);
      }

      if (newBac >= 0) {
        state = newBac;
      } else {
        state = 0;
      }
    }
  }

  //Updates bac for time elapsed from when it goes into hide and its resumed
  void appResume(DateTime timePaused) {
    double newBac = 0.0;

    DateTime currentTime = DateTime.now();
    Duration diff = currentTime.difference(timePaused);
    int secDiff = diff.inSeconds;

    newBac = state - (0.015 * (secDiff / 3600));

    if (newBac >= 0) {
      state = newBac;
    } else {
      state = 0;
    }
  }

  //Resets bac to 0
  void reset() {
    state = 0;
  }
}

class WeightNotifier extends StateNotifier<double> {
  WeightNotifier() : super(0);

  //Sets weight
  void setWeight(double weight) {
    state = weight;
  }

  //Resets weight to 0
  void reset() {
    state = 0;
  }
}

class AgeNotifier extends StateNotifier<double> {
  AgeNotifier() : super(0);

  //Sets age
  void setAge(double age) {
    state = age;
  }

  //Resets age to 0
  void reset() {
    state = 0;
  }
}

class LimitNotifier extends StateNotifier<double> {
  LimitNotifier() : super(0);

  //Sets legal limit
  void setLimit(double legalLimit) {
    state = legalLimit;
  }

  //Resets limit to 0
  void reset() {
    state = 0;
  }
}

class GenderNotifier extends StateNotifier<double> {
  GenderNotifier() : super(0);

  //Sets gender val, 0.68 for male and 0.55 for female
  void setGender(double genderVal) {
    state = genderVal;
  }

  //Resets gender to 0
  void reset() {
    state = 0;
  }
}

class AbvNotifier extends StateNotifier<double> {
  //Default abv is 5%
  AbvNotifier() : super(5.0);

  //Sets abv
  void setAbv(double abv) {
    state = abv;
  }

  //Resets abv to 0
  void reset() {
    state = 0;
  }
}

class OzNotifier extends StateNotifier<double> {
  //Default size is 12 oz
  OzNotifier() : super(12.0);

  //Sets size
  void setOz(double oz) {
    state = oz;
  }

  //Resets size to 0
  void reset() {
    state = 0;
  }
}

class RecNotifier extends StateNotifier<int> {
  RecNotifier() : super(0);

  //Sets recommendation level
  void setRec(int recLevel) {
    state = recLevel;
  }

  //Resets recommendation level to 0
  void reset() {
    state = 0;
  }
}

class TolNotifier extends StateNotifier<double> {
  TolNotifier() : super(0);

  //Sets tolerance
  void setTol(double tolerance) {
    state = tolerance;
  }

  //Resets tolerance to lowest setting of 0.8
  void reset() {
    state = 0.8;
  }
}

class UnitNotifier extends StateNotifier<int> {
  UnitNotifier() : super(0);

  //Sets unit to 1 for Metric, 2 for Imperial
  void setUnit(int unit) {
    state = unit;
  }

  //Resets unit to 0
  void reset() {
    state = 0;
  }
}

class ColorNotifier extends StateNotifier<Color> {
  ColorNotifier() : super(Colors.greenAccent.shade400);

  //Changes color to green, yellow or red based on recommendation level, tolerance scale, and BAC level
  //Turns yellow at 66% ring percentage and red at >=100%
  void changeColor(
      double bac, int recLevel, double legalLimit, double tolerance) {
    if (recLevel == 1) {
      if ((bac / (legalLimit - 0.02)) * 100 < 66) {
        state = Colors.greenAccent.shade400;
      } else if ((bac / (legalLimit - 0.02)) * 100 < 100) {
        state = Colors.yellowAccent.shade400;
      } else {
        state = Colors.red.shade900;
      }
    } else if (recLevel == 2) {
      if ((bac / (0.11 * tolerance)) * 100 < 66) {
        state = Colors.greenAccent.shade400;
      } else if ((bac / (0.11 * tolerance)) * 100 < 100) {
        state = Colors.yellowAccent.shade400;
      } else {
        state = Colors.red.shade600;
      }
    } else if (recLevel == 3) {
      if ((bac / (0.14 * tolerance)) * 100 < 66) {
        state = Colors.greenAccent.shade400;
        //bac/tolernace < 0.14
      } else if ((bac / (0.14 * tolerance)) * 100 < 100) {
        state = Colors.yellowAccent.shade400;
      } else {
        state = Colors.red.shade600;
      }
    }
  }
}

class DrinkNotifier extends StateNotifier<List<Drink>> {
  DrinkNotifier() : super([]);

  Drink? mostRecent;

  //Saves drink and allows it to be listed under history
  void logDrink(String type, double abv, double oz, DateTime time) {
    if (abv != 0.0 && oz != 0.0) {
      final newDrink =
          Drink(type: type, percentage: abv, size: oz, timestamps: time);
      state = List.of(state)..add(newDrink);
      mostRecent = newDrink;
    }
  }

  //Clears drink history
  void clearDrinks() {
    state = [];
  }

  //Removes most recent drink
  void undoRecent() {
    if (mostRecent != null) {
      state = List.of(state)..remove(mostRecent!);
    }
    mostRecent = null;
  }
}

class FormatNotifier extends StateNotifier<String> {
  FormatNotifier() : super('');

  //Converts hours to Hours:Minutes format
  String getHrsMins(double timeInHours) {
    int hours = timeInHours.toInt();
    int minutes = ((timeInHours - hours) * 60).round();

    if (hours <= 0 && minutes <= 0) {
      hours = 0;
      minutes = 0;
    }

    String paddedHours = hours.toString().padLeft(2, '0');
    String paddedMinutes = minutes.toString().padLeft(2, '0');

    return '$paddedHours:$paddedMinutes';
  }

  //Formats the time each drink was consumed at as Hours:Minutes:AM/PM
  String getTimestamp(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}

final countController =
    StateNotifierProvider<CountNotifier, double>((ref) => CountNotifier());

final bacController =
    StateNotifierProvider<BacNotifier, double>((ref) => BacNotifier());

final weightController =
    StateNotifierProvider<WeightNotifier, double>((ref) => WeightNotifier());

final ageController =
    StateNotifierProvider<AgeNotifier, double>((ref) => AgeNotifier());

final limitController =
    StateNotifierProvider<LimitNotifier, double>((ref) => LimitNotifier());

final genderController =
    StateNotifierProvider<GenderNotifier, double>((ref) => GenderNotifier());

final abvController =
    StateNotifierProvider<AbvNotifier, double>((ref) => AbvNotifier());

final ozController =
    StateNotifierProvider<OzNotifier, double>((ref) => OzNotifier());

final recController =
    StateNotifierProvider<RecNotifier, int>((ref) => RecNotifier());

final tolController =
    StateNotifierProvider<TolNotifier, double>((ref) => TolNotifier());

final unitController =
    StateNotifierProvider<UnitNotifier, int>((ref) => UnitNotifier());

final colorController =
    StateNotifierProvider<ColorNotifier, Color>((ref) => ColorNotifier());

final drinkController =
    StateNotifierProvider<DrinkNotifier, List<Drink>>((ref) => DrinkNotifier());

final formatController =
    StateNotifierProvider<FormatNotifier, String>((ref) => FormatNotifier());
