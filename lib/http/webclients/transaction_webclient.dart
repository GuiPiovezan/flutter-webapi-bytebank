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

    List<Transaction> transactions = _toTransactions(response);

    return transactions;
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

    return _toTransaction(response);
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> json = jsonDecode(response.body);

    return Transaction.fromJson(json);
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);

    List<Transaction> transactions = [];

    for (Map<String, dynamic> item in decodedJson) {
      transactions.add(Transaction.fromJson(item));
    }
    return transactions;
  }
}
