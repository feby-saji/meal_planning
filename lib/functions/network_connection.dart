import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> connectedToInternet() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi)) {
    print('/// connectedToInternet connected to intenet');
    return true;
  } else {
    print('/// not connected intenet');
    return false;
  }
}
