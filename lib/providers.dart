import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  double addDrink(double abv, double oz) {
    state = state + (abv / 100 * oz) / 0.6;
    return state;
  }

  double undoDrink(double abv, double oz) {
    if (state - (abv / 100 * oz) / 0.6 >= 0) {
      state = state - (abv / 100 * oz) / 0.6;
    } else {
      state = 0;
    }

    return state;
  }

  double reset() {
    state = 0;
    return state;
  }
}

class BacNotifier extends StateNotifier<double> {
  BacNotifier() : super(0);

  void updateBac(double weight, double genderVal, double count) {
    double newBac = 0.0;
    if (weight == 0 || genderVal == 0) {
      print('Gender or weight not inputed');
    } else {
      newBac = 100 * (count * 14) / (weight * 454 * genderVal);

      if (newBac >= 0) {
        state = newBac;
      } else {
        state = 0;
      }
    }
  }

  void timeDecrement() {
    double newBac = 0.0;

    newBac = state -
        (0.015 * (60 / 3600)); // replace 60 with timer interval in seocnds

    if (newBac >= 0) {
      state = newBac;
    } else {
      state = 0;
    }
  }

  void reset() {
    state = 0;
  }
}

class WeightNotifier extends StateNotifier<double> {
  WeightNotifier() : super(0);

  void setWeight(double weight, int unit) {
    if (unit == 2) {
      state = weight;
    } else if (unit == 1) {
      state = 2.2 * weight;
    }
  }

  void reset() {
    state = 0;
  }
}

class AgeNotifier extends StateNotifier<double> {
  AgeNotifier() : super(0);

  void setAge(double age) {
    state = age;
  }

  void reset() {
    state = 0;
  }
}

class LimitNotifier extends StateNotifier<double> {
  LimitNotifier() : super(0);

  void setLimit(double legalLimit) {
    state = legalLimit;
  }

  void reset() {
    state = 0;
  }
}

class GenderNotifier extends StateNotifier<double> {
  GenderNotifier() : super(0);

  void setGender(double genderVal) {
    state = genderVal;
  }

  void reset() {
    state = 0;
  }
}

class AbvNotifier extends StateNotifier<double> {
  AbvNotifier() : super(0);

  void setAbv(double abv) {
    state = abv;
  }

  void reset() {
    state = 0;
  }
}

class OzNotifier extends StateNotifier<double> {
  OzNotifier() : super(0);

  void setOz(double oz) {
    state = oz;
  }

  void reset() {
    state = 0;
  }
}

class RecNotifier extends StateNotifier<int> {
  RecNotifier() : super(0);

  void setRec(int recLevel) {
    state = recLevel;
  }

  void reset() {
    state = 0;
  }
}

class TolNotifier extends StateNotifier<double> {
  TolNotifier() : super(0);

  void setTol(double tolerance) {
    state = tolerance;
  }

  void reset() {
    state = 0.8;
  }
}

class UnitNotifier extends StateNotifier<int> {
  UnitNotifier() : super(0);

  void setUnit(int unit) {
    state = unit; // 1 for metric, 2 for imperial
  }

  void reset() {
    state = 0;
  }
}

class ColorNotifier extends StateNotifier<Color> {
  ColorNotifier() : super(Colors.greenAccent.shade400);

  void changeColor(
      double bac, int recLevel, double legalLimit, double tolerance) {
    if (recLevel == 1) {
      if (bac <= legalLimit - 0.03) {
        state = Colors.greenAccent.shade400;
      } else if (bac < legalLimit) {
        state = Colors.yellowAccent.shade400;
      } else {
        state = Colors.red.shade900;
      }
    } else if (recLevel == 2) {
      if (bac / tolerance <= 0.08) {
        state = Colors.greenAccent.shade400;
      } else if (bac / tolerance < 0.11) {
        state = Colors.yellowAccent.shade400;
      } else {
        state = Colors.red.shade600;
      }
    } else if (recLevel == 3) {
      if (bac / tolerance <= 0.11) {
        state = Colors.greenAccent.shade400;
      } else if (bac / tolerance < 0.14) {
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

  void logDrink(String type, double abv, double oz, DateTime time) {
    if (abv != 0.0 && oz != 0.0) {
      final newDrink =
          Drink(type: type, percentage: abv, size: oz, timestamps: time);
      state = List.of(state)..add(newDrink);
      mostRecent = newDrink;
    }
  }

  void clearDrinks() {
    state = [];
  }

  void undoRecent() {
    if (mostRecent != null) {
      state = List.of(state)..remove(mostRecent!);
    }
    mostRecent = null;
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
