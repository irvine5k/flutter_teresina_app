import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final _firestoreInstance = Firestore.instance;

  bool isLoading = false;

  Future<bool> sendForm(String name, String email, String cpf) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestoreInstance.collection('people').add({
        'name': name,
        'email': email,
        'cpf': cpf,
      });

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();

      return false;
    }
  }
}
