import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tarefas/lista_tarefas.dart';
import 'package:tarefas/models/tarefa.dart';
import 'package:tarefas/tarefaProvider.dart';
import 'package:tarefas/tarefa_item.dart';

import 'lista_tarefas_test.mocks.dart';

@GenerateMocks([TarefasProvider])
void main() {
  //Testes Unitários

  group('Tarefa', () {
    test('Construtor funciona corretamente', () {
      final tarefa = Tarefa(id: 1, titulo: 'Teste', concluida: false);

      expect(tarefa.id, 1);
      expect(tarefa.titulo, 'Teste');
      expect(tarefa.concluida, false);
    });

    test('Dois objetos de Tarefa com os mesmos valores são iguais', () {
      final tarefa1 = Tarefa(id: 1, titulo: 'Teste', concluida: false);
      final tarefa2 = Tarefa(id: 1, titulo: 'Teste', concluida: false);

      expect(tarefa1.id, tarefa2.id);
      expect(tarefa1.titulo, tarefa2.titulo);
      expect(tarefa1.concluida, tarefa2.concluida);
    });

    test('Mudança de estado concluída', () {
      final tarefa = Tarefa(id: 3, titulo: 'Teste', concluida: false);

      tarefa.concluida = true;

      expect(tarefa.concluida, equals(true));
    });
  });

  group('TarefasProvider', () {
    test('Adicionar tarefas aumenta quantidade de tarefas', () {
      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      int larguraAntiga = provider.tarefas.length;
      Tarefa tarefa = Tarefa(id: 3, titulo: 'Nova Tarefa', concluida: false);
      provider.tarefas.add(tarefa);

      expect(larguraAntiga, lessThan(provider.tarefas.length));
    });
    test('Remover tarefas diminui quantidade de tarefas', () {
      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      int larguraAntiga = provider.tarefas.length;
      Tarefa tarefa = Tarefa(id: 3, titulo: 'Nova Tarefa', concluida: false);
      provider.tarefas.add(tarefa);
      provider.tarefas.remove(tarefa);

      expect(larguraAntiga, equals(provider.tarefas.length));
    });
    test('Concluir tarefas muda o valor do atributo concluida', () {
      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      Tarefa tarefa = Tarefa(id: 3, titulo: 'Nova Tarefa', concluida: false);
      bool valorAntigo = tarefa.concluida;
      provider.tarefas.add(tarefa);
      provider.tarefas[0].concluida = !provider.tarefas[0].concluida;

      expect(valorAntigo, isNot(provider.tarefas[0].concluida));
    });
  });

  //Testes de Widget

  group('ListaTarefas', () {
    //Testa se a lista foi renderizada
    testWidgets('Espera uma lista renderizada', (WidgetTester tester) async {
      final provider = MockTarefasProvider();
      when(provider.tarefas)
          .thenReturn([Tarefa(id: 1, titulo: 'teste', concluida: false)]);
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<TarefasProvider>(
                create: (context) => provider)
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: ListaTarefas(),
          )));
      expect(find.byType(ListaTarefas), findsOneWidget);
    });
    //Testa a função de adicionar uma tarefa
    testWidgets(
        'Espera que, ao adicionar uma tarefa, o número de tarefas no provider aumente',
        (WidgetTester tester) async {
      final listaTarefas = ListaTarefas(); // Instantiate the widget

      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      int larguraAntiga = provider.tarefas.length;

      listaTarefas.adicionarItem(provider: provider, text: 'teste');

      await tester.pump();

      expect(larguraAntiga, lessThan(provider.tarefas.length));
    });
    testWidgets(
        'Espera que, ao não inserir nenhum valor no campo de input do formulário, não seja adicionada nenhuma tarefa',
        (WidgetTester tester) async {
      final listaTarefas = ListaTarefas();

      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      int larguraAntiga = provider.tarefas.length;

      listaTarefas.adicionarItem(provider: provider, text: '');

      await tester.pump();

      expect(larguraAntiga, provider.tarefas.length);
    });
  });

  group('TarefaItem', () {
    //Espera uma tarefa renderizada
    testWidgets('Espera uma tarefa renderizada', (WidgetTester tester) async {
      final provider = MockTarefasProvider();
      when(provider.tarefas)
          .thenReturn([Tarefa(id: 1, titulo: 'teste', concluida: false)]);
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<TarefasProvider>(
                create: (context) => provider)
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: ListaTarefas(),
          )));
      expect(find.byType(TarefaItem), findsOneWidget);
    });
    //Testa a função de remover uma tarefa
    testWidgets(
        'Espera que, ao remover uma tarefa, o número de tarefas no provider diminua',
        (WidgetTester tester) async {
      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      final listaTarefas = ListaTarefas();

      listaTarefas.adicionarItem(provider: provider, text: 'teste');
      Tarefa tarefaAdicionada = provider.tarefas[0];

      int larguraAntiga = provider.tarefas.length;

      final tarefa = TarefaItem(tarefa: tarefaAdicionada, provider: provider);
      tarefa.removerTarefa();

      expect(larguraAntiga, greaterThan(provider.tarefas.length));
    });
    //Testa a função de concluir uma tarefa
    testWidgets('Espera que, ao concluir uma tarefa, a tarefa seja concluida',
        (WidgetTester tester) async {
      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      final listaTarefas = ListaTarefas();

      listaTarefas.adicionarItem(provider: provider, text: 'teste');
      Tarefa tarefaAdicionada = provider.tarefas[0];
      TarefaItem tarefaItem =
          TarefaItem(tarefa: tarefaAdicionada, provider: provider);
      int index = provider.tarefas.indexOf(tarefaAdicionada);
      tarefaItem.concluirTarefa();
      expect(provider.tarefas[index].concluida,
          equals(tarefaItem.tarefa.concluida));
    });
  });

  //Testes de Integração

  group('ListaTarefas', () {
    testWidgets(
        "Espera criar uma tarefa ao preencher o formulário e apertar o botão adicionar",
        (WidgetTester tester) async {
      Widget app = MultiProvider(
          providers: [
            ChangeNotifierProvider<TarefasProvider>(
                create: (context) => TarefasProvider())
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: ListaTarefas(),
          ));
      await tester.pumpWidget(app);
      await tester.enterText(find.byType(TextFormField), 'Nova Tarefa');
      await tester.tap(find.text('Adicionar'));
      await tester.pumpAndSettle();
      expect(find.byType(TarefaItem), findsNWidgets(3));
    });
  });
  group('TarefaItem', () {
    testWidgets(
        "Espera remover uma tarefa ao pressionar o botão de remover tarefa",
        (WidgetTester tester) async {
      Widget app = MultiProvider(
          providers: [
            ChangeNotifierProvider<TarefasProvider>(
                create: (context) => TarefasProvider())
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: ListaTarefas(),
          ));
      await tester.pumpWidget(app);

      Widget tarefaItem = tester.widgetList(find.byType(TarefaItem)).last;

      Finder iconButtonFinder = find.descendant(
        of: find.byWidget(tarefaItem),
        matching: find.byIcon(Icons.highlight_remove_outlined),
      );

      await tester.tap(iconButtonFinder);
      await tester.pumpAndSettle();
      expect(find.byType(TarefaItem), findsNWidgets(1));
    });
    testWidgets(
        "Espera alterar o valor de concluido de uma tarefa ao pressionar o botão de concluir",
            (WidgetTester tester) async {
          Widget app = MultiProvider(
              providers: [
                ChangeNotifierProvider<TarefasProvider>(
                    create: (context) => TarefasProvider())
              ],
              child: MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: ListaTarefas(),
              ));
          await tester.pumpWidget(app);

          TarefaItem tarefaItem =
          tester.widgetList(find.byType(TarefaItem)).last as TarefaItem;

          bool tarefaDesatualizadaConcluida = tarefaItem.tarefa.concluida;

          Finder iconButtonFinder = find.descendant(
            of: find.byWidget(tarefaItem),
            matching: find.byType(IconButton),
          );
          Widget iconButton = tester.widgetList(iconButtonFinder).last;

          await tester.tap(find.byWidget(iconButton));
          await tester.pumpAndSettle();

          tarefaItem = tester.widgetList(find.byType(TarefaItem)).last as TarefaItem;

          Tarefa tarefaAtualizada = tarefaItem.tarefa;

          expect(tarefaDesatualizadaConcluida, isNot(tarefaAtualizada.concluida));
        });
  });

}
