import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/cadastro_viewmodel.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CadastroViewModel(),
      child: Consumer<CadastroViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cadastro de Usuário'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Nome completo
                    TextFormField(
                      controller: vm.nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: vm.validarNome,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o nome completo';
                        }
                        if (value.trim().split(' ').length < 2) {
                          return 'Digite nome e sobrenome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // CPF
                    TextFormField(
                      controller: vm.cpfController,
                      decoration: const InputDecoration(
                        labelText: 'CPF (000.000.000-00)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: vm.validarCpf,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o CPF';
                        }
                        if (value.trim().length != 14) {
                          return 'CPF inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Data de nascimento
                    TextFormField(
                      controller: vm.dataNascimentoController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Data de nascimento',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final hoje = DateTime.now();
                        final selecionada = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000, 1, 1),
                          firstDate: DateTime(1900),
                          lastDate: hoje,
                        );
                        if (selecionada != null) {
                          final dataFormatada =
                              '${selecionada.day.toString().padLeft(2, '0')}/'
                              '${selecionada.month.toString().padLeft(2, '0')}/'
                              '${selecionada.year}';
                          vm.dataNascimentoController.text = dataFormatada;
                          vm.validarDataNascimento(dataFormatada);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a data de nascimento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // E-mail
                    TextFormField(
                      controller: vm.emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: vm.validarEmail,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o e-mail';
                        }
                        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!regex.hasMatch(value.trim())) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Senha
                    TextFormField(
                      controller: vm.senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            vm.senhaVisivel
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: vm.alternarVisibilidadeSenha,
                        ),
                      ),
                      obscureText: !vm.senhaVisivel,
                      onChanged: vm.validarSenha,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }
                        if (!vm.regraMaiuscula ||
                            !vm.regraMinuscula ||
                            !vm.regraNumero ||
                            !vm.regraEspecial) {
                          return 'A senha não atende todos os requisitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Confirmar senha
                    TextFormField(
                      controller: vm.confirmarSenhaController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar senha',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            vm.confirmarSenhaVisivel
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: vm.alternarVisibilidadeConfirmarSenha,
                        ),
                      ),
                      obscureText: !vm.confirmarSenhaVisivel,
                      onChanged: (valor) =>
                          vm.validarConfirmarSenha(vm.senhaController.text, valor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirme a senha';
                        }
                        if (value != vm.senhaController.text) {
                          return 'As senhas não conferem';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Check-list da senha
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _regraItem(
                              'Pelo menos 1 letra maiúscula', vm.regraMaiuscula),
                          _regraItem(
                              'Pelo menos 1 letra minúscula', vm.regraMinuscula),
                          _regraItem('Pelo menos 1 número', vm.regraNumero),
                          _regraItem(
                            'Pelo menos 1 caractere especial (!@#...)',
                            vm.regraEspecial,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (vm.erroCadastro != null)
                      Text(
                        vm.erroCadastro!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.podeCadastrar
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  final ok = await vm.cadastrarUsuario();

                                  if (!mounted) return;

                                  if (ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Usuário cadastrado com sucesso!'),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            : null,
                        child: vm.carregando
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Cadastrar'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Já tem conta? Fazer login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _regraItem(String texto, bool ok) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.cancel,
          color: ok ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(texto),
      ],
    );
  }
}
