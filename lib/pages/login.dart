import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword =
      true; // Novo estado para controlar a visibilidade da senha

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/redirect');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message ?? 'Erro ao fazer login';
      });
    } finally {
      // Apenas atualize o estado se o widget ainda estiver montado,
      // mas sem usar return aqui
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(82, 0, 0, 0),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Image.asset(
                  'assets/images/logo/lolaEtheo_baner.png',
                  height: 75, // ajuste a altura conforme necessário
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                const Text(
                  'WEB PCP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Campo Email
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'E-mail',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 85, 57, 112),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Borda quando selecionado
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 85, 57, 112), // Sua cor roxa
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo Senha com botão de visibilidade
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Senha',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 85, 57, 112),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Borda quando selecionado
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 85, 57, 112), // Sua cor roxa
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color.fromARGB(255, 85, 57, 112),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Link Esqueceu senha
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Perdeu sua senha?',
                      style: TextStyle(color: Color.fromARGB(255, 85, 57, 112)),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Não tem uma conta?',
                      style: TextStyle(color: Color.fromARGB(255, 85, 57, 112)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão Entrar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 85, 57, 112),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                // Mensagem de erro
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],

                // Rodapé
                const SizedBox(height: 32),
                const Text(
                  'Todos os direitos reservados @Lola e Theo Softwares 2021',
                  style: TextStyle(
                    color: Color.fromARGB(255, 69, 43, 94),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
