// ignore_for_file: constant_identifier_names, prefer_conditional_assignment, unnecessary_null_comparison, avoid_init_to_null
import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/models/models.dart';
import 'neyapsak_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PageState { none, addPage, addAll, addWidget, pop, replace, replaceAll }

const String LoggedInKey = 'LoggedIn';

class PageAction {
  PageState state;
  PageConfiguration? page;
  List<PageConfiguration>? pages;
  Widget? widget;

  PageAction(
      {this.state = PageState.none,
      this.page = null,
      this.pages = null,
      this.widget = null});
}

class AppStateManager extends ChangeNotifier {
  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;

  String _userType = "regular";
  String get userType => _userType;

  String _userCity = "None";
  String get userCity => _userCity;

  String _userMail = "";
  String get userMail => _userMail;
  String _userPwd = "";
  String get userPwd => _userPwd;
  var _viewedEvent = null;
  get viewedEvent => _viewedEvent;
  var _searchKey = "";
  var _maxPrice = "";
  var _minPrice = "";
  var _sDate = "";
  var _eLocation = "";
  get searchKey => _searchKey;
  get maxPrice => _maxPrice;
  get minPrice => _minPrice;
  get sDate => _sDate;
  get eLocation => _eLocation;

  PageAction _currentAction = PageAction();
  PageAction get currentAction => _currentAction;
  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  AppStateManager() {
    getLoggedInState();
  }
  void resetCurrentAction() {
    _currentAction = PageAction();
  }

  void goToSearch() {
    _currentAction =
        PageAction(state: PageState.replaceAll, page: LoginPageConfig);
    notifyListeners();
  }

  void setSearchKey(var key) {
    _searchKey = key;
    notifyListeners();
  }

  void setmaxPrice(var key) {
    _maxPrice = key;
    notifyListeners();
  }

  void setminPrice(var key) {
    _minPrice = key;
    notifyListeners();
  }

  void setsDate(var key) {
    _sDate = key;
    notifyListeners();
  }

  void seteLocation(var key) {
    _eLocation = key;
    notifyListeners();
  }

  void setViewedEvent(var event) {
    _viewedEvent = event;
    notifyListeners();
  }

  void goToLogin() {
    _currentAction =
        PageAction(state: PageState.addPage, page: LoginPageConfig);
    notifyListeners();
  }

  void goToUserTypeSelection(String email, String pwd) {
    _userPwd = pwd;
    _userMail = email;
    _currentAction =
        PageAction(state: PageState.addPage, page: SelectUserTypePageConfig);
    notifyListeners();
  }

  void selectUserType(String enteredUserType) {
    _userType = enteredUserType;
    notifyListeners();
  }

  void selectUserCity(String enteredUserCity) {
    _userCity = enteredUserCity;
    notifyListeners();
  }

  void login(String myUserMail, String myUserType, String myUserCity) {
    _loggedIn = true;
    _userType = myUserType;
    _userCity = myUserCity;
    saveLoginState(isLoggedIn);
    _userMail = myUserMail;
    notifyListeners();
    // _currentAction =
    //     PageAction(state: PageState.replaceAll, page: HomePageConfig);
    // notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    saveLoginState(isLoggedIn);
    // _currentAction =
    //     PageAction(state: PageState.replaceAll, page: HomePageConfig);
    notifyListeners();
  }

  void saveLoginState(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(LoggedInKey, loggedIn);
  }

  void getLoggedInState() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool(LoggedInKey) ?? false;
    if (_loggedIn == null) {
      _loggedIn = false;
    }
  }

  void searchEvent(String query) {
    _currentAction =
        PageAction(state: PageState.addPage, page: SearchResultPageConfig);
    notifyListeners();
  }

  void goToEventPage(Event event) {
    _currentAction =
        PageAction(state: PageState.addPage, page: EventDetailPageConfig);
    notifyListeners();
  }
}
