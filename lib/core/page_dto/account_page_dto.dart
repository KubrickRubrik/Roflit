final class MenuAccountDto {
  final int? idAccount;
  final bool isCreateProccessAccount;

  MenuAccountDto({
    required this.isCreateProccessAccount,
    this.idAccount,
  });

  MenuAccountDto.empty()
      : isCreateProccessAccount = true,
        idAccount = null;
}
