// lib/providers/contacts_provider.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/contact.dart';

class ContactsProvider extends ChangeNotifier {
  List<Contact> _contacts = [];
  final String _storageKey = 'user_contacts';

  List<Contact> get contacts => _contacts;

  ContactsProvider() {
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList(_storageKey) ?? [];

    _contacts =
        contactsJson.map((json) => Contact.fromMap(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson =
        _contacts.map((contact) => jsonEncode(contact.toMap())).toList();
    await prefs.setStringList(_storageKey, contactsJson);
  }

  Future<void> addContact(Contact contact) async {
    _contacts.add(contact);
    await _saveContacts();
    notifyListeners();
  }

  Future<void> removeContact(String id) async {
    _contacts.removeWhere((contact) => contact.id == id);
    await _saveContacts();
    notifyListeners();
  }

  Future<void> updateContact(Contact contact) async {
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      await _saveContacts();
      notifyListeners();
    }
  }

  List<Contact> getEmergencyContacts() {
    return _contacts.where((contact) => contact.isEmergency).toList();
  }
}
