import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import '../auth/login.dart';


class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Registration Success")));

            // 🔥 بعد التسجيل ونجاحه → يروح للوج ان
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },

        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Create Account",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(labelText: "Confirm Password"),
                  obscureText: true,
                ),
                SizedBox(height: 20),

                state is AuthLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  child: Text("Register"),
                  onPressed: () {
                    if (passwordController.text.trim() !=
                        confirmPasswordController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Passwords don't match")));
                      return;
                    }

                    context
                        .read<AuthCubit>()
                        .register(emailController.text,
                        passwordController.text);
                  },
                ),

                SizedBox(height: 15),

                // 🔥 زر للعودة للّوج ان
                TextButton(
                  child: Text("Already have an account? Login"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeName);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
