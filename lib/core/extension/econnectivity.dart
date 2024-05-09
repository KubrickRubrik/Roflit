import 'package:connectivity_plus/connectivity_plus.dart';

extension ConnectivityResultExtension on ConnectivityResult {
  bool get isConnected => <ConnectivityResult>[].activeConnectionsList.contains(this);
}

extension ConnectivityConnectExtension on List<ConnectivityResult> {
  bool get isConnected => any((element) => activeConnectionsList.contains(element));

  ConnectivityResult get connectionType {
    return firstWhere((element) => activeConnectionsList.contains(element),
        orElse: () => ConnectivityResult.none);
  }

  List<ConnectivityResult> get activeConnectionsList => [
        ConnectivityResult.wifi,
        ConnectivityResult.mobile,
        ConnectivityResult.ethernet,
      ];
}
