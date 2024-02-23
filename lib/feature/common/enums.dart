/// Session state of the application/user.
enum AppSessionState { isNotAuth, isAuth }

/// Available interface themes for selection in the application.
enum AvailableAppTheme { light, dark }

/// Available languages for selection in the app.
enum AvailableAppLocale { ru, en }

/// Activity activity status.
enum ActionStatus { isAction, isDone }

/// Content loading status.
enum ContentStatus {
  isLoadContent,
  isNoContent,
  isErrorContent,
  isEmptyContent,
  isDisplayContent,
}

/// Section loading status.
enum SectionStatus {
  isLoadContent,
  isNoContent,
  isDisplayContent,
}

/// News viewing status.
enum DisplayStatus {
  isNotDisplayed,
  isDisplayed,
}

/// Type of toast.
enum TypeMassage { good, massage, error, warning }

/// Statuses camera
enum StatusCamera { isDone, isError, isLoading, isNotUsed }

/// Statuses of camera permission
enum CameraPermissionStatus {
  needUpdateOSettings,
  needRequestPersmission,
  hasPersmission,
  noAcces,
}

/// Statuses of Geolocator permission
enum GeoPermissionStatus {
  needUpdateOSettings,
  needRequestPersmission,
  hasPersmission,
  noAcces,
}
