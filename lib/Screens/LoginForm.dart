import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'SignupForm.dart';
import 'ProfileForm.dart'; // Import the ProfileScreen.dart file

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);

  final dbHelper = DatabaseHelper.instance;

  // Define email and password variables
  String? email;
  String? password;

  bool loginSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.cyan,
            fontSize: 25.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30.0),
                Image.asset(
                  "assets/images/account-removebg-preview.png",
                  height: 200.0,
                  width: 300.0,
                ),

                const Text(
                  ' Lets sign in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                    fontSize: 30.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 60.0),
                  child: TextFormField(
                    onChanged: (value) {
                      email = value; // Assign value to email
                    },
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      prefixIconColor: Colors.cyan,
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    onChanged: (value) {
                      password = value; // Assign value to password
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      prefixIconColor: Colors.cyan,
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = await dbHelper.getUserByEmailAndPassword(email!, password!);
                      if (user != null) {
                        loginSuccess = true;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
                        ); // Navigate to ProfileScreen with user data
                      } else {
                        loginSuccess = false;
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Login ${loginSuccess ? 'Success' : 'Failure'}'),
                          content: Text(loginSuccess ? 'Welcome, ${user!.name}!' : 'Invalid credentials'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Does not have an account?'),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                        child: const Text('Sign up'),
                      ),
                    ],
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
