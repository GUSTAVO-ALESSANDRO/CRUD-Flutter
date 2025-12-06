import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../services/api_service.dart';
import '../../models/cliente.dart';
import 'cliente_form_screen.dart';

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});
  @override
  State<ClienteListScreen> createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  final ApiService api = ApiService();
  late Future<List<Cliente>> futureClientes;

  @override
  void initState() {
    super.initState();
    futureClientes = api.getClientes();
  }

  void _refresh() async {
    setState(() {
      futureClientes = api.getClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: FutureBuilder<List<Cliente>>(
        future: futureClientes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final clientes = snapshot.data!;
            if (clientes.isEmpty) {
              return const Center(
                  child: Text("Nenhum cliente cadastrado",
                      style: TextStyle(fontSize: 18, color: Colors.grey)));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: clientes.length,
              itemBuilder: (_, i) {
                final c = clientes[i];
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: c.foto != null && c.foto!.isNotEmpty
                          ? NetworkImage(c.foto!) as ImageProvider
                          : const AssetImage("assets/images/placeholder.jpg"),
                    ),
                    title: Text("${c.nome} ${c.sobrenome}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(c.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await api.deleteCliente(c.id!);
                        _refresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Cliente removido")),
                        );
                      },
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ClienteFormScreen(cliente: c)),
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
            child: SpinKitFadingCircle(color: Colors.deepPurple, size: 60),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label:
            const Text("Novo Cliente", style: TextStyle(color: Colors.white)),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ClienteFormScreen()));
          _refresh();
        },
      ),
    );
  }
}
