// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../components/components.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

late String userCity = "";

class SelectUserTypeScreen extends StatefulWidget {
  final String username;
  final String password;

  SelectUserTypeScreen(
      {Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  State<SelectUserTypeScreen> createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<SelectUserTypeScreen> {
  registerData(
      String email, String pwd, String usertype, String userCity) async {
    if (userCity == "" || userCity == " ") {
      userCity = "None";
    }
    print(userCity + " " + email + " " + pwd + " " + usertype);
    var response = await http
        .post(Uri.parse("http://127.0.0.1:8000/user/register/"), headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {
      "email": email,
      "password": pwd,
      "type": usertype,
      "location": userCity
    });
  }

  TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    return Scaffold(
        appBar: MyAppBar(),
        backgroundColor: Colors.grey.shade400,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: ' Yaşadığınız şehir (Opsiyonel)',
                  ),
                ),
                width: 300,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                height: 500,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Material(
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              registerData(widget.username, widget.password,
                                  "regular", cityController.text);
                              appStateManager.selectUserType("regular");
                              appStateManager
                                  .selectUserCity(cityController.text);
                              appStateManager.login(widget.username, "regular",
                                  cityController.text);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  home, (route) => false);
                            },
                            child: Card1(),
                          )),
                    ),
                    Expanded(
                      child: Material(
                          elevation: 1,
                          child: InkWell(
                            onTap: () {
                              registerData(widget.username, widget.password,
                                  "organiser", cityController.text);
                              appStateManager
                                  .selectUserCity(cityController.text);
                              appStateManager.selectUserType("organiser");
                              appStateManager.login(widget.username,
                                  "organiser", cityController.text);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  home, (route) => false);
                            },
                            child: Card2(),
                          )),
                    ),
                    Expanded(
                      child: Material(
                          elevation: 3,
                          child: InkWell(
                            onTap: () {
                              registerData(widget.username, widget.password,
                                  "editor", cityController.text);
                              appStateManager
                                  .selectUserCity(cityController.text);
                              appStateManager.selectUserType("editor");
                              appStateManager.login(widget.username, "editor",
                                  cityController.text);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  home, (route) => false);
                            },
                            child: Card3(),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
