// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/components/components.dart';
import 'models.dart';
import 'package:provider/provider.dart';
import 'searchbar.dart';

class _searchbut extends StatefulWidget {
  _searchbut({Key? key}) : super(key: key);

  @override
  State<_searchbut> createState() => _searchbutState();
}

class _searchbutState extends State<_searchbut> {
  late AppStateManager appStateManager;
  void dosth() {}

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Container(
      child: Row(children: [
        Container(
          height: 100,
          width: 500,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Search Here',
            ),
          ),
        ),
        TextButton(
          child: Icon(
            Icons.search,
            color: Colors.pink,
            size: 35.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          onPressed: () => appStateManager.goToLogin(),
        ),
      ]),
    );
  }
}

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
                onPressed: () => appStateManager.goToLogin(),
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
    return AppBar(
      title: Text(
        "NeYapsak",
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: <Widget>[
        Container(
          height: 100,
          width: 100,
          child: Icon(
            Icons.search,
            color: Colors.pink,
            size: 35.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        ),
        // Giriş/Çıkış yap butonu

        _LogInOutButton(),
        _searchbut(),
        const SizedBox(width: 20, height: 7),
      ],
    );
  }
}
