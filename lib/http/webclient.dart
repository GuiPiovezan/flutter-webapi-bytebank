import 'dart:convert';

import 'package:bytebank/http/interceptors/logging_interceptior.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
);

final uri = Uri.parse('http://192.168.0.100:8080/transactions');

Future<List<Transaction>> findAll() async {
  final Response response = await client.get(uri).timeout(
        const Duration(seconds: 15),
      );

  final List<dynamic> decodedJson = jsonDecode(response.body);

  List<Transaction> transactions = [];

  for (Map<String, dynamic> item in decodedJson) {
    final contactsJson = item['contact'];

    Transaction transaction = Transaction(
      item['value'],
      Contact(
        0,
        contactsJson['name'],
        contactsJson['accountNumber'],
      ),
    );

    transactions.add(transaction);
  }

  return transactions;
}

Future<Transaction> save(Transaction transaction) async {
  Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  };

  final String transactionJson = jsonEncode(transactionMap);

  final Response response = await client.post(
    uri,
    headers: {
      'Content-type': 'application/json',
      'password': '1000',
    },
    body: transactionJson,
  );

  Map<String, dynamic> json = jsonDecode(response.body);

  return Transaction(
    json['value'],
    Contact(
      0,
      json['contact']['name'],
      json['contact']['accountNumber'],
    ),
  );
}
