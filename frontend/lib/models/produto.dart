class Produto {
  final int? id;
  final String nome;
  final String descricao;
  final double preco;
  final DateTime? dataAtualizado;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    this.dataAtualizado,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: json['preco'] is int
          ? (json['preco'] as int).toDouble()
          : json['preco'],
      dataAtualizado: json['dataAtualizado'] != null
          ? DateTime.parse(json['dataAtualizado'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
    };
  }
}
