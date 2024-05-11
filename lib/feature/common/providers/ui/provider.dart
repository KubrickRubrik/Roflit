import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class UiBloc extends _$UiBloc {
  @override
  UiState build() {
    ref.onCancel(() {
      _leaveAccountMenu.cancel();
      _leaveStorageMenu.cancel();
    });
    return const UiState();
  }

  var _leaveAccountMenu = Timer(Duration.zero, () {});
  var _leaveStorageMenu = Timer(Duration.zero, () {});

  void toogleAccountMenu() {
    state = state.copyWith(isDisplayedAccountMenu: !state.isDisplayedAccountMenu);
  }

  void toggleStorageMenu() {
    state = state.copyWith(isDisplayedStorageMenu: !state.isDisplayedStorageMenu);
  }

  void hoverOrLeaveAccountMenu({required bool isHover}) {
    if (isHover) {
      _leaveAccountMenu.cancel();
    } else {
      _leaveAccountMenu.cancel();
      _leaveAccountMenu = Timer.periodic(const Duration(seconds: 2), (_) {
        state = state.copyWith(isDisplayedAccountMenu: false);
        _leaveAccountMenu.cancel();
      });
    }
  }

  void hoverOrLeaveStorageMenu({required bool isHover}) {
    if (isHover) {
      _leaveStorageMenu.cancel();
    } else {
      _leaveStorageMenu.cancel();
      _leaveStorageMenu = Timer.periodic(const Duration(seconds: 2), (_) {
        state = state.copyWith(isDisplayedStorageMenu: false);
        _leaveStorageMenu.cancel();
      });
    }
  }
}
