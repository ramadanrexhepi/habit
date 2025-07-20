import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_background/animated_background.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  String _email = '';
  String _password = '';
  String _fullName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌟 Animated Particle Background
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                baseColor: Colors.teal.shade300,
                spawnMinSpeed: 10.0,
                spawnMaxSpeed: 30.0,
                spawnMinRadius: 1.0,
                spawnMaxRadius: 3.0,
                particleCount: 60,
              ),
            ),
            vsync: this,
            child: const SizedBox.expand(),
          ),

          // 💳 Auth Card
          Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isLogin ? 'Welcome Back!' : 'Create Account',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      if (!_isLogin)
                        TextFormField(
                          key: const ValueKey('name'),
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          onSaved: (value) => _fullName = value!.trim(),
                          validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                        ),

                      const SizedBox(height: 12),
                      TextFormField(
                        key: const ValueKey('email'),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => _email = value!.trim(),
                        validator: (value) => value!.isEmpty || !value.contains('@')
                            ? 'Enter a valid email'
                            : null,
                      ),

                      const SizedBox(height: 12),
                      TextFormField(
                        key: const ValueKey('password'),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        onSaved: (value) => _password = value!.trim(),
                        validator: (value) => value!.length < 6 ? 'Password too short' : null,
                      ),

                      const SizedBox(height: 24),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                backgroundColor: Colors.teal,
                              ),
                              onPressed: _submitAuthForm,
                              child: Text(_isLogin ? 'Login' : 'Sign Up'),
                            ),
                            const SizedBox(height: 16),

                            // ✅ Google Sign-In Button
                            OutlinedButton.icon(
                              onPressed: _signInWithGoogle,
                              icon: Image.asset(
                                '../assets/google.png',
                                height: 24,
                                width: 24,
                              ),
                              label: const Text(
                                'Continue with Google',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => setState(() => _isLogin = !_isLogin),
                        child: Text(_isLogin
                            ? 'Create a new account'
                            : 'I already have an account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )

        ],
      ),
    );
  }

  Future<void> _submitAuthForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        await userCredential.user!.updateDisplayName(_fullName);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Auth failed')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Add this below
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // user canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Google Sign-In failed')),
      );
    }
  }

}