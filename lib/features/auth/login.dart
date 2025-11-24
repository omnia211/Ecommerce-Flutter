import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import '../../home.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Login Success")));
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
          else if (state is AuthFailure) {
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
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(height: 20),

                state is AuthLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  child: Text("Login"),
                  onPressed: () {
                    context.read<AuthCubit>().login(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                ),

                SizedBox(height: 15),

                // 🔥 زر يروح للريجيستر
                TextButton(
                  child: Text("Don't have an account? Register"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RegisterScreen.routeName);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
