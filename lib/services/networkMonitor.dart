import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  final StreamController<bool> _connectionStreamController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionStreamController.stream;

  late StreamSubscription _subscription;

  void startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      _connectionStreamController.add(hasInternet);
    });
  }
  Future<bool> checkInternetOnce() async {
    return await InternetConnectionChecker().hasConnection;
  }
  void dispose() {
    _subscription.cancel();
    _connectionStreamController.close();
  }
}
