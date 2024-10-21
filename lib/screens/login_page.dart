import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_router/route_constants.dart';
import '../components/rounded_button2.dart';
import '../components/text_style.dart';
import '../input_form_field.dart';
import '../validators.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordShow = true;

  bool _isLoading = false;
  String? error;

  Future<void> _login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        _showSnackBar('Please enter both email and password');
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://reqres.in/api/login'),
      body: json.encode({
        "email": email,
        "password": password,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Storing token in Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', data['token']);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.go('/${Routes.home}');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Invalid email or password');
    }
  }


  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(child: Image.asset('assets/images/login_img.png')),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center,
                    children: [
                      Icon(
                        Icons.alternate_email,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: InputFormField(
                          textEditingController: emailController,
                          validator: Validators.isValidEmail,
                          hintTextStyle: AppTextStyle.textStyleOne(
                            const Color(0xffC4C5C4),
                            14,
                            FontWeight.w400,
                          ),
                          hintText: 'Email ID',
                          borderType: BorderType.bottom,
                          borderColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: InputFormField(
                          password: EnabledPassword(),
                          obscuringCharacter: '*',
                          textEditingController: passwordController,
                          hintTextStyle: AppTextStyle.textStyleOne(
                            const Color(0xffC4C5C4),
                            14,
                            FontWeight.w400,
                          ),
                          hintText: 'Password',
                          borderType: BorderType.bottom,
                          borderColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Forget password pressed!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  error == null ? Text('') : Text(error!),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : RoundedButton2(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          title: 'Login',
                          textColor: const Color.fromRGBO(255, 255, 255, 1),
                          colour: Colors.blue,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New to Logistics?',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Color(0xFF100D40),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
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
