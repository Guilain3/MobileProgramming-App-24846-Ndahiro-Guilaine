import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConnectivityService {
  ConnectivityService._privateConstructor() {
    _initConnectivity();
  }
  void checkCurrentConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _showConnectivityToast(result);
  }
  static final ConnectivityService _instance =
  ConnectivityService._privateConstructor();

  static ConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  late Stream<ConnectivityResult> _connectivityStream;

  void _initConnectivity() {
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivityStream.listen((ConnectivityResult result) {
      _showConnectivityToast(result);
    });
  }

  void _showConnectivityToast(ConnectivityResult result) {
    String message;
    Color bgColor;

    switch (result) {
      case ConnectivityResult.mobile:
        message = 'Connected to Mobile Network';
        bgColor = Colors.green;
        break;
      case ConnectivityResult.wifi:
        message = 'Connected to WiFi';
        bgColor = Colors.green;
        break;
      case ConnectivityResult.none:
        message = 'No Internet Connection';
        bgColor = Colors.red;
        break;
      default:
        message = 'Connectivity Status Unknown';
        bgColor = Colors.yellow;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
