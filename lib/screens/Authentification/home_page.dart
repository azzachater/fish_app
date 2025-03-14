import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../widgets/custom_button.dart';
import 'login_page.dart';
import 'signup_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: const <Widget>[
                  Text("Welcome", style: AppTheme.titleStyle),
                  SizedBox(height: 20),
                  Text(
                    "BackSlash Flutter provides extraordinary flutter tutorials. Do Subscribe!",
                    textAlign: TextAlign.center,
                    style: AppTheme.subtitleStyle,
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Authentification/welcome.png"),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  CustomButton(
                    text: "Login",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    ),
                    isPrimary: false, // Added the missing isPrimary parameter
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Sign up",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    ),
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}