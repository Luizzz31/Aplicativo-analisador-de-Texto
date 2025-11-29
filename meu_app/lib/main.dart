import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/database_service.dart';
import 'viewmodels/cadastro_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'views/tela_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados (cria se não existir)
  await DatabaseService().db;

  runApp(const AnalisadorDeTextoApp());
}

class AnalisadorDeTextoApp extends StatelessWidget {
  const AnalisadorDeTextoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CadastroViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp(
        title: 'Analisador de Texto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const TelaLogin(),
      ),
    );
  }
}
