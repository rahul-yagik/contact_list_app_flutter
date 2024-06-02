import 'dart:async';

import 'package:contacts/model/contact.dart';
import 'package:contacts/provider/contact_provider.dart';
import 'package:contacts/util/fetch_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactList extends ConsumerStatefulWidget {
  const ContactList({super.key});

  @override
  ConsumerState<ContactList> createState() => _ContactListState();
}

class _ContactListState extends ConsumerState<ContactList> {
  late ScrollController _scrollController;
  late bool _isLoading;
  String _nameQuery = '';
  String? _next;
  // Timer? _debounce;

  void _getNextValue(String? value) {
    _next = value;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListner);
    _isLoading = true;
    _fetchContactsData();
  }

  Future<void> _fetchContactsData() async {
    await FetchContacts(
      'https://rickandmortyapi.com/api/character?name=$_nameQuery',
      ref,
      _getNextValue,
    ).fetch();
    setState(() {
      _isLoading = false;
    });
  }

  void _scrollListner() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_next != null) {
        FetchContacts(_next!, ref, _getNextValue).fetch();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> contacts = ref.watch(contactProvider);

    Widget content = Center(
      child: Text(
        'No contacts found...',
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (contacts.isNotEmpty) {
      content = ListView.builder(
          controller: _scrollController,
          itemCount: contacts.length + 1,
          itemBuilder: (ctx, index) {
            if (index == contacts.length && _next != null) {
              return const Center(
                heightFactor: 1,
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator()),
              );
            }
            if (index == contacts.length && _next == null) {
              return const SizedBox.shrink();
            }
            return ListTile(
              title: Text(
                contacts[index].name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              leading: CircleAvatar(
                  radius: 20,
                  child: Image.network(
                    contacts[index].image,
                  )),
            );
          });
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
          child: TextField(
            onChanged: (value) async {
              if (value.isEmpty) {
                ref.read(contactProvider.notifier).getSearchedContacts([]);
                return;
              }
              // if (value.length >= 3) {
              _nameQuery = value;
              await FetchContacts(
                'https://rickandmortyapi.com/api/character?name=$_nameQuery',
                ref,
                _getNextValue,
                true,
              ).fetch();
              // }
            },
            decoration: InputDecoration(
              label: const Text("Search by name"),
              border: const OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ),
        Expanded(
          child: content,
        )
      ],
    );
  }
}
