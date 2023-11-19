import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarefas/tarefaProvider.dart';

import 'models/tarefa.dart';

class TarefaItem extends StatelessWidget {
  final Tarefa tarefa;
  final TarefasProvider provider;

  const TarefaItem({required this.tarefa, required this.provider, Key? key})
      : super(key: key);

  void removerTarefa() {
    provider.tarefas.remove(tarefa);
    provider.notifyListeners();
  }

  void concluirTarefa() {
    tarefa.concluida = !tarefa.concluida;
    int index = provider.tarefas.indexOf(tarefa);
    provider.tarefas[index] = tarefa;
    provider.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${tarefa.titulo}'),
        Text('${tarefa.concluida ? 'concluída' : 'incompleta'}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                removerTarefa();
              },
              icon: Icon(Icons.highlight_remove_outlined),
            ),
            IconButton(
                onPressed: () {
                  concluirTarefa();
                },
                icon: Icon(tarefa.concluida
                    ? Icons.circle_rounded
                    : Icons.circle_outlined))
          ],
        )
      ],
    );
  }
}
