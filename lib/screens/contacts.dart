import 'package:contacts/widgets/contact_list.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
            // centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            toolbarHeight: 80,
            titleSpacing: 0,
            leading: Icon(
              Icons.contact_page_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            titleTextStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
            title: const Text(
              "Contacts",
            )),
      ),
      body: const ContactList(),
    );
  }
}
