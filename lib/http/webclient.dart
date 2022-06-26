import 'dart:convert';

import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('Resquest');
    print('url: ${data.url}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('Response');
    print('status code: ${data.statusCode}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');

    return data;
  }
}

var uri = Uri.parse('http://192.168.0.107:8080/transactions');

Future<List<Transaction>> findAll() async {
  final Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );
  final Response response = await client.get(uri);

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
