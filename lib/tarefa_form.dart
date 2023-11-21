import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarefas/tarefaProvider.dart';

import 'models/tarefa.dart';

class TarefaForm extends StatelessWidget {
  TarefaForm({super.key});

  TextEditingController tarefaController = TextEditingController();

  adicionarItem({required provider, required text}) {
    if (text == '' || text == ' ') return;
    if(text.length > 80) return;
    Tarefa tarefa =
        Tarefa(id: provider.tarefas.length + 1, titulo: text, concluida: false);
    provider.tarefas.add(tarefa);
    provider.notifyListeners();
    tarefaController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TarefasProvider>(
        builder: ((_, provider, child) => Form(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: TextFormField(
                    maxLength: 80,
                    controller: tarefaController,
                    keyboardType: TextInputType.text,
                    decoration:
                        InputDecoration(label: Text('Insira o nome da tarefa')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: TextButton(
                      onPressed: () {
                        adicionarItem(
                            provider: provider, text: tarefaController.text);
                      },
                      child: Text('Adicionar',style: TextStyle(fontSize: 18),)),
                )
              ],
            ))));
  }
}
