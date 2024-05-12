import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';

class MainMenuAccountPage extends StatelessWidget {
  final bool isCreateAccount;

  const MainMenuAccountPage({
    required this.isCreateAccount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          Container(
            height: 56,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: Color(AppColors.borderLineOnLight0),
                ),
              ),
            ),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                context.goNamed(RouteEndPoints.accounts.account.password.name);
              },
              child: Text(
                'Создание аккаунта'.translate,
                overflow: TextOverflow.fade,
                style: appTheme.textTheme.title2.bold.onDark1,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
