import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:journal_project/models/user.dart';
import 'package:journal_project/repository/user_repository.dart';

class UserModel with ChangeNotifier {
  User _user;
  final UserRepository _repository = new UserRepository();

  void registerUser(
      String uid, String name, String email, String imageUrl, bool isLogin) {
    _user = new User(uid, name, email, imageUrl, isLogin);
    notifyListeners();
  }

  void releaseUser() {
    _user = null;
    notifyListeners();
  }

  void getUser(String documentName, String uid) async {}

  Future<bool> isUser(String uid) async {
    return await _repository.isExistUserByUid(uid);
  }

  bool isLogin() {
    if (_user == null) _user = new User(null, null, null, null, false);
    return _user.isLogin;
  }

  User getLocalUser() {
    return _user;
  }
}
