import 'package:flutter/material.dart';

import 'models/tarefa.dart';

class TarefasProvider with ChangeNotifier {
  List<Tarefa> _tarefas = [
    Tarefa(id: 1, titulo: 'Fazer Lista de Tarefas para Programação para Dispositivos Móveis', concluida: true),
    Tarefa(id: 2, titulo: 'Fazer Árvore Rubro Negra para Estrutura de Dados', concluida: false),
  ];

  List<Tarefa> get tarefas => _tarefas;

  set tarefas(List<Tarefa> value) {
    _tarefas = value;
    notifyListeners();
  }
}
