import 'package:digi2/screens/home.dart';
import 'package:digi2/services/firebase_auth.dart';
import 'package:digi2/screens/signup.dart';
import 'package:flutter/material.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 24, 30, 62),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/images/homebk.jpg').image,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 150.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const SizedBox(height: 200),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Email';
                              } else if (!RegExp(r'\S+@\S+\.\S+')
                                  .hasMatch(value)) {
                                return 'Enter valid Email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 0.9 * MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: InkWell(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.black,
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 0.8 * MediaQuery.of(context).size.width,
                          height: 0.13 * MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              final user =
                                  await _auth.signinwithemailandpassword(
                                      emailController.text,
                                      passwordController.text);
                              if (user != null) {
                                print("user logged In");
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (c) {
                                  return const Home();
                                }));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 170, 0),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                            //  style: ElevatedButton.styleFrom(
                            //     backgroundColor:
                            //         const Color.fromARGB(255, 255, 170, 0),
                            //   ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 25),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) {
                                  return Signup();
                                },
                              ));
                            }),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) {
                                return Signup();
                              },
                            ));
                          },
                          child: const Text(
                            'If you dont have an account? Sign up here!',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white, // Text color
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
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white, // Text color
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.apple,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text('iOS'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
