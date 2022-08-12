import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/widgets/my_custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _passwordHide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900.withAlpha(100),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(children: [
        const SizedBox(
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: MyCustomTextField(
            _emailController,
            TextInputType.text,
            TextAlign.start,
            hint: 'Email',
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: MyCustomTextField(
            _userNameController,
            TextInputType.text,
            TextAlign.start,
            hint: 'UserName',
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: MyCustomTextField(
            _passwordController,
            TextInputType.visiblePassword,
            TextAlign.start,
            maxLine: 1,
            minLine: 1,
            hide: _passwordHide,
            hint: 'Password',
            suffixIcon: IconButton(
              icon: _passwordHide
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () {
                setState(() {
                  _passwordHide = !_passwordHide;
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        MaterialButton(child: Text('ds'), onPressed: () {})
      ]),
    );
  }
}
