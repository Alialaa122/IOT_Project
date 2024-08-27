import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart'; // Import this library to use different fonts

final Color gold = Color(0xFFFFD835);
final Color darkNavyBlue = Color(0xFF000033);

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false; // Add this variable to manage password visibility

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Check if the email is verified
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        // Sign out the user as they are not verified
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please verify your email address before logging in.',
              style: TextStyle(
                color: darkNavyBlue,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: gold,
          ),
        );
        return;
      }

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Handle login errors (e.g., invalid credentials)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to log in. Please try again.',
            style: TextStyle(
              color: darkNavyBlue,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: gold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: GoogleFonts.pacifico(
            fontSize: 24,
            color: darkNavyBlue,
          ),
        ),
        backgroundColor: gold,
      ),
      body: Container(
        color: darkNavyBlue, // Set the background color
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: gold, fontFamily: 'Times New Roman'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: gold, fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: gold, fontFamily: 'Times New Roman'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Update the icon based on password visibility state
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: gold,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible, // Toggle password visibility
              style: TextStyle(color: gold, fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(
                'Log In',
                style: TextStyle(fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: darkNavyBlue,
                backgroundColor: gold,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: gold,
                        fontSize: 16,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                    TextSpan(
                      text: 'Sign Up here',
                      style: TextStyle(
                        color: gold,
                        fontSize: 16,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
