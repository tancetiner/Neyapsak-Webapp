// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:neyapsak_webapp_flutter/models/models.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import 'package:neyapsak_webapp_flutter/screens/screens.dart';
import '../components/components.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neyapsak_webapp_flutter/constants.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: loginPath, key: ValueKey(loginPath), child: LoginScreen());
  }

  static const routeName = '/auth';
  String user = "";
  String userType = "";
  String userCity = "";

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 500);

  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      var response = await http.post(
          Uri.parse("http://127.0.0.1:8000/user/login/"),
          body: {"email": data.name, "password": data.password});

      if (response.statusCode == 404) {
        return 'User not exists';
      }
      if (response.statusCode == 401) {
        return 'Password does not match';
      }
      var decoded = utf8.decode(response.bodyBytes);
      var items = json.decode(decoded);

      Map<String, dynamic> info = items;
      user = data.name;
      userType = info["type"];
      userCity = info["location"];

      return null;
    });
  }

  Future<String?>? _recoverPassword(String name) {
    return null;
  }

  ThemeData theme = NeyapsakTheme.light();

  @override
  Widget build(BuildContext context) {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    return Scaffold(
        appBar: MyAppBar(),
        body: SafeArea(
            child: Center(
          child: Container(
            color: theme.backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(32),
                        width: 500,
                        child: Column(
                          children: [
                            Text(
                              "Bu hafta sonu, gelecek ay, yaz tatilinde planın yok mu?",
                              style: NeyapsakTheme.lightTextTheme.headline4,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Arkadaşlarınla konuştun ve ne yapacağını bilmiyor musun?",
                              style: NeyapsakTheme.lightTextTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                      color: NeyapsakTheme.light().cardTheme.color,
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(32),
                        width: 500,
                        child: Column(
                          children: [
                            Text(
                              "NEYAPSAK tam sana göre!",
                              style: NeyapsakTheme.lightTextTheme.headline4,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Festivaller, konserler, tiyatro oyunları ve çok daha fazlası burada!\n\n"
                              "Hemen giriş yap ve birbirinden eğlenceli etkinlikleri keşfe başla!",
                              style: NeyapsakTheme.lightTextTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                      color: NeyapsakTheme.light().cardTheme.color,
                    ),
                  ],
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: FlutterLogin(
                    title: Constants.appName,
                    logo: 'cmon_tigre.jpg',
                    logoTag: Constants.logoTag,
                    titleTag: Constants.titleTag,
                    navigateBackAfterRecovery: true,
                    loginAfterSignUp: false,
                    hideForgotPasswordButton: true,
                    // hideSignUpButton: true,
                    // disableCustomPageTransformer: true,
                    messages: LoginMessages(
                      userHint: 'Kullanıcı Adı',
                      passwordHint: 'Şifre',
                      confirmPasswordHint: 'Confirm',
                      loginButton: 'GİRİŞ YAP',
                      signupButton: 'KAYIT OL',
                      goBackButton: 'Geri',
                      confirmPasswordError: 'Not match!',
                      flushbarTitleError: 'Oh no!',
                      flushbarTitleSuccess: 'Succes!',
                      //providersTitle: 'login with'),
                    ),
                    theme: LoginTheme(
                      primaryColor: theme.backgroundColor,
                      accentColor: Colors.orange
                          .shade200, // signupa basınca yeni satır gelirken animasyonun arkasındaki renk
                      errorColor: Colors.red,
                      //pageColorLight: Colors.indigo.shade300, // sayfada gradyan var, bu ve sonraki arasında geçiş
                      //pageColorDark: Colors.red,
                      logoWidth: 0.80,
                      titleStyle: NeyapsakTheme.light().textTheme.headline1,
                      // beforeHeroFontSize: 50,
                      // afterHeroFontSize: 20,
                      bodyStyle: NeyapsakTheme.light().textTheme.bodyText1,
                      //TextStyle(fontStyle: FontStyle.italic,decoration: TextDecoration.underline,),
                      textFieldStyle: NeyapsakTheme.light().textTheme.bodyText2,
                      // style of the login button text
                      buttonStyle: NeyapsakTheme.light().textTheme.button,
                      // login kartının stili
                      cardTheme: NeyapsakTheme.light().cardTheme,
                      inputTheme: NeyapsakTheme.light().inputDecorationTheme,
                      buttonTheme: LoginButtonTheme(
                        splashColor: Color.fromRGBO(255, 143, 0, 1),
                        backgroundColor: Color.fromRGBO(255, 87, 34, 1),
                        highlightColor: Color.fromRGBO(255, 143, 0, 1),
                        elevation: 9.0,
                        highlightElevation: 6.0,
                        //shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        //shape: CircleBorder(side: BorderSide(color: Colors.green)),
                        //shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
                      ),
                    ),
                    userValidator: (value) {
                      if (!value!.contains('@') || !value.endsWith('.com')) {
                        return "Email must contain '@' and end with '.com'";
                      }
                      return null;
                    },
                    passwordValidator: (value) {
                      if (value!.isEmpty) {
                        return 'Şifre girmediniz';
                      }

                      // more secure regex password must be
                      // more than 8 chars
                      // at least one number
                      String pattern = r'.*';
                      RegExp regExp = new RegExp(pattern);

                      if (regExp.hasMatch(value)) {
                        return null;
                      } else {
                        return "Şifre en az sekiz karakter ve bir rakam içermelidir.";
                      }
                    },
                    onLogin: (loginData) {
                      print('Login info');
                      print('Name: ${loginData.name}');
                      print('Password: ${loginData.password}');

                      return _loginUser(loginData);
                    },
                    onSignup: (signupData) {
                      print('Signup info');
                      print('Name: ${signupData.name}');
                      print('Password: ${signupData.password}');

                      // appStateManager.goToUserTypeSelection(
                      //     signupData.name!, signupData.password!);
                      //return _loginUser(signupData);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SelectUserTypeScreen(
                              username: signupData.name!,
                              password: signupData.password!);
                        }),
                      );
                    },
                    onSubmitAnimationCompleted: () {
                      appStateManager.login(user, userType,
                          userCity); //.login(loginData.name, loginData.password);
                      //Navigator.of(context).pushReplacement(FadePageRoute(builder: (context) => HomeScreen(),));

                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(home, (route) => false);
                    },
                    onRecoverPassword: (name) {
                      print('Recover password info');
                      print('Name: $name');
                      return _recoverPassword(name);
                      // Show new password dialog
                    },
                    showDebugButtons: false,
                  ),
                ),
                SizedBox(
                  child: Container(
                    color: theme.backgroundColor,
                  ),
                  width: 300,
                ),
              ],
            ),
          ),
        )));
  }
}
