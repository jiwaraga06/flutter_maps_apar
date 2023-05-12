import 'package:flutter/material.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_maps_apar/source/widget/customForm.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Image.asset('assets/apar.jpg', height: 150),
                  const Text('Monitoring Apar', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomFormField(
                          hint: 'Hint',
                          obscureText: false,
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                        const SizedBox(height: 10),
                        CustomFormField(
                          hint: 'Password',
                          obscureText: false,
                          prefixIcon: Icon(Icons.key),
                          suffixIcon: Icon(Icons.visibility),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButon(
                    text: 'LOGIN',
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
