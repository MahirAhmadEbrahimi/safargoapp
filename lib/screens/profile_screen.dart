import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLogin = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (user != null) {
            return _loggedInView(user);
          }
          return _authForm();
        },
      ),
    );
  }

  Widget _loggedInView(User user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(Icons.person, size: 30, color: Color(0xFF2563EB)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Logged In User',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(user.email ?? 'No email found',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _profileTile(Icons.history, 'Trip History'),
        _profileTile(Icons.payment_outlined, 'Payment Methods'),
        _profileTile(Icons.settings_outlined, 'Settings'),
        _profileTile(
          Icons.logout,
          'Logout',
          onTap: _loading ? null : _logout,
        ),
      ],
    );
  }

  Widget _authForm() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isLogin ? 'Login with Email' : 'Sign Up with Email',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  helperText: 'Password must be at least 6 characters',
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submitAuth,
                  child: Text(_loading
                      ? 'Please wait...'
                      : (_isLogin ? 'Login' : 'Sign Up')),
                ),
              ),
              TextButton(
                onPressed: _loading
                    ? null
                    : () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin
                    ? "Don't have an account? Sign Up"
                    : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      _showMessage('Please enter a valid email address');
      return;
    }
    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }

    setState(() => _loading = true);
    try {
      if (_isLogin) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      _emailController.clear();
      _passwordController.clear();
      _showMessage(_isLogin ? 'Login successful' : 'Signup successful');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Authentication failed');
    } catch (_) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    setState(() => _loading = true);
    try {
      await _auth.signOut();
      _showMessage('Logged out successfully');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Logout failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _profileTile(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF2563EB)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
