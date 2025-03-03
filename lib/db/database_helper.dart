import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../models/smartphone.dart';

class DatabaseHelper {
  static final DatabaseHelper _singleton = DatabaseHelper._internal();
  DatabaseHelper._internal();
  factory DatabaseHelper() => _singleton;

  static const String _dbName = "smartphones.db";
  static const String _storeName = "smartphone_store";

  Database? _database;
  final _store = intMapStoreFactory.store(_storeName);

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = "${dir.path}/$_dbName";
    return databaseFactoryIo.openDatabase(dbPath);
  }

  Future<int> insertSmartphone(Smartphone phone) async {
    final db = await database;
    final id = await _store.add(db, phone.toMap());
    return id;
  }

  Future<List<Smartphone>> getSmartphones() async {
    final db = await database;
    final snapshots = await _store.find(db);
    return snapshots.map((snapshot) {
      final data = snapshot.value as Map<String, dynamic>;
      return Smartphone.fromMap({...data, 'id': snapshot.key});
    }).toList();
  }

  Future<void> updateSmartphone(int id, Smartphone phone) async {
    final db = await database;
    final finder = Finder(filter: Filter.byKey(id));
    await _store.update(db, phone.toMap(), finder: finder);
  }

  Future<void> deleteSmartphone(int id) async {
    final db = await database;
    final finder = Finder(filter: Filter.byKey(id));
    await _store.delete(db, finder: finder);
  }
}
