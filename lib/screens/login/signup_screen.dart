import 'package:doramed/api/models.dart';
import 'package:doramed/api/requests.dart';
import 'package:doramed/db/shared_preffs.dart';
import 'package:doramed/materials/screen_widget.dart';
import 'package:doramed/materials/textfields.dart';
import 'package:doramed/materials/theme/colors.dart';
import 'package:doramed/screens/home/home_screen.dart';
import 'package:doramed/screens/login/login_scree.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static String routeName = '/signup';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SharedPref sharedPref = SharedPref();

  final userService = UserService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email';
    }
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Please enter a username';
    }
    if (username.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validatePasswordConfirmation(String? passwordConfirmation) {
    if (passwordConfirmation == null || passwordConfirmation.isEmpty) {
      return 'Please confirm your password';
    }
    if (_passwordController.text != passwordConfirmation) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String password2 = _passwordController2.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        password2.isEmpty) {
      // Show an error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter requirde fields'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the login method from UserService
      UserAuthResponseModel response = await userService.signUp(
        username,
        email,
        password,
        password2,
      );

      // On successful signip, navigate to homepage and save user data
      await sharedPref.save('jwt', {
        'access_token': response.jwt.accessToken,
        'refresh_token': response.jwt.refreshToken
      });
      await sharedPref.save('user_id', response.user.id);

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(
              jwt: response.jwt,
              user: response.user,
            ),
          ),
        );
      }
    } catch (e) {
      // Show error message if login fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.back,
      body: Center(
        child: ScreenWidget(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          content: [
            const Text(
              'Doramed',
              style: TextStyle(
                color: CustomColors.selc,
                fontSize: 50,
                fontFamily: 'grandhotel',
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SignUP..',
                    style: TextStyle(
                      color: CustomColors.eight,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  MyTextField(
                    labelName: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: _validateEmail,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MyTextField(
                    labelName: 'Username',
                    keyboardType: TextInputType.name,
                    controller: _usernameController,
                    validator: _validateUsername,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MyTextField(
                    labelName: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    obscureText: true,
                    maxLines: 1,
                    validator: _validatePassword,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MyTextField(
                    labelName: 'Password confirm',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    maxLines: 1,
                    controller: _passwordController2,
                    validator: _validatePasswordConfirmation,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.selc,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _register(context);
                    },
                    child: _isLoading
                        ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: CustomColors.ten,
                            ),
                          )
                        : const Text(
                            'SignUp',
                            style: TextStyle(
                              color: CustomColors.ten,
                            ),
                          ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Do you have an account?"),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: CustomColors.b,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
