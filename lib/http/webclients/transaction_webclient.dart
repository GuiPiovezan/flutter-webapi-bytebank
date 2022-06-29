import 'dart:convert';

import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {
  final uri = Uri.parse('http://192.168.0.100:8080/transactions');

  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(uri).timeout(
          const Duration(seconds: 15),
        );

    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic item) => Transaction.fromJson(item))
        .toList();
  }

  Future<Transaction> save(Transaction transaction) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(
      uri,
      headers: {
        'Content-type': 'application/json',
        'password': '1000',
      },
      body: transactionJson,
    );

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
