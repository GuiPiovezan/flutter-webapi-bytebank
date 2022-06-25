import 'package:http/http.dart';

var uri = Uri.parse('http://192.168.0.107:8080/transactions');

void findAll() async {
  final Response response = await get(uri);
  print(response.body);
}
