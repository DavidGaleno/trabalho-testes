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
    test(
        'Espera que o objeto tarefa retorne valores de seus atributos ao serem chamados',
        () {
      final tarefa = Tarefa(id: 1, titulo: 'Teste', concluida: false);

      expect(tarefa.id, 1);
      expect(tarefa.titulo, 'Teste');
      expect(tarefa.concluida, false);
    });

    test(
        'Espera que dois objetos de Tarefa com os mesmos valores sejam iguais quando comparados',
        () {
      final tarefa1 = Tarefa(id: 1, titulo: 'Teste', concluida: false);
      final tarefa2 = Tarefa(id: 1, titulo: 'Teste', concluida: false);

      expect(tarefa1.id, tarefa2.id);
      expect(tarefa1.titulo, tarefa2.titulo);
      expect(tarefa1.concluida, tarefa2.concluida);
    });

    test(
        'Espera que o atributo concluida do objeto tarefa mude de valor ao sofrer uma atribuição',
        () {
      final tarefa = Tarefa(id: 3, titulo: 'Teste', concluida: false);

      tarefa.concluida = true;

      expect(tarefa.concluida, equals(true));
    });
  });

  group('TarefasProvider', () {
    test('Espera que adicionar tarefas aumente a quantidade de tarefas', () {
      //Mock que retorna uma lista de tarefas vazia
      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      //Largura inicial de 0 tarefas
      int larguraAntiga = provider.tarefas.length;

      //Cria e adiciona uma nova tarefa
      Tarefa tarefa = Tarefa(id: 1, titulo: 'Nova Tarefa', concluida: false);
      provider.tarefas.add(tarefa);

      //Espera que a largura antiga seja menor a nova, ou seja , antes era de 0 e agora é de 1
      expect(larguraAntiga, lessThan(provider.tarefas.length));
    });

    test('Espera que remover tarefas diminuia a quantidade de tarefas', () {
      //Mock que retorna uma lista com uma tarefa
      final provider = MockTarefasProvider();
      when(provider.tarefas)
          .thenReturn([Tarefa(id: 1, titulo: 'teste', concluida: false)]);

      //Largura inicial de 0 tarefas
      int larguraAntiga = provider.tarefas.length;

      //Pega a tarefa no provider
      Tarefa tarefa = provider.tarefas[0];

      //Remove a tarefa que está no provider
      provider.tarefas.remove(tarefa);

      //Espera que a largura antiga seja maior que a atual
      expect(larguraAntiga, greaterThan(provider.tarefas.length));

    });
    test('Espera que concluir tarefas mude o valor do atributo concluida', () {

      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([Tarefa(id: 1, titulo: 'Nova Tarefa', concluida: false)]);

      //Pega a tarefa armazenada
      Tarefa tarefa = provider.tarefas[0];

      //Armazena o valor atual do atributo concluida
      bool valorAntigo = tarefa.concluida;

      //Muda o valor do atributo concluída da tarefa
      tarefa.concluida = !tarefa.concluida;

      //Analisa se o valor antigo (false) é diferente do novo (true)
      expect(valorAntigo, isNot(tarefa.concluida));
    });
  });

  //Testes de Widget

  group('ListaTarefas', () {
    testWidgets(
        'Espera que a lista seja renderizada quando a view for carregada',
        (WidgetTester tester) async {
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

    testWidgets(
        'Espera que o número de tarefas no provider aumente quando adicionar uma tarefa',
        (WidgetTester tester) async {
      final listaTarefas = ListaTarefas();

      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      //Armazena a largura antiga da lista
      int larguraAntiga = provider.tarefas.length;

      //Adiciona uma tarefa no provider
      listaTarefas.adicionarItem(provider: provider, text: 'teste');

      //Atualiza o componente

      expect(larguraAntiga, lessThan(provider.tarefas.length));
    });

    testWidgets(
        'Espera que não seja adicionada nenhuma tarefa quando o parâmetro text for vazio',
        (WidgetTester tester) async {
      final listaTarefas = ListaTarefas();

      final provider = MockTarefasProvider();
      when(provider.tarefas).thenReturn([]);

      int larguraAntiga = provider.tarefas.length;

      listaTarefas.adicionarItem(provider: provider, text: '');

      expect(larguraAntiga, provider.tarefas.length);
    });
  });

  group('TarefaItem', () {
    testWidgets('Espera uma tarefa renderizada quando a view for carregada',
        (WidgetTester tester) async {
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

    testWidgets(
        'Espera que o número de tarefas no provider diminua quando remover uma tarefa,',
        (WidgetTester tester) async {

      //Mock que retorna 1 tarefa
      final provider = MockTarefasProvider();
      when(provider.tarefas)
          .thenReturn([Tarefa(id: 1, titulo: 'teste', concluida: false)]);

      Tarefa tarefa = provider.tarefas[0];

      //Armazena a quantidade de tarefas antiga no provider
      int larguraAntiga = provider.tarefas.length;

      //Cria uma tarefaItem com a tarefa antiga
      final tarefaItem = TarefaItem(tarefa: tarefa, provider: provider);

      //Aciona método para remover tarefa
      tarefaItem.removerTarefa();

      //Checa se a larguraAntiga, com 1 item, é maior que a nova, com 0 itens
      expect(larguraAntiga, greaterThan(provider.tarefas.length));
    });

    testWidgets(
        'Espera que a tarefa seja concluida quando o método concluirTarefa() for chamado, ',
        (WidgetTester tester) async {
      //Mock que retorna 1 tarefa
      final provider = MockTarefasProvider();
      when(provider.tarefas)
          .thenReturn([Tarefa(id: 1, titulo: 'teste', concluida: false)]);

      Tarefa tarefa = provider.tarefas[0];

      //Cria uma TarefaItem com a tarefa
      TarefaItem tarefaItem = TarefaItem(tarefa: tarefa, provider: provider);

      //Armazena o valor atual da Tarefa
      bool tarefaConcluidaValorAntigo = tarefa.concluida;

      //Aciona o método de concluir a tarefa
      tarefaItem.concluirTarefa();

      //Avalia se o valor do atributo concluida antigo é diferente do novo, ou seja, se a tarefa foi de não concluída para concluída
      expect(tarefaConcluidaValorAntigo, isNot(tarefaItem.tarefa.concluida));
    });
  });

  //Testes de Integração
  group('ListaTarefas', () {
    testWidgets(
        "Espera criar uma tarefa quando preencher o formulário e apertar o botão adicionar",
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

      //Renderiza o widget
      await tester.pumpWidget(app);

      //Adiciona texto ao input
      await tester.enterText(find.byType(TextFormField), 'Nova Tarefa');

      //Aperta botão
      await tester.tap(find.text('Adicionar'));

      //Garente que informações foram atualizadas
      await tester.pumpAndSettle();

      //Como já estão no provider como padrão duas tarefas, espera-se que mais uma esteja
      expect(find.byType(TarefaItem), findsNWidgets(3));
    });
  });

  group('TarefaItem', () {
    testWidgets(
        "Espera remover uma tarefa quando pressionar o botão de remover tarefa",
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

      //Pega o último widget do tipo tarefa
      Widget tarefaItem = tester.widgetList(find.byType(TarefaItem)).last;

      // Pega o icone do tipo highlight_remove_outlined no widget tarefaItem, responsável por remover a tarefaItem
      Finder iconButtonFinder = find.descendant(
        of: find.byWidget(tarefaItem),
        matching: find.byIcon(Icons.highlight_remove_outlined),
      );

      //Pressiona o botão de remover
      await tester.tap(iconButtonFinder);

      //Garante que as alterações foram renderizadas
      await tester.pumpAndSettle();

      //Como já estão por padrão duas tarefas no provider, espera-se encontrar agora somente uma
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

      //Pega a última tarefaItem renderizada
      TarefaItem tarefaItem =
          tester.widgetList(find.byType(TarefaItem)).last as TarefaItem;

      //Pega o valor do atributo concluida inicialmente
      bool tarefaDesatualizadaConcluida = tarefaItem.tarefa.concluida;

      //Pega todos os Icon buttons dentro da tarefa desejada
      Finder iconButtonFinder = find.descendant(
        of: find.byWidget(tarefaItem),
        matching: find.byType(IconButton),
      );

      //Pega o último  botão do TarefaItem, que é o de concluir
      Widget iconButton = tester.widgetList(iconButtonFinder).last;

      //Pressiona o botão de concluir
      await tester.tap(find.byWidget(iconButton));

      //Garante que as informações foram renderizadas
      await tester.pumpAndSettle();

      //O valor antigo da tarefaItem não é igual ao novo valor, ou seja, foi de não concluída para concluída
      expect(tarefaDesatualizadaConcluida, isNot(tarefaItem.tarefa.concluida));
    });
  });
}
