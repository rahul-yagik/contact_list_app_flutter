import 'dart:convert';

import 'package:contacts/model/contact.dart';
import 'package:contacts/provider/contact_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FetchContacts {
  const FetchContacts(this.uri, this.ref, this.getNextValue,
      [this.isSearched = false]);

  final String uri;
  final WidgetRef ref;
  final void Function(String? value) getNextValue;
  final bool isSearched;

  Future<void> fetch() async {
    final url = Uri.parse(uri);
    print('Calling Fetch Contacts...');

    try {
      final response = await http.get(url);

      if (response.body == 'null') {
        return;
      }

      Map<String, dynamic> data = json.decode(response.body);

      print(data);

      if (data['error'] != null) {
        print("Error Eroor");
        if (isSearched) {
          ref.read(contactProvider.notifier).getSearchedContacts([]);
        }
        return;
      }

      getNextValue(data['info']['next']);

      List<Contact> loadedContact = [];
      for (final contact in data['results']) {
        loadedContact.add(Contact(
            id: contact['id'], name: contact['name'], image: contact['image']));
      }

      if (isSearched) {
        ref.read(contactProvider.notifier).getSearchedContacts(loadedContact);
      } else {
        ref.read(contactProvider.notifier).getAllContacts(loadedContact);
      }
    } catch (error) {
      print(error);
    }
  }
}
