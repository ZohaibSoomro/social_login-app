import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay/loading_overlay.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(const SocialLoginApp());
}

class SocialLoginApp extends StatelessWidget {
  const SocialLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  User? user;
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Social Login App',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: googleSignIn,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        FaIcon(FontAwesomeIcons.google),
                        SizedBox(width: 10),
                        Text('Sign in with Google'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: facebookSignIn,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        FaIcon(FontAwesomeIcons.facebook),
                        SizedBox(width: 10),
                        Text('Sign in with Facebook'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void googleSignIn() async {
    toggleLoading();
    try {
      final userCredentials = await FirebaseAuth.instance.signInWithProvider(
        GoogleAuthProvider(),
      );
      print(userCredentials.user);
      if (userCredentials.user != null) {
        setState(() {
          user = userCredentials.user;
        });
      }
    } catch (e) {
      print("Exception : $e");
    }
    toggleLoading();
  }

  void facebookSignIn() async {
    toggleLoading();
    try {
      FacebookLogin fb = FacebookLogin();
      final result = await fb.logIn();
      if (result.accessToken != null) {
        OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredentials =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print(userCredentials.user);
        if (userCredentials.user != null) {
          setState(() async {
            final email = await fb.getUserEmail();
            print("Email: $email");
            user = userCredentials.user;
            user!.updateEmail(email ?? 'abc@gmail.com');
          });
        }
      }
    } catch (e) {
      print("Exception : $e");
    }
    toggleLoading();
  }
}
