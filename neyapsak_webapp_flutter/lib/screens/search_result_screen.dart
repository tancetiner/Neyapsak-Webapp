// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/models/event_list.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import '../models/models.dart';
import '../components/components.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'screens.dart';

class SearchResultScreen extends StatefulWidget {
  var searchKey;

  SearchResultScreen({Key? key, required this.searchKey}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool isLoading = false;
  late String searchKey;
  late List<Event> events;
  late List<Event> filteredEv;
  bool isFiltered = false;

  final myController0 = TextEditingController();
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController0.dispose();
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }

  //         FUNCTION

  Future<List<Event>> fetchEvents(String searchKey, context) async {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    String userMail = appStateManager.userMail;
    bool isLoading = true;
    List<Event> events2 = [];
    print("HERE: $searchKey");

    final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/event/search/?email=" +
            appStateManager.userMail),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
        },
        body: {
          "name": searchKey,
        });

    if (response.statusCode == 302) {
      var decoded = utf8.decode(response.bodyBytes);
      var items = json.decode(decoded);
      List<Event> eventsHolder = [];
      if (items.length > 0) {
        for (int i = 0; i < items.length; i++) {
          if (items[i] != null) {
            if (items[i]['isSaved']) {}
            Map<String, dynamic> map = items[i];
            eventsHolder.add(Event.fromJson(map));
            print(map);
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

  @override
  Widget build(BuildContext context) {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    if (widget.searchKey != null) {
      appStateManager.setSearchKey(widget.searchKey);
      searchKey = widget.searchKey;
    } else {
      searchKey = appStateManager.searchKey;
    }
    print(searchKey);

    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        color: NeyapsakTheme.light().backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: getBody(fetchEvents(searchKey, context)),
      ),
      backgroundColor: NeyapsakTheme.light().backgroundColor,
    );
  }

  List<Event> filterevent(
      List<Event> mainList, int minP, int maxP, String city, context) {
    late List<Event> eventsF;
    late List<Event> temp;
    eventsF = mainList;
    if (minP != -1) {
      temp = eventsF.where((i) => i.minPrice >= minP).toList();
      eventsF = temp;
    }

    if (maxP != -1) {
      temp = eventsF.where((i) => i.maxPrice < maxP).toList();
      eventsF = temp;
    }

    if (city != "-1") {
      temp = eventsF.where((i) => i.city == city).toList();
      eventsF = temp;
    }
    print(city);
    return eventsF;
  }

  FutureBuilder<List<Event>> getBody(futureEvents) {
    return FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty || snapshot.data!.contains(null)) {
            return Center(
                child: Text(
              'Aradığın etkinlik bulunamadı, tekrar dene!',
              style: NeyapsakTheme.lightTextTheme.headline2,
            ));
          }

          if (!isFiltered) {
            events = snapshot.data!;
          } else {
            events = filteredEv;
            if (events.isEmpty) {
              return Center(
                  child: Text(
                'Aradığın etkinlik bulunamadı, tekrar dene!',
                style: NeyapsakTheme.lightTextTheme.headline2,
              ));
            }
          }

          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Gelişmiş arama için:",
                style: NeyapsakTheme.lightTextTheme.headline2,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 600,
                  ),
                  Container(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 16.0,
                      ),
                      child: TextFormField(
                        controller: myController,
                        decoration: const InputDecoration(
                          fillColor: Colors.grey,
                          hintText: 'Şehir',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 16.0,
                      ),
                      child: TextFormField(
                        controller: myController2,
                        decoration: const InputDecoration(
                          fillColor: Colors.grey,
                          hintText: 'Alt Fiyat',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 16.0,
                      ),
                      child: TextFormField(
                        controller: myController3,
                        decoration: const InputDecoration(
                          fillColor: Colors.grey,
                          hintText: 'Üst Fiyat',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 400.0,
                  vertical: 16.0,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    var mycity;
                    var myminp;
                    var mymaxp;
                    if (myController.text == "") {
                      mycity = "-1";
                    } else {
                      mycity = myController.text;
                    }
                    if (myController2.text == "") {
                      myminp = -1;
                    } else {
                      myminp = int.parse(myController2.text);
                    }
                    if (myController3.text == "") {
                      mymaxp = -1;
                    } else {
                      mymaxp = int.parse(myController3.text);
                    }
                    setState(() {
                      isFiltered = true;
                      filteredEv = filterevent(
                          snapshot.data!, myminp, mymaxp, mycity, context);
                    });
                  },
                  child: const Text('Submit'),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Arama sonuçlarınız:",
                textAlign: TextAlign.left,
                style: NeyapsakTheme.lightTextTheme.headline2,
              ),
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
                width: 100,
                height: 100,
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
}
