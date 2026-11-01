import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/catalog_repository.dart';
import 'firebase_options.dart';
import 'ui/bloc/albums_bloc.dart';
import 'ui/bloc/albums_event.dart';
import 'ui/screens/catalog_screen.dart';
import 'ui/screens/auth_screen.dart';

class AppObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType}: $transition');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => CatalogRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Музыкальный Каталог',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.orange)),
          );
        }
        
        final user = snapshot.data;
        if (user == null) {
          return const AuthScreen();
        }
        
        return BlocProvider(
          create: (context) => AlbumsBloc(
            context.read<CatalogRepository>(),
          )..add(AlbumsLoadRequested(uid: user.uid)),
          child: const CatalogScreen(),
        );
      },
    );
  }
}
