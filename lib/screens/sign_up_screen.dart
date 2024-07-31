import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'home_screen.dart';
import 'sign_in_screen.dart';

// Define enableFirebase
const bool enableFirebase = false;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FirebaseAuth? _auth = enableFirebase ? FirebaseAuth.instance : null;
  final FirebaseFirestore? _firestore =
      enableFirebase ? FirebaseFirestore.instance : null;
  final GoogleSignIn? _googleSignIn = enableFirebase ? GoogleSignIn() : null;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final dateOfBirth = _dateOfBirthController.text;
      final password = _passwordController.text;

      if (enableFirebase) {
        try {
          UserCredential userCredential =
              await _auth!.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          await _firestore!
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'dateOfBirth': dateOfBirth,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        } on FirebaseAuthException catch (e) {
          String errorMessage;
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage = 'This email address is already in use.';
              break;
            case 'invalid-email':
              errorMessage = 'The email address is not valid.';
              break;
            case 'weak-password':
              errorMessage = 'The password is too weak.';
              break;
            default:
              errorMessage = 'An unknown error occurred.';
          }

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sign-Up Failed'),
                content: Text(errorMessage),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle non-Firebase sign-up logic here if needed
        print('Firebase functionality is disabled.');
      }
    }
  }

  Future<void> _signUpWithGoogle() async {
    if (enableFirebase) {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();

        if (googleUser == null) {
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth!.signInWithCredential(credential);

        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore!
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'firstName': googleUser.displayName!.split(' ')[0],
            'lastName': googleUser.displayName!.split(' ').last,
            'email': googleUser.email,
            'dateOfBirth': '',
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      } catch (e) {
        print('Google sign-up error: $e');
      }
    } else {
      // Handle non-Firebase Google sign-up logic here if needed
      print('Firebase functionality is disabled.');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.account_circle),
                onPressed: enableFirebase ? _signUpWithGoogle : null,
                label: Text('Sign Up with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
