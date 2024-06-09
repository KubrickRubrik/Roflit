final class MenuLoginDto {
  final int idAccount;

  MenuLoginDto({
    required this.idAccount,
  });

  MenuLoginDto.empty() : idAccount = -1;
}
