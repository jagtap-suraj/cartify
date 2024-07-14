import 'package:cartify/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
  );

  User get user => _user; // Getter that has the return type of User and returns the user object

  /// We are going to pass response.body to this method, which is a string, so we are converting it to a User object.
  /// Then, we are setting the User object to the _user variable and calling the notifyListeners() method to update all the listeners.
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void deleteUser(String id) {
    // Delete the user from provider
    _user = User(
      id: '',
      name: '',
      email: '',
      password: '',
      address: '',
      type: '',
      token: '',
    );
    notifyListeners();
  }
}
