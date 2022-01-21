// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import '../models/models.dart';
import '../components/components.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'screens.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  const UserProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Event> eventsTickets = [];
  List<Event> eventsPast = [];
  List<Event> eventsLiked = [];
  late AppStateManager appStateManager;
  bool isTicketsLoading = false;
  bool isLikedLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        var args = ModalRoute.of(context)!.settings.arguments;
      });

      fetchEventsTickets(widget.username);
      fetchEventsLiked(widget.username);
    });
  }

  fetchEventsTickets(String userName) async {
    setState(() {
      isTicketsLoading = true;
    });

    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/event/showTicket/?email=" + userName),
      headers: {
        'Accept': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print(response);
      var decoded = utf8.decode(response.bodyBytes);
      var items = json.decode(decoded);
      List<Event> eventsHolder = [];
      if (items.length > 0) {
        for (int i = 0; i < items.length; i++) {
          if (items[i] != null) {
            Map<String, dynamic> map = items[i];

            eventsHolder.add(Event.fromJson(map));
            print(map);
          }
        }
      }
      setState(() {
        for (int j = 0; j < eventsHolder.length; j++) {
          if (eventsHolder[j].eventEndDate.isBefore(DateTime.now())) {
            eventsPast.add(eventsHolder[j]);
          } else {
            eventsTickets.add(eventsHolder[j]);
          }
        }
        isTicketsLoading = false;
      });
    } else {
      setState(() {
        eventsTickets = [];
        isTicketsLoading = false;
      });
    }
  }

  fetchEventsLiked(String userName) async {
    setState(() {
      isLikedLoading = true;
    });
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/event/showSaved/?email=" + userName),
      headers: {
        'Accept': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print(response);
      var decoded = utf8.decode(response.bodyBytes);
      var items = json.decode(decoded);
      List<Event> eventsHolder = [];
      if (items.length > 0) {
        for (int i = 0; i < items.length; i++) {
          if (items[i] != null) {
            Map<String, dynamic> map = items[i];

            eventsHolder.add(Event.fromJson(map));
            print(map);
          }
        }
      }
      for (int k = 0; k < eventsHolder.length; k++) {
        eventsHolder[k].isSaved = true;
      }
      setState(() {
        eventsLiked = eventsHolder;
        isLikedLoading = false;
      });
    } else {
      setState(() {
        eventsLiked = [];
        isLikedLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appStateManager = Provider.of<AppStateManager>(context);
    String userName = appStateManager.userMail;

    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: NeyapsakTheme.light().backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(186, 189, 190, 1)),
                    width: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Kullanıcı Bilgileri",
                          style: NeyapsakTheme.lightTextTheme.headline2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Kullanıcı adınız: " + appStateManager.userMail,
                            style: NeyapsakTheme.lightTextTheme.headline3),
                        SizedBox(height: 5),
                        Container(
                          child: appStateManager.userCity != ""
                              ? Text("Şehir: " + appStateManager.userCity,
                                  style: NeyapsakTheme.lightTextTheme.headline3)
                              : Text("Şehir: (Girimedi)",
                                  style:
                                      NeyapsakTheme.lightTextTheme.headline3),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 1000,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Biletleriniz:",
                textAlign: TextAlign.left,
                style: NeyapsakTheme.lightTextTheme.headline2,
              ),
              SizedBox(
                height: 10,
              ),
              getTicketToEventsList(),
              SizedBox(
                height: 30,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Beğendiğiniz Etkinlikler:",
                textAlign: TextAlign.left,
                style: NeyapsakTheme.lightTextTheme.headline2,
              ),
              SizedBox(height: 10),
              getLikedEventsList(),
              SizedBox(
                height: 30,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Etkinlik Geçmişiniz:",
                textAlign: TextAlign.left,
                style: NeyapsakTheme.lightTextTheme.headline2,
              ),
              SizedBox(
                height: 10,
              ),
              getPastEventsList()
            ],
          ),
        ),
      ),
    );
  }

  Widget getTicketToEventsList() {
    if (isTicketsLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (eventsTickets.isEmpty || eventsTickets.contains(null)) {
      return Center(child: Text('No items'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: eventsTickets.length,
      itemBuilder: (context, index) {
        return getTicketsCard(eventsTickets[index]);
      },
    );
  }

  Widget getPastEventsList() {
    if (isTicketsLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (eventsPast.isEmpty || eventsPast.contains(null)) {
      return Center(child: Text('Etkinlik geçmişiniz boş'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: eventsPast.length,
      itemBuilder: (context, index) {
        return getTicketsCard(eventsPast[index]);
      },
    );
  }

  Widget getLikedEventsList() {
    if (isLikedLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (eventsLiked.isEmpty || eventsLiked.contains(null)) {
      return Center(child: Text('No items'));
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: eventsLiked.length,
        itemBuilder: (context, index) {
          return getLikedCard(eventsLiked[index]);
        });
  }

  Widget getTicketsCard(item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            title: Row(
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: (item.eventType == "konser")
                    ? DecorationImage(image: AssetImage("concert.png"))
                    : (item.eventType == "festival")
                        ? DecorationImage(image: AssetImage("festival.png"))
                        : DecorationImage(image: AssetImage("theatre.png")),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.name,
                    style: NeyapsakTheme.lightTextTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    item.id.toString(),
                    style: NeyapsakTheme.lightTextTheme.bodyText2,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 700,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: eventDetailPath),
                      builder: (context) => EventDetailScreen(event: item)),
                );
              },
              child: Text(
                'Etkinlik sayfasına git',
                style: NeyapsakTheme.lightTextTheme.headline3,
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget getLikedCard(item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            title: Row(
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: (item.eventType == "konser")
                    ? DecorationImage(image: AssetImage("concert.jpg"))
                    : (item.eventType == "festival")
                        ? DecorationImage(image: AssetImage("festival.png"))
                        : DecorationImage(image: AssetImage("theatre.png")),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.name,
                    style: NeyapsakTheme.lightTextTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    item.id.toString(),
                    style: NeyapsakTheme.lightTextTheme.bodyText2,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 700,
            ),
            TextButton(
              onPressed: () async {
                final response = await http.get(
                  Uri.parse("http://127.0.0.1:8000/event/removeSaved/?email=" +
                      widget.username +
                      "&" +
                      "eid=" +
                      item.id.toString()),
                  headers: {
                    'Accept': 'application/json; charset=UTF-8',
                  },
                );
                setState(() {
                  eventsLiked.remove(item);
                });
              },
              child: Text(
                'SİL',
                style: NeyapsakTheme.lightTextTheme.headline3,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: eventDetailPath),
                      builder: (context) => EventDetailScreen(event: item)),
                );
              },
              child: Text(
                'Etkinlik sayfasına git',
                style: NeyapsakTheme.lightTextTheme.headline3,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
