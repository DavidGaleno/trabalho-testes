import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarefas/lista_tarefas.dart';
import 'package:tarefas/tarefaProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TarefasProvider())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent)
                  .copyWith(background: Color.fromRGBO(255, 229, 153, 1))),
          home: ListaTarefas(),
        ));
  }
}
