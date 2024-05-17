final class LoginPageDto {
  final int idAccount;

  LoginPageDto({
    required this.idAccount,
  });

  LoginPageDto.empty() : idAccount = -1;
}
