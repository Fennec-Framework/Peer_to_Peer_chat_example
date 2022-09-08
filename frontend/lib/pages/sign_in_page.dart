import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/chats_page.dart';
import 'package:frontend/pages/signup_page.dart';

import '../repository/auth_repository.dart';
import '../utils/utils.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignInPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool _passwordHide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Sign In',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(children: [
        const SizedBox(
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextField(
            controller: _userNameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0.0),
              labelText: 'Username',
              hintText: 'Username or Email',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
              prefixIcon: const Icon(
                CupertinoIcons.person,
                color: Colors.black,
                size: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextField(
            obscureText: _passwordHide,
            controller: _passwordController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0.0),
              labelText: 'Password',
              hintText: 'Password',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
              prefixIcon: const Icon(
                Icons.key,
                color: Colors.black,
                size: 18,
              ),
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
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 80,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: MaterialButton(
            onPressed: () async {
              final result = await AuthRepository().signIn(
                  context, _userNameController.text, _passwordController.text);
              if (result != null) {
                if (!mounted) return;
                Utils.showSnackBar(context, 'User successful Logged',
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatsPage(
                              currentUser: result,
                            )));
              }
            },
            height: 45,
            minWidth: double.maxFinite,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Text(
              "Sign In",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You D\'ont have yet an account?',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
