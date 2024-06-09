final class MenuAccountDto {
  final int? idAccount;
  final bool isCreateAccount;

  MenuAccountDto({
    required this.isCreateAccount,
    this.idAccount,
  });

  MenuAccountDto.empty()
      : isCreateAccount = true,
        idAccount = null;
}
