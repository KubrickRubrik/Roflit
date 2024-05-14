final class AccountPageDto {
  final int? idAccount;
  final bool isCreateAccount;

  AccountPageDto({
    required this.isCreateAccount,
    this.idAccount,
  });

  AccountPageDto.empty()
      : isCreateAccount = true,
        idAccount = null;
}
