// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/models/event_list.dart';
import 'package:neyapsak_webapp_flutter/models/models.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';
import '../components/components.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class OrganisatorEventManagerScreen extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: managerPath,
        key: ValueKey(managerPath),
        child: OrganisatorEventManagerScreen());
  }

  const OrganisatorEventManagerScreen({Key? key}) : super(key: key);

  @override
  State<OrganisatorEventManagerScreen> createState() =>
      _OrganisatorEventManagerScreenState();
}

class _OrganisatorEventManagerScreenState
    extends State<OrganisatorEventManagerScreen> {
  List<Event> organiserEvents = [];
  bool isLoading = false;
  String searchKey = AppStateManager().userMail;

  Duration get myTime => Duration(milliseconds: timeDilation.ceil() * 500);

  @override
  void initState() {
    super.initState();
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    String userMail = appStateManager.userMail;
    fetchOrganiserEvents(userMail);
    /*futureEventList = fetchSearchResultEvents("Duman");*/
  }

  fetchOrganiserEvents(String searchKey) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(
          "http://127.0.0.1:8000/event/organiserEvents/?email=" + searchKey),
      headers: {
        'Accept': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var decoded = utf8.decode(response.bodyBytes);
      var items = json.decode(decoded);
      List<Event> eventsHolder = [];
      if (items.length > 0) {
        for (int i = 0; i < items.length; i++) {
          if (items[i] != null) {
            Map<String, dynamic> map = items[i];

            eventsHolder.add(Event.fromJson(map));
          }
        }
      }
      setState(() {
        organiserEvents = eventsHolder;
        isLoading = false;
      });
    } else {
      setState(() {
        organiserEvents = [];
        isLoading = false;
      });
    }
  }

  // Future<http.Response> fetchEvent(AppStateManager appStateManager) {
  //   return http.get(Uri.parse("http://127.0.0.1:8000/user/local/"),
  //       headers: {"email": appStateManager.userMail});
  // }

  Future<void> addEvent(
    int id,
    String name,
    String type,
    DateTime startDate,
    DateTime endDate,
    String city,
    String loc,
    List<String> tags,
    String descr,
    String image,
    int minPrice,
    int maxPrice,
  ) async {
    final myEvent = Event(
      id: id,
      name: name,
      eventType: type,
      city: city,
      location: loc,
      tags: tags,
      eventStartDate: startDate,
      eventEndDate: endDate,
      description: descr,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );

    setState(() {
      organiserEvents.add(myEvent);
    });
  }

  deleteEvent(int id) {
    final response = http.get(
      Uri.parse("http://127.0.0.1:8000/event/delete/?id=" + id.toString()),
      headers: {
        'Accept': 'application/json; charset=UTF-8',
      },
    );
  }

  onCreateTapped(Event event, bool isCreate, String userMail) {
    DateTime eventStartDate = DateTime.now();
    DateTime eventEndDate = DateTime.now();
    String eventImage = "";
    List<String> eventTags = [];

    var eventNameController = TextEditingController();
    var eventTypeController = TextEditingController();
    var eventDescrController = TextEditingController();
    var eventLocationController = TextEditingController();
    var eventCityController = TextEditingController();
    var minPriceController = TextEditingController();
    var maxPriceController = TextEditingController();

    if (!isCreate) {
      eventNameController = TextEditingController(text: event.name);
      eventTypeController = TextEditingController(text: event.eventType);
      eventDescrController = TextEditingController(text: event.description);
      eventLocationController = TextEditingController(text: event.location);
      eventCityController = TextEditingController(text: event.city);
      eventEndDate = event.eventEndDate;
      eventStartDate = event.eventStartDate;
      minPriceController =
          TextEditingController(text: event.minPrice.toString());
      maxPriceController =
          TextEditingController(text: event.maxPrice.toString());
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Login'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 600,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: eventNameController,
                        decoration: InputDecoration(
                          labelText: 'Event Name',
                          icon: Icon(Icons.account_box),
                        ),
                      ),
                      TextFormField(
                        controller: eventTypeController,
                        decoration: InputDecoration(
                          labelText: 'Event Type',
                          icon: Icon(Icons.email),
                        ),
                      ),
                      TextFormField(
                        controller: eventDescrController,
                        decoration: InputDecoration(
                          labelText: 'Event Description',
                          icon: Icon(Icons.message),
                        ),
                      ),
                      TextFormField(
                        controller: eventCityController,
                        decoration: InputDecoration(
                          labelText: 'Event City',
                          icon: Icon(Icons.message),
                        ),
                      ),
                      TextFormField(
                        controller: eventLocationController,
                        decoration: InputDecoration(
                          labelText: 'Event Location',
                          icon: Icon(Icons.message),
                        ),
                      ),
                      TextFormField(
                        controller: minPriceController,
                        decoration: InputDecoration(
                          labelText: 'En ucuz bilet fiyatı',
                          icon: Icon(Icons.message),
                        ),
                      ),
                      TextFormField(
                        controller: maxPriceController,
                        decoration: InputDecoration(
                          labelText: 'En pahalı bilet fiyatı',
                          icon: Icon(Icons.message),
                        ),
                      ),
                      DateTimePicker(
                        initialValue:
                            DateFormat("dd-MM-yyyy").format(eventStartDate),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Başlangıç Tarihini Seçin',
                        onChanged: (val) =>
                            eventStartDate = DateTime.parse(val),
                        // validator: (val) {return null;},
                        onSaved: (val) => eventStartDate = DateTime.parse(val!),
                      ),
                      DateTimePicker(
                        initialValue:
                            DateFormat("dd-MM-yyyy").format(eventEndDate),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Bitiş Tarihini Seçin',
                        onChanged: (val) => eventEndDate = DateTime.parse(val),
                        //validator: (val) {return null;},
                        onSaved: (val) => eventEndDate = DateTime.parse(val!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        NeyapsakTheme.light().cardColor),
                  ),
                  child: Text("Submit"),
                  onPressed: () async {
                    var reqBody = {
                      "name": eventNameController.text,
                      "date": DateFormat("yyyy-MM-dd").format(eventStartDate),
                      "description": eventDescrController.text,
                      "region": eventLocationController.text,
                      "city": eventCityController.text,
                      "type": eventTypeController.text,
                      "duration":
                          eventEndDate.difference(eventStartDate).inDays,
                      "email": userMail,
                      "maxPrice": int.parse(maxPriceController.text),
                      "minPrice": int.parse(minPriceController.text),
                    };
                    if (!isCreate) {
                      int myid = event.id!;
                      final response = await http.post(
                        Uri.parse("http://127.0.0.1:8000/event/edit/?id=" +
                            myid.toString()),
                        body: jsonEncode(reqBody),
                        headers: {
                          'Accept': 'application/json; charset=UTF-8',
                          'Content-Type': 'application/json'
                        },
                      );
                      if (response.statusCode == 200) {
                        setState(() {
                          organiserEvents
                              .removeWhere((element) => element.id == myid);
                        });
                        addEvent(
                            myid,
                            eventNameController.text,
                            eventTypeController.text,
                            eventStartDate,
                            eventEndDate,
                            eventCityController.text,
                            eventLocationController.text,
                            eventTags,
                            eventDescrController.text,
                            eventImage,
                            int.parse(
                              minPriceController.text,
                            ),
                            int.parse(maxPriceController.text));
                        Navigator.pop(context);
                      }
                    } else {
                      final response = await http.post(
                        Uri.parse("http://127.0.0.1:8000/event/create/"),
                        body: jsonEncode(reqBody),
                        headers: {
                          'Accept': 'application/json; charset=UTF-8',
                          'Content-Type': 'application/json'
                        },
                      );
                      if (response.statusCode == 201) {
                        addEvent(
                          json.decode(response.body)["eventID"],
                          eventNameController.text,
                          eventTypeController.text,
                          eventStartDate,
                          eventEndDate,
                          eventCityController.text,
                          eventLocationController.text,
                          eventTags,
                          eventDescrController.text,
                          eventImage,
                          int.parse(minPriceController.text),
                          int.parse(maxPriceController.text),
                        );
                        Navigator.pop(context);
                      }
                    }
                  }),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    String userMail = appStateManager.userMail;

    return Scaffold(
        appBar: MyAppBar(),
        body: Container(
            child: getBody(userMail),
            color: NeyapsakTheme.light().backgroundColor),
        backgroundColor: NeyapsakTheme.light().backgroundColor);
  }

  Widget getBody(String userMail) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (organiserEvents.isEmpty || organiserEvents.contains(null)) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          TextButton(
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: NeyapsakTheme.light().cardColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(20),
              child: Text(
                'Yeni etkinlik eklemek için tıklayın.',
                style: NeyapsakTheme.lightTextTheme.headline6,
              ),
            ),
            onPressed: () {
              onCreateTapped(
                  Event(
                    eventType: '',
                    name: '',
                    eventEndDate: DateTime.now(),
                    eventStartDate: DateTime.now(),
                    id: 951,
                  ),
                  true,
                  userMail);
            },
          ),
          SizedBox(
            height: 30,
          ),
          Center(
              child: Text(
            'Hiç etkinliğiniz yok.',
            style: NeyapsakTheme.lightTextTheme.headline5,
          )),
        ],
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        TextButton(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: NeyapsakTheme.light().cardColor,
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.all(20),
            child: Text(
              'Yeni etkinlik eklemek için tıklayın.',
              style: NeyapsakTheme.lightTextTheme.headline6,
            ),
          ),
          onPressed: () {
            onCreateTapped(
                Event(
                    eventType: '',
                    name: '',
                    eventEndDate: DateTime.now(),
                    eventStartDate: DateTime.now(),
                    id: 656),
                true,
                userMail);
          },
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Etkinlikleriniz:",
          textAlign: TextAlign.left,
          style: NeyapsakTheme.lightTextTheme.headline4,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: organiserEvents.length,
              itemBuilder: (context, index) {
                return getCard(organiserEvents[index], userMail);
              }),
        ),
      ],
    );
  }

  Widget getCard(item, userMail) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 400,
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
                      Text(
                        item.city,
                        style: NeyapsakTheme.lightTextTheme.bodyText2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        item.eventType,
                        style: NeyapsakTheme.lightTextTheme.bodyText2,
                      ),
                      Text(
                        item.description,
                        style: NeyapsakTheme.lightTextTheme.bodyText2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat("dd-MM-yyyy")
                                .format(item.eventStartDate),
                            style: NeyapsakTheme.lightTextTheme.bodyText2,
                          ),
                          Text(
                            " - " +
                                DateFormat("dd-MM-yyyy")
                                    .format(item.eventEndDate),
                            style: NeyapsakTheme.lightTextTheme.bodyText2,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Fiyat aralığı: " +
                              item.minPrice.toString() +
                              " - "),
                          Text(item.maxPrice.toString()),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 700,
                ),
                TextButton(
                  onPressed: () {
                    onCreateTapped(item, false, userMail);
                  },
                  child: Text(
                    'DÜZENLE',
                    style: NeyapsakTheme.lightTextTheme.headline3,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    deleteEvent(item.id);
                    setState(() {
                      organiserEvents
                          .removeWhere((element) => element.id == item.id);
                    });
                  },
                  child: Text(
                    'SİL',
                    style: NeyapsakTheme.lightTextTheme.headline3,
                  ),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}
