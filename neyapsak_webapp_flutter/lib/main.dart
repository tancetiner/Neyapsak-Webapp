import 'dart:async';
import 'configure_web.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'navigation/parser.dart';
import 'neyapsak_theme.dart';
import 'package:neyapsak_webapp_flutter/screens/screens.dart';

void main() {
  // configureApp();
  runApp(const NeYapsak());
}

/// This is the main application widget.
class NeYapsak extends StatefulWidget {
  const NeYapsak({Key? key}) : super(key: key);

  @override
  _NeYapsakState createState() => _NeYapsakState();
}

class _NeYapsakState extends State<NeYapsak> {
  final appStateManager = AppStateManager();
  final parser = Parser();
  //MyBackButtonDispatcher backButtonDispatcher;
  late StreamSubscription _linkSubscription;

  _NeYapsakState() {
    //backButtonDispatcher = MyBackButtonDispatcher(delegate);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_linkSubscription != null) _linkSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeyapsakTheme.light();
    var event;
    var searchKey;
    var maxPrice;
    var minPrice;
    var sDate;
    var eDate;
    var eLocation = "";

    return ChangeNotifierProvider<AppStateManager>(
      create: (_) => appStateManager,
      child: MaterialApp(
        //home: HomeScreen(),
        theme: theme,
        initialRoute: loginPath,

        routes: {
          home: (context) => const HomeScreen(),
          loginPath: (context) => LoginScreen(),
          selectUserTypePath: (context) => SelectUserTypeScreen(
                password: '',
                username: '',
              ),
          profilePath: (context) =>
              UserProfileScreen(username: appStateManager.userMail),
          searchResultPath: (context) => SearchResultScreen(
                searchKey: searchKey,
              ),
          managerPath: (context) => const OrganisatorEventManagerScreen(),
          eventDetailPath: (context) => EventDetailScreen(event: event),
        },
        // onGenerateRoute: (settings) {
        //   // If you push the PassArguments route
        //   if (settings.name == searchResultPath) {
        //     // Cast the arguments to the correct
        //     // type: ScreenArguments.
        //     final args = settings.arguments as ScreenArguments;

        //     // Then, extract the required data from
        //     // the arguments and pass the data to the
        //     // correct screen.
        //     return MaterialPageRoute(
        //       builder: (context) {
        //         return SearchResultScreen(
        //           events: args.events,
        //         );
        //       },
        //     );
        //   }
        //   assert(false, 'Need to implement ${settings.name}');
        //   return null;
        // },
      ),
    );
  }

/*
  @override
  void initState() {
    _appRouter = AppRouterDelegate(
      appStateManager: appStateManager,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeyapsakTheme.light();
    return MultiProvider(
        providers: [
          /* ChangeNotifierProvider(
          create: (context) => _groceryManager,
        ), */
          /* ChangeNotifierProvider(
          create: (context) => _profileManager,
        ), */
          ChangeNotifierProvider(
            create: (context) => appStateManager,
          ),
        ],
        child: MaterialApp(
          theme: theme,
          title: 'NeYapsak',
          home: Router(
            routerDelegate: _appRouter,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        ));
  }
*/
}

class ScreenArguments {
  final List<Event> events;

  ScreenArguments(this.events);
}
