import 'package:doramed/api/models.dart';
import 'package:doramed/materials/screen_widget.dart';
import 'package:doramed/materials/theme/colors.dart';
import 'package:doramed/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  final String message;
  final JwtModel jwt;
  final UserModel user;

  const StatusPage({
    super.key,
    required this.message,
    required this.jwt,
    required this.user,
  });

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.back,
      body: Center(
        child: ScreenWidget(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          content: [
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  widget.message,
                ),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.selc,
                minimumSize: const Size(200, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      jwt: widget.jwt,
                      user: widget.user,
                    ),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Go to home',
                style: TextStyle(
                  color: CustomColors.ten,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
