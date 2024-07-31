import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for MethodChannel
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'services/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectivityService.instance;

  // Initialize MethodChannel
  const MethodChannel platform = MethodChannel('battery_channel');

  // Set up a method call handler
  platform.setMethodCallHandler((call) async {
    if (call.method == 'battery_full') {
      // Handle the method call from the Android side when the battery is full
      print("Battery is full!");
      // You can show a toast or any other action here
    } else {
      throw MissingPluginException('Not implemented: ${call.method}');
    }
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return MaterialApp(
      title: 'MY APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.black),
          prefixIconColor: Colors.black,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white),
          prefixIconColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(initialIndex: 0),
    );
  }
}
