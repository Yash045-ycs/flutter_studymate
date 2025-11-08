import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dashboard/views/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/images/study_mate_bg_clean.png", fit: BoxFit.cover),
            Container(color: Colors.white.withOpacity(0.1)),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFC95C27),
                            child: Icon(Icons.menu_book_rounded,
                                color: Colors.white, size: 24),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Study Mate",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5B3F30),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: const Color(0xFFC95C27),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.brown,
                          tabs: const [
                            Tab(text: "Login"),
                            Tab(text: "Sign Up"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // LOGIN TAB
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextField(
                                      controller: _emailController,
                                      decoration:
                                          const InputDecoration(labelText: 'Email'),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          labelText: 'Password'),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text("Forgot Password?"),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              context.read<AuthBloc>().add(LoginRequested(
                                                  _emailController.text.trim(),
                                                  _passwordController.text.trim()));
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFC95C27),
                                        foregroundColor: Colors.white,
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white)
                                          : const Text("Login"),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Don’t have an account? "),
                                        GestureDetector(
                                          onTap: () {
                                            _tabController.animateTo(1);
                                          },
                                          child: const Text(
                                            "Sign Up",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            // SIGNUP TAB
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextField(
                                      controller: _emailController,
                                      decoration:
                                          const InputDecoration(labelText: 'Email'),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          labelText: 'Password'),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _confirmController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          labelText: 'Confirm Password'),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              if (_passwordController.text !=
                                                  _confirmController.text) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Passwords don’t match")),
                                                );
                                                return;
                                              }
                                              context.read<AuthBloc>().add(SignupRequested(
                                                  _emailController.text.trim(),
                                                  _passwordController.text.trim()));
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFC95C27),
                                        foregroundColor: Colors.white,
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white)
                                          : const Text("Sign Up"),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Already have an account? "),
                                        GestureDetector(
                                          onTap: () {
                                            _tabController.animateTo(0);
                                          },
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("or"),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 5),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text("Continue with Google"),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
