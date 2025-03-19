import 'package:doramed/api/models.dart';
import 'package:doramed/api/requests.dart';
import 'package:doramed/db/shared_preffs.dart';
import 'package:doramed/materials/screen_widget.dart';
import 'package:doramed/materials/textfields.dart';
import 'package:doramed/materials/theme/colors.dart';
import 'package:doramed/screens/home/home_screen.dart';
import 'package:doramed/screens/login/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SharedPref sharedPref = SharedPref();

  final userService = UserService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void _login(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        // Show an error if fields are empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter both username and password'),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Call the login method from UserService
        UserAuthResponseModel response = await userService.login(
          username,
          password,
        );

        // On successful login, navigate to homepage and save user data
        await sharedPref.save('jwt', {
          'access_token': response.jwt.accessToken,
          'refresh_token': response.jwt.refreshToken
        });
        await sharedPref.save('user', response.user.toJson());

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
    } else {
      // Show a message if the form is not valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all required fields correctly.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.back,
      body: Center(
        child: ScreenWidget(
          mainAxisAlignment: MainAxisAlignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          content: [
            const Text(
              'Doramed',
              style: TextStyle(
                fontFamily: 'grandhotel',
                color: CustomColors.selc,
                fontSize: 50,
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
                    'Login..',
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
                    labelName: 'Username',
                    keyboardType: TextInputType.name,
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MyTextField(
                    labelName: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    maxLines: 1,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
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
                      _login(context);
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
                            'Login',
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
                const Text("Don't you have an account?"),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
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
