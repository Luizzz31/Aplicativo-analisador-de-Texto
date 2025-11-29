class Usuario {
  final int? id;
  final String nomeCompleto;
  final String cpf;
  final String dataNascimento; // pode ser String "dd/MM/yyyy" para simplificar
  final String email;
  final String senhaHash; // senha já criptografada (hash)

  Usuario({
    this.id,
    required this.nomeCompleto,
    required this.cpf,
    required this.dataNascimento,
    required this.email,
    required this.senhaHash,
  });

  // Converte o objeto para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome_completo': nomeCompleto,
      'cpf': cpf,
      'data_nascimento': dataNascimento,
      'email': email,
      'senha_hash': senhaHash,
    };
  }

  // Cria um Usuario a partir de um Map (lido do banco)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nomeCompleto: map['nome_completo'] as String,
      cpf: map['cpf'] as String,
      dataNascimento: map['data_nascimento'] as String,
      email: map['email'] as String,
      senhaHash: map['senha_hash'] as String,
    );
  }
}
