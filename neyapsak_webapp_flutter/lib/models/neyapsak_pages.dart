// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'app_state_manager.dart';

const String loginPath = '/login';
const String selectUserTypePath = '/user_type';
const String home = '/';
const String profilePath = '/profile';
const String searchResultPath = '/search';
const String managerPath = "/manager";
const String singleManagerPath = "/single_manager";
const String eventDetailPath = "/event_detail";
const String homeButtonPath = '/showByType';

enum Pages {
  Login,
  SelectUserType,
  Home,
  Profile,
  SearchResult,
  Manager,
  SingleManager,
  EventDetail
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction? currentPageAction;

  PageConfiguration(
      {required this.key,
      required this.path,
      required this.uiPage,
      this.currentPageAction});
}

PageConfiguration SelectUserTypePageConfig = PageConfiguration(
    key: 'SelectUserType',
    path: selectUserTypePath,
    uiPage: Pages.SelectUserType,
    currentPageAction: null);
PageConfiguration LoginPageConfig = PageConfiguration(
    key: 'Login',
    path: loginPath,
    uiPage: Pages.Login,
    currentPageAction: null);
PageConfiguration HomePageConfig = PageConfiguration(
    key: 'Home', path: home, uiPage: Pages.Home, currentPageAction: null);
PageConfiguration SearchResultPageConfig = PageConfiguration(
    key: 'SearchResult', path: searchResultPath, uiPage: Pages.SearchResult);
PageConfiguration ProfilePageConfig = PageConfiguration(
    key: 'Profile',
    path: profilePath,
    uiPage: Pages.Profile,
    currentPageAction: null);
PageConfiguration ManagerPageConfig = PageConfiguration(
    key: 'Manager',
    path: managerPath,
    uiPage: Pages.Manager,
    currentPageAction: null);
PageConfiguration SingleManagerPageConfig = PageConfiguration(
    key: 'SingleManager',
    path: singleManagerPath,
    uiPage: Pages.SingleManager,
    currentPageAction: null);
PageConfiguration EventDetailPageConfig = PageConfiguration(
    key: 'EventDetail',
    path: eventDetailPath,
    uiPage: Pages.EventDetail,
    currentPageAction: null);
