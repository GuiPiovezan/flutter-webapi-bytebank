import 'package:bytebank/components/progress/progress.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';

import '../database/dao/contact_dao.dart';
import '../models/contact.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<Contact>>(
          initialData: const [],
          future: _dao.findAll(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              // A execução do Future ainda não foi inicializada
              case ConnectionState.none:
                break;
              // A execução do Future está carregando
              case ConnectionState.waiting:
                return Progress();
              // Tem dados disponivel porém não foi finalizado o Future (pedaços de um carregando assíncrono)
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return const Text('Tem um errão aqui em');
                }
                if (snapshot.hasData) {
                  List<Contact>? contacts = snapshot.data;
                  return ListView.builder(
                    itemCount: contacts!.length,
                    itemBuilder: (context, index) {
                      final Contact contact = contacts[index];
                      return _ContactItem(
                        contact,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => TransactionForm(contact)),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                break;
            }

            return const Text('Unknow error');
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => const ContactForm()))
              .then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onTap;
  const _ContactItem(this.contact, {required this.onTap})
      // ignore: unnecessary_null_comparison
      : assert(onTap != null);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onTap(),
        title: Text(
          contact.name,
          style: const TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
