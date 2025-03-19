import 'package:doramed/api/models.dart';
import 'package:doramed/db/shared_preffs.dart';
import 'package:doramed/materials/theme/colors.dart';
import 'package:doramed/screens/home/home_screen.dart';
import 'package:doramed/screens/login/login_scree.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static String routeName = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  // Check if user data exists in SharedPreferences
  void _checkUserLoggedIn() async {
    try {
      final SharedPref sharedPref = SharedPref();
      final JwtModel jwt = JwtModel.fromJson(await sharedPref.read('jwt'));
      final UserModel user = UserModel.fromJson(await sharedPref.read('user'));

      // Navigate to Home Page if user is logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: user,
            jwt: jwt,
          ),
        ),
      );
    } catch (e) {
      print(e);
      // Navigate to Login Page if not logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CustomColors.back,
      body: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: CustomColors.selc,
          ),
        ),
      ),
    );
  }
}
