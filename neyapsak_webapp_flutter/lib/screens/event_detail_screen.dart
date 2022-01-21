// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import '../models/models.dart';
import '../components/components.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  var event;
  EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  var thisEvent;
  late String userType;
  late bool isLiked;
  late bool isBought;
  @override
  Widget build(BuildContext context) {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final String userName = appStateManager.userMail;

    print(widget.event.name);
    if (widget.event == null) {
      thisEvent = appStateManager.viewedEvent;
      print("ITS FROM APPSTATEMANAGER");
    } else {
      thisEvent = widget.event;
      appStateManager.setViewedEvent(widget.event);
      print("ITS FROM WIDGET");
    }

    isLiked = thisEvent.isSaved;
    isBought = thisEvent.isBought;
    userType = appStateManager.userType;

    return Scaffold(
        appBar: MyAppBar(),
        body: SingleChildScrollView(
            child: getBody(thisEvent, isLiked, isBought, userName)));
  }

  Widget getBody(Event event, isLiked, isBought, userName) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 300,
              ),
              Container(
                child: Stack(children: [
                  Positioned(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(106, 96, 232, 0.9),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          event.name,
                          style: NeyapsakTheme.lightTextTheme.headline4,
                        ),
                      ),
                      top: 10,
                      left: 10),
                ]),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: (event.eventType.toLowerCase() == "konser")
                      ? DecorationImage(
                          alignment: Alignment.centerLeft,
                          image: AssetImage("concertlarge.jpg"),
                          fit: BoxFit.fitWidth,
                        )
                      : (event.eventType == "festival")
                          ? DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage("festivallarge.jpg"),
                              fit: BoxFit.fitHeight,
                            )
                          : DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage("theatrelarge.jpg"),
                              fit: BoxFit.fitHeight,
                            ),
                ),
                width: 800,
                height: 400,
              ),
              SizedBox(
                width: 400,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
              ),
              Container(
                padding: EdgeInsets.only(left: 32, bottom: 16, right: 32),
                width: 800,
                decoration: BoxDecoration(
                    color: NeyapsakTheme.light().primaryColorLight,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Etkinlik Hakkında",
                          style: NeyapsakTheme.lightTextTheme.headline4,
                        ),
                      ),
                    ),
                    Divider(),
                    Text(
                      event.description,
                      style: NeyapsakTheme.lightTextTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Şehir ve lokasyon: " +
                          event.city +
                          ", " +
                          event.location,
                      style: NeyapsakTheme.lightTextTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Başlangıç Tarihi: " +
                          DateFormat("dd-MM-yyyy").format(event.eventStartDate),
                      style: NeyapsakTheme.lightTextTheme.bodyText1,
                    ),
                    Text(
                      "Bitiş Tarihi: " +
                          DateFormat("dd-MM-yyyy").format(event.eventEndDate),
                      style: NeyapsakTheme.lightTextTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Etkinlik türü, " + event.eventType,
                      style: NeyapsakTheme.lightTextTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 200,
                    child: (userType == "organiser"
                        ? Container(
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color.fromRGBO(206, 83, 62, 1),
                            ),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  "Organizatör kullanıcılar bilet alamaz",
                                  style: NeyapsakTheme.lightTextTheme.headline3,
                                ),
                              ),
                            ),
                          )
                        : (event.eventEndDate.isBefore(DateTime.now())
                            ? Container(
                                height: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Color.fromRGBO(206, 83, 62, 1),
                                ),
                                child: Center(
                                  child: ListTile(
                                    onTap: () {},
                                    title: Text(
                                      "Etkinlik tarihi geçti",
                                      style: NeyapsakTheme
                                          .lightTextTheme.headline3,
                                    ),
                                  ),
                                ),
                              )
                            : (isBought
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Color.fromRGBO(206, 83, 62, 1),
                                    ),
                                    height: 75,
                                    child: Center(
                                      child: ListTile(
                                        onTap: () {},
                                        title: Text(
                                          "Etkinliğe bilet alındı",
                                          style: NeyapsakTheme
                                              .lightTextTheme.headline3,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 75,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: NeyapsakTheme.light().primaryColor,
                                    ),
                                    child: Center(
                                      child: ListTile(
                                        onTap: () {
                                          http.post(
                                              Uri.parse(
                                                  "http://127.0.0.1:8000/event/buyTicket/"),
                                              headers: {
                                                'Accept':
                                                    'application/json; charset=UTF-8',
                                                'Content-Type':
                                                    'application/json'
                                              },
                                              body: jsonEncode({
                                                'email': userName,
                                                'eventID': event.id
                                              }));
                                          setState(() {
                                            isBought = true;
                                          });
                                          event.isBought = true;
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                settings: RouteSettings(
                                                    name: eventDetailPath),
                                                builder: (context) {
                                                  final appStateManager =
                                                      Provider.of<
                                                              AppStateManager>(
                                                          context,
                                                          listen: false);
                                                  appStateManager
                                                      .setViewedEvent(event);
                                                  return EventDetailScreen(
                                                      event: event);
                                                }),
                                          );
                                        },
                                        title: Text(
                                          "Etkinliğe bilet almak için tıkla",
                                          style: NeyapsakTheme
                                              .lightTextTheme.headline3,
                                        ),
                                      ),
                                    ),
                                  )))),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 200,
                    child: (userType == "organiser"
                        ? Container(
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color.fromRGBO(206, 83, 62, 1),
                            ),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  "Organizatör kullanıcılar etkinlik kaydedemez",
                                  style: NeyapsakTheme.lightTextTheme.headline3,
                                ),
                              ),
                            ),
                          )
                        : (isLiked
                            ? Container(
                                height: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Color.fromRGBO(84, 101, 179, 1),
                                ),
                                child: Center(
                                  child: ListTile(
                                      onTap: () {
                                        http.get(
                                          Uri.parse(
                                            "http://127.0.0.1:8000/event/removeSaved/?eid=" +
                                                event.id.toString() +
                                                "&" +
                                                "email=" +
                                                userName,
                                          ),
                                          headers: {
                                            'Accept':
                                                'application/json; charset=UTF-8',
                                            'Content-Type': 'application/json'
                                          },
                                        );
                                        setState(() {
                                          isLiked = false;
                                          if (!isLiked) {
                                            print("must be false: ");
                                          }
                                        });
                                        event.isSaved = false;
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              settings: RouteSettings(
                                                  name: eventDetailPath),
                                              builder: (context) {
                                                final appStateManager = Provider
                                                    .of<AppStateManager>(
                                                        context,
                                                        listen: false);
                                                appStateManager
                                                    .setViewedEvent(event);
                                                return EventDetailScreen(
                                                    event: event);
                                              }),
                                        );
                                      },
                                      title: Text(
                                        "Etkinliği favorilerinden kaldırmak için tıkla",
                                        style: NeyapsakTheme
                                            .lightTextTheme.headline3,
                                      )),
                                ),
                              )
                            : Container(
                                height: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: NeyapsakTheme.light().cardColor,
                                ),
                                child: Center(
                                  child: ListTile(
                                    onTap: () {
                                      http.get(
                                        Uri.parse(
                                          "http://127.0.0.1:8000/event/save/?eid=" +
                                              event.id.toString() +
                                              "&" +
                                              "email=" +
                                              userName,
                                        ),
                                        headers: {
                                          'Accept':
                                              'application/json; charset=UTF-8',
                                          'Content-Type': 'application/json'
                                        },
                                      );
                                      setState(() {
                                        isLiked = true;
                                        if (isLiked) {}
                                      });
                                      event.isSaved = true;
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            settings: RouteSettings(
                                                name: eventDetailPath),
                                            builder: (context) {
                                              final appStateManager =
                                                  Provider.of<AppStateManager>(
                                                      context,
                                                      listen: false);
                                              appStateManager
                                                  .setViewedEvent(event);
                                              return EventDetailScreen(
                                                  event: event);
                                            }),
                                      );
                                      //favorilere ekle
                                    },
                                    title: Text(
                                      "Etkinliği favorilerine eklemek için tıkla",
                                      style: NeyapsakTheme
                                          .lightTextTheme.headline3,
                                    ),
                                  ),
                                ),
                              ))),
                  )
                ],
              ),
              SizedBox(
                width: 300,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
