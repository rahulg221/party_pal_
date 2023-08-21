import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _themeKey = 'theme';
  static const _genderKey = 'gender';
  static const _weightKey = 'weight';
  static const _limitKey = 'limit';
  static const _ageKey = 'age';
  static const _recKey = 'rec';
  static const _tolKey = 'tolerance';
  static const _unitKey = 'unit';
  static const _dFlagKey = 'dflag';

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> setTheme(int themeFlag) async {
    await _preferences?.setInt(_themeKey, themeFlag);
  }

  static int? getTheme() {
    return _preferences?.getInt(_themeKey);
  }

  static Future<void> setGender(double gender) async {
    await _preferences?.setDouble(_genderKey, gender);
  }

  static double? getGender() {
    return _preferences?.getDouble(_genderKey);
  }

  static Future<void> setWeight(double weight) async {
    await _preferences?.setDouble(_weightKey, weight);
  }

  static double? getWeight() {
    return _preferences?.getDouble(_weightKey);
  }

  static Future<void> setLimit(double legalLimit) async {
    await _preferences?.setDouble(_limitKey, legalLimit);
  }

  static double? getLimit() {
    return _preferences?.getDouble(_limitKey);
  }

  static Future<void> setAge(double age) async {
    await _preferences?.setDouble(_ageKey, age);
  }

  static double? getAge() {
    return _preferences?.getDouble(_ageKey);
  }

  static Future<void> setRec(int recLevel) async {
    await _preferences?.setInt(_recKey, recLevel);
  }

  static int? getRec() {
    return _preferences?.getInt(_recKey);
  }

  static Future<void> setTolerance(double tolerance) async {
    await _preferences?.setDouble(_tolKey, tolerance);
  }

  static double? getTolerance() {
    return _preferences?.getDouble(_tolKey);
  }

  static Future<void> setUnit(int unit) async {
    await _preferences?.setInt(_unitKey, unit);
  }

  static int? getUnit() {
    return _preferences?.getInt(_unitKey);
  }

  static Future<void> setDflag(int dFlag) async {
    await _preferences?.setInt(_dFlagKey, dFlag);
  }

  static int? getDflag() {
    return _preferences?.getInt(_dFlagKey);
  }
}
