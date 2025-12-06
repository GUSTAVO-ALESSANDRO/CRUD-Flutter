import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../services/api_service.dart';
import '../../models/produto.dart';
import 'produto_form_screen.dart';

class ProdutoListScreen extends StatefulWidget {
  const ProdutoListScreen({super.key});
  @override
  State<ProdutoListScreen> createState() => _ProdutoListScreenState();
}

class _ProdutoListScreenState extends State<ProdutoListScreen> {
  final ApiService api = ApiService();
  late Future<List<Produto>> futureProdutos;

  @override
  void initState() {
    super.initState();
    futureProdutos = api.getProdutos();
  }

  void _refresh() async {
    setState(() {
      futureProdutos = api.getProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Produto>>(
        future: futureProdutos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final produtos = snapshot.data!;
            if (produtos.isEmpty) {
              return const Center(
                  child: Text("Nenhum produto cadastrado",
                      style: TextStyle(fontSize: 18, color: Colors.grey)));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: produtos.length,
              itemBuilder: (_, i) {
                final p = produtos[i];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.inventory_2,
                          color: Colors.white, size: 30),
                    ),
                    title: Text(p.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.descricao,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text("R\$ ${p.preco.toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await api.deleteProduto(p.id!);
                        _refresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Produto removido")));
                      },
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProdutoFormScreen(produto: p)),
                      );
                      _refresh();
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }
          return const Center(
              child: SpinKitFadingCircle(color: Colors.deepPurple, size: 60));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
        label:
            const Text("Novo Produto", style: TextStyle(color: Colors.white)),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProdutoFormScreen()));
          _refresh();
        },
      ),
    );
  }
}
