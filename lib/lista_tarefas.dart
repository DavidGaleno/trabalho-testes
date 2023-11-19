import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarefas/tarefaProvider.dart';
import 'package:tarefas/tarefa_item.dart';

import 'models/tarefa.dart';

class ListaTarefas extends StatelessWidget {
  ListaTarefas({super.key});

  TextEditingController tarefaController = TextEditingController();

  adicionarItem({required provider, required text}) {
    if (text == '' || text == ' ') return;
    Tarefa tarefa =
        Tarefa(id: provider.tarefas.length + 1, titulo: text, concluida: false);
    provider.tarefas.add(tarefa);
    provider.notifyListeners();
    tarefaController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<TarefasProvider>(
        builder: (_, provider, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: tarefaController,
                    keyboardType: TextInputType.text,
                    decoration:
                        InputDecoration(label: Text('Insira o nome da tarefa')),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      adicionarItem(
                          provider: provider, text: tarefaController.text);
                    },
                    child: Text('Adicionar'))
              ],
            )),
            Expanded(
              child: ListView.builder(
                  key: UniqueKey(),
                  itemCount: provider.tarefas.length,
                  itemBuilder: (context, index) {
                    Tarefa tarefa = provider.tarefas[index];
                    return ListTile(
                      title: TarefaItem(
                          tarefa: tarefa,
                          provider: provider),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
