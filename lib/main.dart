import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/providers/candidate_provider.dart';
import 'package:voting_system/providers/loading_provider.dart';
import 'package:voting_system/providers/users_provider.dart';
import 'package:voting_system/screens/home/show_results_screen.dart';
import 'package:voting_system/services/auth/forgot_password_api.dart';
import 'package:voting_system/services/auth/login_auth_api.dart';
import 'package:voting_system/services/auth/signup_auth_api.dart';
import 'package:voting_system/services/auth/verify_email_api.dart';
import 'package:voting_system/services/candidate/candidate_api.dart';
import 'package:voting_system/services/users/user_api.dart';
import 'package:voting_system/services/profile/apply_candidate_api.dart';
import 'package:voting_system/services/home/countdown_time_api.dart';
import 'package:voting_system/services/vote/vote_api.dart';
import 'package:voting_system/firebase_options.dart';
import 'package:voting_system/providers/countdown_provider.dart';
import 'package:voting_system/providers/load_data.dart';
import 'package:voting_system/screens/auth/forgot_password_screen.dart';
import 'package:voting_system/screens/auth/login_screen.dart';
import 'package:voting_system/screens/auth/signup_screen.dart';
import 'package:voting_system/screens/auth/verify_email_screen.dart';
import 'package:voting_system/screens/profile/apply_candidate_screen.dart';
import 'package:voting_system/screens/home/approve_candidates_screen.dart';
import 'package:voting_system/screens/home/pick_polling_time_screen.dart';
import 'package:voting_system/screens/home/show_users_screen.dart';
import 'package:voting_system/screens/splash/splash_screen.dart';
import 'package:voting_system/widgets/splash/splash_widget.dart';

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
        ChangeNotifierProvider<CountdownProvider>(
          create: (_) => CountdownProvider(),
        ),
        ChangeNotifierProvider<UsersProvider>(
          create: (_) => UsersProvider(),
        ),
        ChangeNotifierProvider<CandidateProvider>(
          create: (_) => CandidateProvider(),
        ),
        ChangeNotifierProvider<LoadingProvider>(
          create: (_) => LoadingProvider(),
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
          PickPollingTimeScreen.route: (p0) => const PickPollingTimeScreen(),
          ApproveCandidatesScreen.route: (p0) => const ApproveCandidatesScreen(),
          ShowResultsScreen.route:(p0) => const ShowResultsScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

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
                return const SplashWidget();
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
