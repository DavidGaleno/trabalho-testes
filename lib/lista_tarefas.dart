import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarefas/tarefaProvider.dart';
import 'package:tarefas/tarefa_form.dart';
import 'package:tarefas/tarefa_item.dart';

import 'models/tarefa.dart';

class ListaTarefas extends StatelessWidget {
  ListaTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<TarefasProvider>(
        builder: (_, provider, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TarefaForm(),
            provider.tarefas.length == 0
                ? Center(
                    child: Text('Não há tarefas cadastradas',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                  )
                : Expanded(
                    child: ListView.builder(
                        key: UniqueKey(),
                        itemCount: provider.tarefas.length,
                        itemBuilder: (context, index) {
                          Tarefa tarefa = provider.tarefas[index];
                          return TarefaItem(tarefa: tarefa, provider: provider);
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
