import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';
import '../models/produto.dart';

class ApiService {

  static const String baseUrl = 'http://10.0.2.2:8080';

  // ================== CLIENTES ==================
  Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Cliente.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar clientes');
    }
  }

  Future<Cliente> createCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar cliente');
    }
  }

  Future<Cliente> updateCliente(int id, Cliente cliente) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clientes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );
    if (response.statusCode == 200) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar cliente');
    }
  }

  Future<void> deleteCliente(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/clientes/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao deletar cliente');
    }
  }

  // ================== PRODUTOS ==================
  Future<List<Produto>> getProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/produtos'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Produto.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

  Future<Produto> createProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar produto');
    }
  }

  Future<Produto> updateProduto(int id, Produto produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produtos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toJson()),
    );
    if (response.statusCode == 200) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar produto');
    }
  }

  Future<void> deleteProduto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/produtos/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao deletar produto');
    }
  }
}
