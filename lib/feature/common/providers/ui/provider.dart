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
      _leaveMainMenu.cancel();
    });
    return const UiState();
  }

  var _leaveAccountMenu = Timer(Duration.zero, () {});
  var _leaveStorageMenu = Timer(Duration.zero, () {});
  var _leaveMainMenu = Timer(Duration.zero, () {});

  void menuActivity({
    required TypeMenu typeMenu,
    required ActionMenu action,
    bool isHover = false,
  }) {
    switch (typeMenu) {
      //! Account menu
      case TypeMenu.account:
        switch (action) {
          case ActionMenu.openClose:
            state = state.copyWith(isDisplayedAccountMenu: !state.isDisplayedAccountMenu);
            if (state.isDisplayedAccountMenu) {
              _leaveAccountMenu.cancel();
              _leaveAccountMenu = Timer.periodic(const Duration(seconds: 3), (_) {
                state = state.copyWith(isDisplayedAccountMenu: false);
                _leaveAccountMenu.cancel();
              });
            }
            break;
          case ActionMenu.hoverLeave:
            if (isHover) {
              _leaveAccountMenu.cancel();
            } else {
              _leaveAccountMenu.cancel();
              _leaveAccountMenu = Timer.periodic(const Duration(seconds: 2), (_) {
                state = state.copyWith(isDisplayedAccountMenu: false);
                _leaveAccountMenu.cancel();
              });
            }
            break;
        }
        break;
      //! Storage menu
      case TypeMenu.storage:
        switch (action) {
          case ActionMenu.openClose:
            state = state.copyWith(isDisplayedStorageMenu: !state.isDisplayedStorageMenu);
            if (state.isDisplayedStorageMenu) {
              _leaveStorageMenu.cancel();
              _leaveStorageMenu = Timer.periodic(const Duration(seconds: 3), (_) {
                state = state.copyWith(isDisplayedStorageMenu: false);
                _leaveStorageMenu.cancel();
              });
            }
            break;
          case ActionMenu.hoverLeave:
            if (isHover) {
              _leaveStorageMenu.cancel();
            } else {
              _leaveStorageMenu.cancel();
              _leaveStorageMenu = Timer.periodic(const Duration(seconds: 2), (_) {
                state = state.copyWith(isDisplayedStorageMenu: false);
                _leaveStorageMenu.cancel();
              });
            }
            break;
        }
        break;
      //! Main menu
      case TypeMenu.main:
        switch (action) {
          case ActionMenu.openClose:
            state = state.copyWith(isDisplayedMainMenu: !state.isDisplayedMainMenu);
            // if (state.isDisplayedMainMenu) {
            //   _leaveMainMenu.cancel();
            //   _leaveMainMenu = Timer.periodic(const Duration(seconds: 3), (_) {
            //     state = state.copyWith(isDisplayedMainMenu: false);
            //     _leaveMainMenu.cancel();
            //   });
            // }
            break;
          case ActionMenu.hoverLeave:
            if (isHover) {
              _leaveMainMenu.cancel();
            } else {
              // _leaveMainMenu.cancel();
              // _leaveMainMenu = Timer.periodic(const Duration(seconds: 2), (_) {
              //   state = state.copyWith(isDisplayedMainMenu: false);
              //   _leaveMainMenu.cancel();
              // });
            }
            break;
        }
        break;
    }
  }
}

enum TypeMenu {
  account,
  storage,
  main;

  bool get isAccount => this == account;
  bool get isStorage => this == storage;
  bool get isMain => this == main;

  const TypeMenu();
}

enum ActionMenu {
  openClose,
  hoverLeave;

  bool get isOpen => this == openClose;
  bool get isHoverLeave => this == hoverLeave;

  const ActionMenu();
}
