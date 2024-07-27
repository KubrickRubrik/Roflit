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
      _leaveAccountMenu?.cancel();
      _leaveStorageMenu?.cancel();
      _leaveMainMenu?.cancel();
    });
    return const UiState();
  }

  Timer? _leaveAccountMenu;
  Timer? _leaveUploadConfigMenu;
  Timer? _leaveDownloadConfigMenu;
  Timer? _leaveStorageMenu;
  Timer? _leaveMainMenu;

  void menuActivity({
    required TypeMenu typeMenu,
    required ActionMenu action,
    bool isHover = false,
  }) {
    switch (typeMenu) {
      //! Account menu
      case TypeMenu.account:
        switch (action) {
          case ActionMenu.open:
            state = state.copyWith(isDisplayedAccountMenu: true);
            _leaveAccountMenu?.cancel();
            _leaveAccountMenu = Timer.periodic(const Duration(seconds: 3), (_) {
              state = state.copyWith(isDisplayedAccountMenu: false);
              _leaveAccountMenu?.cancel();
            });

            break;
          case ActionMenu.hoverLeave:
            if (isHover) {
              _leaveAccountMenu?.cancel();
            } else {
              _leaveAccountMenu?.cancel();
              _leaveAccountMenu = Timer.periodic(const Duration(seconds: 2), (_) {
                state = state.copyWith(isDisplayedAccountMenu: false);
                _leaveAccountMenu?.cancel();
              });
            }
            break;
          case ActionMenu.close:
            state = state.copyWith(isDisplayedAccountMenu: false);
            _leaveAccountMenu?.cancel();
            break;
        }
        break;
      //! Upload config menu
      case TypeMenu.uploadConfig:
        switch (action) {
          case ActionMenu.open:
            state = state.copyWith(isDisplayedUploadConfigMenu: true);
            _leaveUploadConfigMenu?.cancel();
            _leaveUploadConfigMenu = Timer.periodic(const Duration(seconds: 3), (_) {
              state = state.copyWith(isDisplayedUploadConfigMenu: false);
              _leaveUploadConfigMenu?.cancel();
            });

            break;
          case ActionMenu.hoverLeave:
            if (isHover) {
              _leaveUploadConfigMenu?.cancel();
            } else {
              _leaveUploadConfigMenu?.cancel();
              _leaveUploadConfigMenu = Timer.periodic(const Duration(seconds: 2), (_) {
                state = state.copyWith(isDisplayedUploadConfigMenu: false);
                _leaveUploadConfigMenu?.cancel();
              });
            }
            break;
          case ActionMenu.close:
            state = state.copyWith(isDisplayedUploadConfigMenu: false);
            _leaveUploadConfigMenu?.cancel();
            break;
        }
        break;
      //! Download config menu
      case TypeMenu.downloadConfig:
        switch (action) {
          case ActionMenu.open:
            state = state.copyWith(isDisplayedDownloadConfigMenu: true);
            _leaveDownloadConfigMenu?.cancel();
            _leaveDownloadConfigMenu = Timer.periodic(const Duration(seconds: 3), (_) {
              state = state.copyWith(isDisplayedDownloadConfigMenu: false);
              _leaveDownloadConfigMenu?.cancel();
            });

            break;
          case ActionMenu.hoverLeave:
            if (isHover) {
              _leaveDownloadConfigMenu?.cancel();
            } else {
              _leaveDownloadConfigMenu?.cancel();
              _leaveDownloadConfigMenu = Timer.periodic(const Duration(seconds: 2), (_) {
                state = state.copyWith(isDisplayedDownloadConfigMenu: false);
                _leaveDownloadConfigMenu?.cancel();
              });
            }
            break;
          case ActionMenu.close:
            state = state.copyWith(isDisplayedDownloadConfigMenu: false);
            _leaveDownloadConfigMenu?.cancel();
            break;
        }
        break;
      //! Storage menu
      case TypeMenu.storage:
        switch (action) {
          case ActionMenu.open:
            state = state.copyWith(isDisplayedStorageMenu: true);

            _leaveStorageMenu?.cancel();
            _leaveStorageMenu = Timer.periodic(const Duration(seconds: 3), (_) {
              state = state.copyWith(isDisplayedStorageMenu: false);
              _leaveStorageMenu?.cancel();
            });

            break;
          case ActionMenu.hoverLeave:
            if (isHover) {
              _leaveStorageMenu?.cancel();
            } else {
              _leaveStorageMenu?.cancel();
              _leaveStorageMenu = Timer.periodic(const Duration(seconds: 2), (_) {
                state = state.copyWith(isDisplayedStorageMenu: false);
                _leaveStorageMenu?.cancel();
              });
            }
            break;
          case ActionMenu.close:
            state = state.copyWith(isDisplayedStorageMenu: false);
            _leaveStorageMenu?.cancel();
            break;
        }
        break;
      //! Main menu
      case TypeMenu.main:
        switch (action) {
          case ActionMenu.open:
            state = state.copyWith(isDisplayedMainMenu: true);

            // state = state.copyWith(
            //   redirectToMainMenuPage: null,
            // );
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
              _leaveMainMenu?.cancel();
            } else {
              // _leaveMainMenu.cancel();
              // _leaveMainMenu = Timer.periodic(const Duration(seconds: 2), (_) {
              //   state = state.copyWith(isDisplayedMainMenu: false);
              //   _leaveMainMenu.cancel();
              // });
            }
            break;
          case ActionMenu.close:
            state = state.copyWith(
              isDisplayedMainMenu: false,
            );
            _leaveMainMenu?.cancel();
            break;
        }
        break;
    }
  }

  void menuBucket({
    ActionMenu? action,
  }) {
    var currentAction = action;
    currentAction ??= state.isDisplayBucketMenu ? ActionMenu.close : ActionMenu.open;
    switch (currentAction) {
      case ActionMenu.open:
        state = state.copyWith(isDisplayBucketMenu: true);
        break;
      case ActionMenu.hoverLeave:
        state = state.copyWith(isDisplayBucketMenu: false);
        break;
      case ActionMenu.close:
        state = state.copyWith(isDisplayBucketMenu: false);
        break;
    }
  }

  void menuFileManager({
    ActionMenu? action,
  }) {
    var currentAction = action;
    currentAction ??= state.isDisplayedFileManagerMenu ? ActionMenu.close : ActionMenu.open;
    switch (currentAction) {
      case ActionMenu.open:
        state = state.copyWith(isDisplayedFileManagerMenu: true);
        break;
      case ActionMenu.hoverLeave:
        // state = state.copyWith(isDisplayBucketMenu: false);
        break;
      case ActionMenu.close:
        state = state.copyWith(isDisplayedFileManagerMenu: false);
        break;
    }
  }
}

enum TypeMenu {
  account,
  uploadConfig,
  downloadConfig,
  storage,
  main;

  bool get isAccount => this == account;
  bool get isUploadConfig => this == uploadConfig;
  bool get isStorage => this == storage;
  bool get isMain => this == main;

  const TypeMenu();
}

enum ActionMenu {
  open,
  hoverLeave,
  close;

  bool get isOpen => this == open;
  bool get isHoverLeave => this == hoverLeave;
  bool get isClose => this == close;

  const ActionMenu();
}
