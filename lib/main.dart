import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/firebase/auth/forgot_password_api.dart';
import 'package:voting_system/firebase/auth/login_auth_api.dart';
import 'package:voting_system/firebase/auth/signup_auth_api.dart';
import 'package:voting_system/firebase/auth/verify_email_api.dart';
import 'package:voting_system/firebase/candidate/candidate_api.dart';
import 'package:voting_system/firebase/users/user_api.dart';
import 'package:voting_system/firebase/home/apply_candidate_api.dart';
import 'package:voting_system/firebase/home/countdown_time_api.dart';
import 'package:voting_system/firebase/vote/vote_api.dart';
import 'package:voting_system/firebase_options.dart';
import 'package:voting_system/providers/load_data.dart';
import 'package:voting_system/screens/auth/forgot_password_screen.dart';
import 'package:voting_system/screens/auth/login_screen.dart';
import 'package:voting_system/screens/auth/signup_screen.dart';
import 'package:voting_system/screens/auth/verify_email_screen.dart';
import 'package:voting_system/screens/home/apply_candidate_screen.dart';
import 'package:voting_system/screens/home/show_users_screen.dart';
import 'package:voting_system/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VotingSystem());
}

class VotingSystem extends StatelessWidget {
  const VotingSystem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginAuthApi>(
          create: (_) => LoginAuthApi(),
        ),
        Provider<SignUpAuthApi>(
          create: (_) => SignUpAuthApi(),
        ),
        Provider<ForgotPasswordApi>(
          create: (_) => ForgotPasswordApi(),
        ),
        Provider<VerifyEmailApi>(
          create: (_) => VerifyEmailApi(),
        ),
        Provider<ApplyCandidateApi>(
          create: (_) => ApplyCandidateApi(),
        ),
        Provider<CandidateApi>(
          create: (_) => CandidateApi(),
        ),
        Provider<CountdownTimeApi>(
          create: (_) => CountdownTimeApi(),
        ),
        Provider<VoteApi>(
          create: (_) => VoteApi(),
        ),
        Provider<UserApi>(
          create: (_) => UserApi(),
        ),
        Provider<LoadData>(
          create: (_) => LoadData(),
        ),
      ],
      child: CupertinoApp(
        theme: const CupertinoThemeData(
          barBackgroundColor: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.white,
            darkColor: CupertinoColors.black,
          ),
          scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.extraLightBackgroundGray,
            darkColor: CupertinoColors.black,
          ),
        ),
        routes: {
          '/': (p0) => const SplashScreen(),
          SignUpScreen.route: (p0) => const SignUpScreen(),
          ForgotPasswordScreen.route: (p0) => const ForgotPasswordScreen(),
          ApplyCandidateScreen.route: (p0) => const ApplyCandidateScreen(),
          ShowUsersScreen.route: (p0) => const ShowUsersScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const route = '/AuthPage';

  _loadData(BuildContext context) async {
    final loadData = Provider.of<LoadData>(context, listen: false);
    await loadData.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (snapshot.hasError) {
          return const CupertinoPageScaffold(
            child: Center(
              child: Text('Error Logging in'),
            ),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder(
            future: _loadData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CupertinoPageScaffold(
                  child: Center(
                    child: Column(
                      children: const [
                        Text(
                          'Loading Data...',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 40,
                            color: CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.black,
                              darkColor: CupertinoColors.white,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 64,
                        ),
                        CupertinoActivityIndicator(
                          radius: 16,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const CupertinoPageScaffold(
                  child: Center(
                    child: Text('Error Loading Data...'),
                  ),
                );
              } else {
                return const VerifyEmailScreen();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
