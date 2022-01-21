import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/models/app_state_manager.dart';
import 'package:neyapsak_webapp_flutter/models/models.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import 'package:neyapsak_webapp_flutter/screens/screens.dart';
import 'package:provider/provider.dart';

class MyDropDownMenu extends StatefulWidget {
  const MyDropDownMenu({Key? key}) : super(key: key);

  @override
  _MyDropDownMenuState createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final String myUserType = appStateManager.userType;
    return PopupMenuButton<int>(
      color: Colors.white,
      icon: const Icon(
        Icons.account_circle,
        size: 35,
        color: Colors.black,
      ),
      offset: Offset.fromDirection(1, 57.0),
      onSelected: (item) => onSelected(context, item),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
            value: 0,
            child: (myUserType == "organiser")
                ? Text('Etkinliklerini Yönet')
                : Text('Kullanıcı Profilini Görüntüle')),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: const [
              Icon(Icons.logout),
              SizedBox(width: 8),
              Text('Sign Out'),
            ],
          ),
        ),
      ],
    );
  }

  void onSelected(BuildContext context, int item) {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    switch (item) {
      case 0:
        (appStateManager.userType == "organiser")
            ? Navigator.pushNamed(context, managerPath)
            : Navigator.pushNamed(context, profilePath,
                arguments: appStateManager.userMail);
        break;
      case 1:
        setState(() {
          appStateManager.logout();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(loginPath, (route) => false);
          //Navigator.of(context).pushNamedAndRemoveUntil(newRouteName, (route) => false)
        });
    }
  }
}
