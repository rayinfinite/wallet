// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wallet/components/storage.dart';
import 'home.dart';

void main() {
  runApp(
    const App(),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSeed color = ColorSeed.baseColor;

  @override
  void initState() {
    super.initState();
    loadData(); // 在 initState 中加载数据
  }

  Future<void> loadData() async {
    final themeModeValue = await getData<bool>('ThemeMode');
    final colorValue = await getData<int>('color');

    setState(() {
      if (themeModeValue != null) {
        themeMode = themeModeValue ? ThemeMode.light : ThemeMode.dark;
      }
      if (colorValue != null) {
        color = ColorSeed.values[colorValue];
      }
    });
  }

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setData<bool>("ThemeMode", useLightMode);
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleColorSelect(int value) {
    setData<int>("color", value);
    setState(() {
      color = ColorSeed.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet',
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: color.color,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: color.color,
        brightness: Brightness.dark,
      ),
      home: Home(
        useLightMode: useLightMode,
        color: color,
        handleBrightnessChange: handleBrightnessChange,
        handleColorSelect: handleColorSelect,
        loadData: loadData,
      ),
    );
  }
}
