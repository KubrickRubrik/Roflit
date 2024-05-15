import 'package:roflit/core/enums.dart';

final class LocalizationPageDto {
  final int idAccount;
  final AvailableAppLocale localizationType;

  LocalizationPageDto({
    required this.idAccount,
    this.localizationType = AvailableAppLocale.ru,
  });

  LocalizationPageDto.empty()
      : idAccount = -1,
        localizationType = AvailableAppLocale.ru;
}
