import 'package:contacts/model/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactProviderNotifier extends StateNotifier<List<Contact>> {
  ContactProviderNotifier() : super(const []);

  void getAllContacts(List<Contact> contactList) {
    state = [...state, ...contactList];
  }

  void getSearchedContacts(List<Contact> contactList) {
    state = contactList;
  }
}

final contactProvider =
    StateNotifierProvider<ContactProviderNotifier, List<Contact>>(
        (ref) => ContactProviderNotifier());
