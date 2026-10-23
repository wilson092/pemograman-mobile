import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _warnaTema = 'Indigo';
  int _targetTabungan = 20000;

  bool get isDarkMode => _isDarkMode;
  String get warnaTema => _warnaTema;
  int get targetTabungan => _targetTabungan;

  PengaturanProvider() {
    muatPengaturan();
  }

  Future<void> muatPengaturan() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _warnaTema = prefs.getString('warnaTema') ?? 'Indigo';
    _targetTabungan = prefs.getInt('targetTabungan') ?? 20000;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> setWarnaTema(String value) async {
    _warnaTema = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('warnaTema', value);
  }

  Future<void> setTargetTabungan(int value) async {
    _targetTabungan = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('targetTabungan', value);
  }

  Color getSeedColor() {
    switch (_warnaTema) {
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Teal':
        return Colors.teal;
      case 'Purple':
        return Colors.purple;
      case 'Orange':
        return Colors.orange;
      case 'Indigo':
      default:
        return Colors.indigo;
    }
  }
}
