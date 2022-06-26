import 'package:bytebank/components/progress/progress.dart';
import 'package:bytebank/http/webclient.dart';
import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<Transaction>>(
        future: Future.delayed(const Duration(seconds: 1))
            .then((value) => findAll()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Transaction>? transactions = snapshot.data;

              return ListView.builder(
                itemCount: transactions!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.monetization_on),
                      title: Text(
                        transactions[index].value.toString(),
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        transactions[index].contact.accountNumber.toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
              );
          }
          return const Text('Unknow error');
        },
      ),
    );
  }
}
