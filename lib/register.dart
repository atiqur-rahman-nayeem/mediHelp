import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medihelp/login.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this to false to hide the debug banner
      title: 'Your App Title',
      home: Register(), // Assuming Register is your starting screen
    );
  }
}
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);


  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool emailValidate = false;
  bool passwordValidation = false;
  bool isLoading = false;
  bool registrationSuccess = false;
  bool showPassword = false;

  bool _validateEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegExp.hasMatch(email)) {
      _showValidationErrorDialog("Validation Error", "Input the right email format like medihelp@gmail.com");
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    final passwordRegExp = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!passwordRegExp.hasMatch(password)) {
      _showValidationErrorDialog("Validation Error", "Password must meet the criteria (e.g., minimum length, uppercase, lowercase, digits, special characters");
      return false;
    }
    return true;
  }

  Future<void> registerUser() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (!_validateEmail(email)) {
      return;
    }

    if (!_validatePassword(password)) {
      setState(() {
        passwordValidation = true;
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() {
        registrationSuccess = true;
      });
    } catch (e) {
      print('Error during registration: $e');
    } finally {
      setState(() {
        isLoading = false;
      });

      if (registrationSuccess) {
        _showSuccessDialog();
      }
    }
  }

  void _showValidationErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Registration Success'),
          content: Text('You have successfully registered! Please login'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/register.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 150,
              ),
              const Text(
                "\tCreate an \n \tAccount",
                style: TextStyle(fontSize: 35, color: Colors.green),
              ),
              const SizedBox(
                height: 150,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.black38),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: "Email",
                  errorText: emailValidate
                      ? "Validation Error!"
                      : null,
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                  hintStyle: const TextStyle(fontSize: 20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.black38),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.black38),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: "Password",
                  errorText: passwordValidation ? "Validation Error" : null,
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                  hintStyle: const TextStyle(fontSize: 20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.black38),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sign Up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                  ElevatedButton(
                    onPressed: () {
                      registerUser();
                    },
                    child: const Icon(Icons.arrow_forward, color: Colors.green),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.black,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login())),
                    child: Text("  Already have an account?  Log In", style: TextStyle(fontSize: 22)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) CircularProgressIndicator(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
