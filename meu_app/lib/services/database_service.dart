import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../models/usuario.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'usuarios.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_completo TEXT NOT NULL,
            cpf TEXT NOT NULL,
            data_nascimento TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha_hash TEXT NOT NULL
          )
        ''');
      },
    );
  }

  String gerarHashSenha(String senhaPura) {
    final bytes = utf8.encode(senhaPura);
    return sha256.convert(bytes).toString();
  }

  Future<int> cadastrarUsuario({
    required String nomeCompleto,
    required String cpf,
    required String dataNascimento,
    required String email,
    required String senhaPura,
  }) async {
    final database = await db;

    final senhaHash = gerarHashSenha(senhaPura);

    final usuario = Usuario(
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      dataNascimento: dataNascimento,
      email: email,
      senhaHash: senhaHash,
    );

    return await database.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Usuario?> autenticarUsuario({
    required String email,
    required String senhaPura,
  }) async {
    final database = await db;
    final senhaHash = gerarHashSenha(senhaPura);

    final result = await database.query(
      'usuarios',
      where: 'email = ? AND senha_hash = ?',
      whereArgs: [email, senhaHash],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }
}
