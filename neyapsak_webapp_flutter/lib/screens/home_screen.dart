import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/models/event_list.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../components/components.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import 'package:neyapsak_webapp_flutter/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
      name: home,
      key: ValueKey(home),
      child: HomeScreen(),
    );
  }

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppStateManager appStateManager;

  //BETWEEN THIS
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

  //AND THIS
  @override
  Widget build(BuildContext context) {
    appStateManager = Provider.of<AppStateManager>(context);
    // getdata();
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text("Aramak istediğin etkinliğin adını gir:",
                style: NeyapsakTheme.lightTextTheme.headline4),
          ),
          EventList(),

/*
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 100.0,
            ),
            child: getBody(fetchEvents("a", context)),
          )*/
        ],
      ),
    );
  }
}
