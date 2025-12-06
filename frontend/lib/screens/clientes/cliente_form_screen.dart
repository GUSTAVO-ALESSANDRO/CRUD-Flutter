import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import '../../models/cliente.dart';
import '../../services/api_service.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;
  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final api = ApiService();

  late TextEditingController nomeCtrl;
  late TextEditingController sobrenomeCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController idadeCtrl;

  String? fotoBase64;
  File? imagemTemporaria;

  @override
  void initState() {
    super.initState();
    nomeCtrl = TextEditingController(text: widget.cliente?.nome ?? '');
    sobrenomeCtrl =
        TextEditingController(text: widget.cliente?.sobrenome ?? '');
    emailCtrl = TextEditingController(text: widget.cliente?.email ?? '');
    idadeCtrl =
        TextEditingController(text: widget.cliente?.idade.toString() ?? '');
    fotoBase64 = widget.cliente?.foto;
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    sobrenomeCtrl.dispose();
    emailCtrl.dispose();
    idadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Força a criação de uma nova instância do picker toda vez
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked != null) {
        final bytes = await File(picked.path).readAsBytes();
        setState(() {
          imagemTemporaria = File(picked.path);
          fotoBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        });
      }
    } catch (e) {
      // Se der "already_active", ignora e tenta de novo (raro, mas seguro)
      if (e.toString().contains('already_active')) {
        // Tenta de novo após um pequeno delay
        await Future.delayed(const Duration(milliseconds: 300));
        _pickImage();
      }
    }
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final cliente = Cliente(
        id: widget.cliente?.id,
        nome: nomeCtrl.text.trim(),
        sobrenome: sobrenomeCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        idade: int.tryParse(idadeCtrl.text) ?? 0,
        foto: fotoBase64,
      );

      try {
        if (widget.cliente == null) {
          await api.createCliente(cliente);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente criado com sucesso!')),
          );
        } else {
          await api.updateCliente(widget.cliente!.id!, cliente);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente atualizado!')),
          );
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              // === AVATAR COM FOTO ===
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: fotoBase64 != null
                      ? MemoryImage(base64Decode(fotoBase64!.split(',').last))
                      : const AssetImage('assets/images/placeholder.jpg')
                          as ImageProvider,
                  child: Stack(
                    children: [
                      if (fotoBase64 == null && widget.cliente?.foto == null)
                        const Icon(Icons.person, size: 80, color: Colors.grey),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 28),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // === CAMPOS DO FORMULÁRIO ===
              TextFormField(
                controller: nomeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Digite o nome' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: sobrenomeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Sobrenome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    v!.trim().isEmpty ? 'Digite o sobrenome' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) => v!.contains('@') ? null : 'E-mail inválido',
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: idadeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                validator: (v) {
                  if (v!.isEmpty) return 'Digite a idade';
                  if (int.tryParse(v) == null) return 'Idade inválida';
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // === BOTÃO SALVAR ===
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('SALVAR',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
