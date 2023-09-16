import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/presentation/views/auth/login_builder.dart';
import 'package:anirecord/presentation/views/home/list/list_view.dart';
import 'package:anirecord/presentation/views/home/navigation.dart';
import 'package:anirecord/presentation/views/login_view.dart';
import 'package:anirecord/presentation/views/serie/serie_builder.dart';
import 'package:anirecord/presentation/views/user/sign_in_builder.dart';
import 'package:anirecord/presentation/views/user/user_view.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  // Define your routes here
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthBuilder(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const NavigationView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context,state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context,state) => const SignInBuilder(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context,state)=> const UserProfileScreen(),
      ),
      GoRoute(
      path: '/serie',
      builder: (context,state){
        Serie e = state.extra as Serie;
        return SerieBuilder(e);
      },
      ),
      GoRoute(
      path: '/create_album',
      builder: (context,state)=> const CreateNewListScreen(),
      ),
  ],
);

