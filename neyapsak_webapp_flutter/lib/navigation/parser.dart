import 'package:flutter/material.dart';
import '../models/models.dart';

class Parser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) {
      return HomePageConfig;
    }

    final path = '/' + uri.pathSegments[0];
    switch (path) {
      case home:
        return HomePageConfig;
      case loginPath:
        return LoginPageConfig;
      case selectUserTypePath:
        return SelectUserTypePageConfig;
      case profilePath:
        return ProfilePageConfig;
      case searchResultPath:
        return SearchResultPageConfig;
      default:
        return HomePageConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Home:
        return const RouteInformation(location: home);
      case Pages.Login:
        return const RouteInformation(location: loginPath);
      case Pages.SelectUserType:
        return const RouteInformation(location: selectUserTypePath);
      case Pages.SearchResult:
        return const RouteInformation(location: searchResultPath);
      case Pages.Profile:
        return const RouteInformation(location: profilePath);
      default:
        return const RouteInformation(location: home);
    }
  }
}
