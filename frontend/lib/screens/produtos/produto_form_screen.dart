import 'package:flutter/material.dart';
import '../../models/produto.dart';
import '../../services/api_service.dart';

class ProdutoFormScreen extends StatefulWidget {
  final Produto? produto;
  const ProdutoFormScreen({super.key, this.produto});

  @override
  State<ProdutoFormScreen> createState() => _ProdutoFormScreenState();
}

class _ProdutoFormScreenState extends State<ProdutoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final api = ApiService();

  late TextEditingController nomeCtrl;
  late TextEditingController descricaoCtrl;
  late TextEditingController precoCtrl;

  @override
  void initState() {
    super.initState();
    nomeCtrl = TextEditingController(text: widget.produto?.nome ?? '');
    descricaoCtrl =
        TextEditingController(text: widget.produto?.descricao ?? '');
    precoCtrl =
        TextEditingController(text: widget.produto?.preco.toString() ?? '');
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final produto = Produto(
        id: widget.produto?.id,
        nome: nomeCtrl.text,
        descricao: descricaoCtrl.text,
        preco: double.tryParse(precoCtrl.text.replaceAll(',', '.')) ?? 0.0,
      );

      try {
        if (widget.produto == null) {
          await api.createProduto(produto);
        } else {
          await api.updateProduto(widget.produto!.id!, produto);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto == null ? 'Novo Produto' : 'Editar Produto'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descricaoCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: precoCtrl,
                decoration:
                    const InputDecoration(labelText: 'Preço (ex: 99.90)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v!.isEmpty) return 'Campo obrigatório';
                  if (double.tryParse(v.replaceAll(',', '.')) == null) {
                    return 'Digite um preço válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: _salvar,
                  child: const Text('Salvar',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
