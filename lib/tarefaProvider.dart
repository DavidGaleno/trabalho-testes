import 'package:flutter/material.dart';

import 'models/tarefa.dart';

class TarefasProvider with ChangeNotifier {
  List<Tarefa> _tarefas = [
    Tarefa(id: 1, titulo: 'Teste', concluida: true),
    Tarefa(id: 2, titulo: 'Outro Teste', concluida: false),
  ];

  List<Tarefa> get tarefas => _tarefas;

  set tarefas(List<Tarefa> value) {
    _tarefas = value;
    notifyListeners();
  }
}
