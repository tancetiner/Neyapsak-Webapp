// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import 'package:neyapsak_webapp_flutter/screens/login_screen.dart';
import '../models/models.dart';
import '../components/components.dart';
import 'package:provider/provider.dart';

class _LogInOutButton extends StatefulWidget {
  _LogInOutButton({Key? key}) : super(key: key);

  @override
  State<_LogInOutButton> createState() => _LogInOutButtonState();
}

class _LogInOutButtonState extends State<_LogInOutButton> {
  late AppStateManager appStateManager;

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Container(
      child: appStateManager.isLoggedIn
          ? Row(children: [
              Text(
                appStateManager.userMail.split("@")[0],
                style: Theme.of(context).textTheme.headline6,
              ),
              MyDropDownMenu(),
            ])
          : Row(children: [
              TextButton(
                child: Text(
                  "Giriş Yap",
                  style: Theme.of(context).textTheme.headline6,
                ),
                onPressed: () => Navigator.pushNamed(context, loginPath),
              ),
            ]),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    return AppBar(
      title: TextButton(
        onPressed: () {
          if (appStateManager.isLoggedIn) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(home, (route) => false);
          }
        },
        child: Text(
          "NEYAPSAK",
          style: NeyapsakTheme.lightTextTheme.headline6,
        ),
      ),
      actions: <Widget>[
        // Giriş/Çıkış yap butonu
        _LogInOutButton(),
        const SizedBox(width: 20, height: 7),
      ],
      backgroundColor: NeyapsakTheme.light().primaryColor,
    );
  }
}
