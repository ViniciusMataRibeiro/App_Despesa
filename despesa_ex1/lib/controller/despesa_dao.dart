import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/despesaModel.dart';

class DespesaDao {
  static const String databaseName = 'despesas.db';
  late Future<Database> database;

  Future connect() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    database = openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        return db.execute("CREATE TABLE IF NOT EXISTS ${Despesa.tableName} ( "
            "${Despesa.columnDespesa} TEXT PRIMARY KEY, "
            "${Despesa.columnTipo} TEXT, "
            "${Despesa.columnValor} DOUBLE)");
      },
    );
  }

  Future<List<Despesa>> getList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Despesa.tableName);

    return List.generate(maps.length, (i) {
      return Despesa(
        nomeDespesa: maps[i][Despesa.columnDespesa],
        tipoDespesa: maps[i][Despesa.columnTipo],
        valorDespesa: maps[i][Despesa.columnValor],
      );
    });
  }

  Future<List<Despesa>> getByTipo(String tipo) async {

    if (tipo == "") {
      return await getList();
    }

    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Despesa.tableName);

    final listfinal = List.generate(maps.length, (i) {
      return Despesa(
        nomeDespesa: maps[i][Despesa.columnDespesa],
        tipoDespesa: maps[i][Despesa.columnTipo],
        valorDespesa: maps[i][Despesa.columnValor],
      );
    });

    return listfinal.where((element) => element.tipoDespesa == tipo).toList();
  }

  Future<void> insert(Despesa despesa) async {
    final Database db = await database;
    await db.insert(
      Despesa.tableName,
      despesa.toMap(),
    );
  }
}