import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  //Depois da refatoração
  final String dbPath = await getDatabasesPath();
  final path = join(dbPath, 'bytebank.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDao.tableSql);
    },
    version: 1,
    //onDowngrade: onDatabaseDowngradeDelete,
  );

  //Antes da refatoração
  // return getDatabasesPath().then((value) {
  //   final String path = join(value, 'bytebank.db');
  //   return openDatabase(
  //     path,
  //     onCreate: (db, version) {
  //       db.execute('''CREATE TABLE contacts(
  //         id INTEGER PRIMARY KEY,
  //         name TEXT,
  //         account_number INTEGER)''');
  //     },
  //     version: 1,
  //     //onDowngrade: onDatabaseDowngradeDelete,
  //   );
  // });
}
