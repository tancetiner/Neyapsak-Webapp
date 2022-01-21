// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'dart:html';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/models/models.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import 'package:neyapsak_webapp_flutter/screens/screens.dart';
import 'package:provider/provider.dart';

late String searchKey = "";

class EventList extends StatefulWidget {
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  //AFTER THIS

  bool isLoading = false;
  late String searchKey;
  late List<Event> events;
  late List<Event> filteredEv;
  bool isFiltered = false;
  late String usercity;

  //         FUNCTION

  Future<List<Event>> fetchEvents(String searchKey, context) async {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    String userMail = appStateManager.userMail;
    bool isLoading = true;
    List<Event> events2 = [];
    usercity = appStateManager.userCity;
    final response = await http.get(
      Uri.parse(
          "http://127.0.0.1:8000/event/?email=" + appStateManager.userMail),
      headers: {
        'Accept': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 302 || response.statusCode == 200) {
      var decoded = utf8.decode(response.bodyBytes);
      var items = json.decode(decoded);
      List<Event> eventsHolder = [];

      if (items.length > 0) {
        for (int i = 0; i < items.length; i++) {
          if (items[i] != null) {
            if (items[i]['isSaved']) {}

            Map<String, dynamic> map = items[i];
            eventsHolder.add(Event.fromJson(map));
            // print(map);
          }
        }
      }
      events2 = eventsHolder;
      events2.sort((b, a) => a.eventEndDate.compareTo(b.eventEndDate));
      isLoading = false;
    } else {
      isLoading = false;
    }

    return events2;
  }

  @override
  void initState() {
    isLoading = true;
    super.initState();
  }

  List<Event> filterevent(
      List<Event> mainList, int minP, int maxP, String city, context) {
    late List<Event> eventsF;
    late List<Event> temp;
    city = city.toUpperCase();
    eventsF = mainList;
    //print(eventsF[0].city);
    if (minP != -1) {
      temp = eventsF.where((i) => i.minPrice >= minP).toList();
      eventsF = temp;
    }

    if (maxP != -1) {
      temp = eventsF.where((i) => i.maxPrice < maxP).toList();
      eventsF = temp;
    }

    if (city != "-1") {
      temp = eventsF
          .where((i) => i.city.toLowerCase() == city.toLowerCase())
          .toList();
      eventsF = temp;
    }
    return eventsF;
  }

  FutureBuilder<List<Event>> getBody(futureEvents) {
    return FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty || snapshot.data!.contains(null)) {}

          if (!isFiltered) {
            events = snapshot.data!;
            isFiltered = true;
            print("USERCITY" + usercity);
            if (usercity == "None" || usercity == "" || usercity == " ") {
              print("it is null");
              usercity = "-1";
            }
            if (usercity == "-1") {
              return Center(
                child: Text(
                  "Şehir bilgisi girmediğiniz için konum bazlı öneri yapamamaktayız.",
                  style: NeyapsakTheme.lightTextTheme.headline2,
                ),
              );
            }
            events = filterevent(snapshot.data!, -1, -1, usercity, context);

            if (events.isEmpty) {
              return Center(
                  child: Text(
                'Bu şehirde etkinlik bulunmamakta!',
                style: NeyapsakTheme.lightTextTheme.headline2,
              ));
            }
          } else {
            events = filterevent(snapshot.data!, -1, -1, usercity, context);

            if (events.isEmpty) {
              return Center(
                  child: Text(
                'Bu şehirde etkinlik bulunmamakta!',
                style: NeyapsakTheme.lightTextTheme.headline2,
              ));
            }
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return getCard(events[index]);
                    }),
              ),
            ],
          );
        });
  }

  Widget getCard(item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: eventDetailPath),
                  builder: (context) {
                    final appStateManager =
                        Provider.of<AppStateManager>(context, listen: false);
                    appStateManager.setViewedEvent(item);
                    return EventDetailScreen(event: item);
                  }),
            );
          },
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          item.name,
                          style: NeyapsakTheme.lightTextTheme.bodyText1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          item.city,
                          style: NeyapsakTheme.lightTextTheme.bodyText1,
                        ),
                        Text(
                          "  -  " + item.location,
                          style: NeyapsakTheme.lightTextTheme.bodyText1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat("dd-MM-yyyy").format(item.eventStartDate),
                          style: NeyapsakTheme.lightTextTheme.bodyText1,
                        ),
                        Text(
                          "  -  " +
                              DateFormat("dd-MM-yyyy")
                                  .format(item.eventEndDate),
                          style: NeyapsakTheme.lightTextTheme.bodyText1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Fiyat Aralığı: " + item.minPrice.toString(),
                          style: NeyapsakTheme.lightTextTheme.bodyText1,
                        ),
                        Text(
                          "  -  " + item.maxPrice.toString(),
                          style: NeyapsakTheme.lightTextTheme.bodyText1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      item.description,
                      style: NeyapsakTheme.lightTextTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              (item.eventEndDate.isBefore(DateTime.now())
                  ? Row(
                      children: const [
                        SizedBox(
                          width: 500,
                        ),
                        Text("Bu etkinliğin tarihi geçmiş!"),
                      ],
                    )
                  : Text("")),
            ],
          ),
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Container(
          width: 875.0,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 900,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 250.0,
                    vertical: 16.0,
                  ),
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      fillColor: NeyapsakTheme.light().primaryColorLight,
                      hintText: 'Etkinlik ismi girin',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      //print(myController.text);
                      setState() {
                        searchKey = myController.text;
                      }

                      searchKey = myController.text;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 400.0,
                  vertical: 16.0,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    //print("Search:");
                    //print(myController.text);

                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings:
                                const RouteSettings(name: searchResultPath),
                            builder: (context) => SearchResultScreen(
                                  searchKey: myController.text,
                                )),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100.0,
                        vertical: 2.0,
                      ),
                      child: const Text('Festival'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100.0,
                        vertical: 2.0,
                      ),
                      child: const Text('Konser'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 105.0,
                        vertical: 2.0,
                      ),
                      child: const Text('Tiyatro'),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: IconButton(
                        iconSize: 150.0,
                        icon: const Image(
                          image: AssetImage("festival.jpg"),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings:
                                  const RouteSettings(name: searchResultPath),
                              builder: (context) => SearchResultScreen(
                                searchKey: "Festival",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: IconButton(
                        iconSize: 150.0,
                        icon: const Image(
                          image: AssetImage("concert.png"),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings:
                                  const RouteSettings(name: searchResultPath),
                              builder: (context) => SearchResultScreen(
                                searchKey: "Konser",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 10.0,
                      ),
                      child: IconButton(
                        iconSize: 150.0,
                        icon: const Image(
                          image: AssetImage("theatre.png"),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings:
                                  const RouteSettings(name: searchResultPath),
                              builder: (context) => SearchResultScreen(
                                searchKey: "Tiyatro",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                  child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Yaşadığınız Yere Yakın Etkinlikler",
                  style: NeyapsakTheme.lightTextTheme.headline2,
                ),
              )),
              Container(
                width: 1000,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: NeyapsakTheme.light().primaryColorLight,
                ),
                child: getBody(fetchEvents("a", context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





/*
class EventList extends StatelessWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Home Page Taslak",
            style: TextStyle(fontWeight: FontWeight.w800, height: 0.9),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Taslak testi home page",
            style: TextStyle(fontSize: 21, height: 1.7),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Taslak testi home page",
            style: TextStyle(fontSize: 21, height: 1.7),
          ),
        ],
      ),
    );
  }
}
*/