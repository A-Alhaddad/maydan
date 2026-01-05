import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  final StreamController<bool> _connectionStreamController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionStreamController.stream;

  StreamSubscription<ConnectivityResult>? _subscription;

  void startMonitoring() {
    // إذا كان الاشتراك مفعلاً مسبقاً لا تعاود الاشتراك
    if (_subscription != null) return;
    _subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        final hasInternet = await InternetConnectionChecker().hasConnection;
        if (!_connectionStreamController.isClosed) {
          _connectionStreamController.add(hasInternet);
        }
      },
    );
  }
  Future<bool> checkInternetOnce() async {
    return await InternetConnectionChecker().hasConnection;
  }
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    if (!_connectionStreamController.isClosed) {
      _connectionStreamController.close();
    }
  }
}
