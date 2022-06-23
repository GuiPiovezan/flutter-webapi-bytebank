import '../../models/contact.dart';
import '../app_database.dart';

class ContactDao {
  static const String tableSql = '''CREATE TABLE $_tableName(
          $_id INTEGER PRIMARY KEY,
          $_name TEXT,
          $_accountNumber INTEGER)''';

  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  Future<int> save(Contact contact) async {
    //Depois da refatoração
    final db = await getDatabase();
    Map<String, dynamic> contactMap = toMap(contact);

    return db.insert(_tableName, contactMap);

    //Antes da refatoração
    // return getDatabase().then((db) {
    //   final Map<String, dynamic> contactMap = {};
    //   contactMap['name'] = contact.name;
    //   contactMap['account_number'] = contact.accountNumber;
    //   return db.insert('contacts', contactMap);
    // });
  }

  Map<String, dynamic> toMap(Contact contact) {
    final Map<String, dynamic> contactMap = {};

    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {
    //Depois da refatoração
    final db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = toList(result);

    return contacts;

    //Antes da refatoração
    // return getDatabase().then((value) {
    //   return value.query('contacts').then((maps) {
    //     final List<Contact> contacts = [];
    //     for (Map<String, dynamic> map in maps) {
    //       final Contact contact = Contact(
    //         map['id'],
    //         map['name'],
    //         map['account_number'],
    //       );
    //       contacts.add(contact);
    //     }
    //     return contacts;
    //   });
    // });
  }

  List<Contact> toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = [];

    for (Map<String, dynamic> row in result) {
      final Contact contact = Contact(
        row[_id],
        row[_name],
        row[_accountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}
