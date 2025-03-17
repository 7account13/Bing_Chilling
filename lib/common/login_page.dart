import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/user/user_home_page.dart';
import '/collector/collector_home_page.dart';
import '/recycler/recycler_home_page.dart';
import '/common/register_page.dart';
import '../config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Login function
  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('$BASE_URL/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);
      print("Full Response: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        String role = responseData['role']?.toLowerCase() ?? ''; // FIXED ROLE PARSING
        print("User Role: $role"); // Debugging role output

        Widget nextPage;
        if (role == 'user') {
          nextPage = UserHomePage();
        } else if (role == 'collector') {
          nextPage = CollectorHomePage();
        } else if (role == 'recycler') {
          nextPage = RecyclerHomePage();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid role received: $role")),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        Future.microtask(() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextPage));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Login failed")),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong. Try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Role selection dialog
  Future<String?> _showRoleSelectionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('User'),
                onTap: () => Navigator.pop(context, 'user'),
              ),
              ListTile(
                title: Text('Collector'),
                onTap: () => Navigator.pop(context, 'collector'),
              ),
              ListTile(
                title: Text('Recycler'),
                onTap: () => Navigator.pop(context, 'recycler'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) => value!.contains('@') ? null : 'Invalid email',
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) => value!.length >= 6 ? null : 'Minimum 6 characters',
              ),
              SizedBox(height: 30),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                    child: Text("Sign In"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final selectedRole = await _showRoleSelectionDialog(context);
                      if (selectedRole != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(role: selectedRole),
                          ),
                        );
                      }
                    },
                    child: Text("Don't have an account? Register here"),
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
