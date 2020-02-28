import 'package:flutter/widgets.dart';

import 'package:journal_project/models/user.dart';

class UserModel with ChangeNotifier {
  User _user;

  void registerUser(
      String uid, String name, String email, String imageUrl, bool isLogin) {
    _user = new User(uid, name, email, imageUrl, isLogin);
    notifyListeners();
  }

  void releaseUser() {
    _user = null;
    notifyListeners();
  }

  bool isLogin() {
    return _user.isLogin;
  }
}
