import 'package:digi2/components/checkbox.dart';
import 'package:digi2/screens/login.dart';
import 'package:digi2/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController usernamecontroller = TextEditingController();
TextEditingController phonenumbercontroller = TextEditingController();
final _auth = AuthService();

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final _auth = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _agreedToTerms = false;
  String? _termsError;

  Future<void> _registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _auth
            .registerWithGoogle(); // Call the registerWithGoogle method from AuthService
        // Navigate to your desired page after successful sign-up
      }
    } catch (error) {
      print('Error signing up with Google: $error');
      // Handle errors or display a message to the user
    }
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Signup",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 0.9 * MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: usernamecontroller,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              // Customize focused border
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 0.9 * MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.black,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              // Customize focused border
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 0.9 * MediaQuery.of(context).size.width,
                        child: TextFormField(
                          obscureText: _obscureText,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            suffixIcon: InkWell(
                              onTap:
                                  _toggleObscureText, // Toggle visibility on tap
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            ),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const UnderlineInputBorder(
                              // Customize focused border
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 0.9 * MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: phonenumbercontroller,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Phone No.',
                            prefixIcon: Icon(
                              Icons.phone_android,
                              color: Colors.black,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              // Customize focused border
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length != 11) {
                              return 'Phone number should be 11 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            BlackCheckbox(
                              value: _agreedToTerms,
                              onChanged: (newValue) {
                                setState(() {
                                  _agreedToTerms = newValue!;
                                });
                              },
                            ),
                            const Text(
                              'I agree to the terms and conditions',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (_termsError != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            _termsError!,
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight:
                                    FontWeight.bold), // Error message style
                          ),
                        ),
                      SizedBox(
                        width: 0.8 * MediaQuery.of(context).size.width,
                        height: 0.13 * MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: _agreedToTerms
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    final user = await _auth
                                        .registerWithEmailAndPassword(
                                      emailController.text,
                                      passwordController.text,
                                      usernamecontroller.text,
                                      phonenumbercontroller.text,
                                      '',
                                    );
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (c) {
                                        return Login();
                                      },
                                    ));
                                  }
                                }
                              : () {
                                  setState(() {
                                    _termsError =
                                        'Please accept the terms and conditions.'; // Set error message
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Signup',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _registerWithGoogle,
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 254, 253, 253),
                              backgroundColor: const Color.fromARGB(
                                  255, 0, 0, 0), // Text color
                            ),
                            child: const Row(
                              children: [
                                ImageIcon(
                                  AssetImage('assets/images/googlelogo.png'),
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text('Google'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black, // Text color
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.apple,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text('Apple'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) {
                              return Login();
                            },
                          ));
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'If you dont have an account? ',
                            style:
                                TextStyle(fontSize: 12.25, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Log in',
                                style: TextStyle(
                                    fontSize: 12.25, color: Colors.blue),
                              ),
                              TextSpan(
                                text: ' here!',
                                style: TextStyle(
                                    fontSize: 12.25, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
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
