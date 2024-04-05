// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityService() {
    // Subscribe to the connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityResult = result;
    } as void Function(List<ConnectivityResult> event)?);

    // Check the initial connectivity status
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    _connectivityResult = result as ConnectivityResult;
  }

  ConnectivityResult get connectivityResult => _connectivityResult;

  Future<bool> isConnected() async {
    await _checkConnectivity();
    return _connectivityResult != ConnectivityResult.none;
  }
}