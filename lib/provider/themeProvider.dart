// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  void toggleTheme(){
    if(_currentTheme == ThemeData.light()){
      _currentTheme = ThemeData.dark();
    }
    else {
      _currentTheme = ThemeData.light();
    }
    notifyListeners();
  }
}