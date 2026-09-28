import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/blocs/Candidate/candidate_bloc.dart';
import 'package:frontend/blocs/Candidate/candidate_event.dart';
import 'package:frontend/services/vardigo_service.dart';
import 'package:frontend/views/candidates_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> loginFuture;

  @override
  void initState() {
    super.initState();

    loginFuture = VardigoService.login('employer');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vardigo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Urbanist',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: FutureBuilder<bool>(
        future: loginFuture,
        builder: (context, snapshot) {
          // =========================
          // LOGIN EN COURS
          // =========================

          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // =========================
          // LOGIN ÉCHOUÉ
          // =========================

          if (snapshot.data != true) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Connexion au serveur impossible.',
                ),
              ),
            );
          }

          // =========================
          // LOGIN RÉUSSI
          // =========================

          return BlocProvider(
            create: (_) => CandidateBloc()
              ..add(
                InitializingCandidateEvent(),
              ),
            child: const MatchedStaffView(),
          );
        },
      ),
    );
  }
}