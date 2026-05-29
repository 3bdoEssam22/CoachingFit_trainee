import 'package:coaching_fit_trainee/core/routing/app_routes.dart';
import 'package:coaching_fit_trainee/core/storage/secure_storage.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/screens/email_confirmation_screen.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/screens/login_screen.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/screens/register_screen.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/screens/splash_screen.dart';
import 'package:coaching_fit_trainee/features/home/presentation/screens/home_screen.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/screens/create_profile_screen.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/screens/view_profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final SecureStorage _secureStorage;
  AppRouter(this._secureStorage);

  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(name: AppRoutes.splash, path: '/', builder: (c, s) => const SplashScreen()),
      GoRoute(name: AppRoutes.onboarding, path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(name: AppRoutes.login, path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(name: AppRoutes.register, path: '/register', builder: (c, s) => const RegisterScreen()),
      GoRoute(name: AppRoutes.emailConfirmation, path: '/email-confirmation', builder: (c, s) => const EmailConfirmationScreen()),
      GoRoute(name: AppRoutes.createProfile, path: '/create-profile', builder: (c, s) => const CreateProfileScreen()),
      GoRoute(name: AppRoutes.home, path: '/home', builder: (c, s) => const HomeScreen()),
      GoRoute(name: AppRoutes.viewProfile, path: '/view-profile', builder: (c, s) => const ViewProfileScreen()),
      GoRoute(name: AppRoutes.editProfile, path: '/edit-profile', builder: (c, s) => const EditProfileScreen()),
    ],
    redirect: (context, state) async {
      final path = state.matchedLocation;
      if (path == '/') return null; // splash routes itself

      final token = await _secureStorage.readToken();
      const publicPaths = ['/login', '/register', '/email-confirmation', '/onboarding'];
      if (token == null) {
        return publicPaths.contains(path) ? null : '/login';
      }

      final hasProfile = await _secureStorage.readHasProfile();
      if (!hasProfile) {
        return path == '/create-profile' ? null : '/create-profile';
      }
      if (publicPaths.contains(path)) return '/home';
      return null;
    },
  );
}
