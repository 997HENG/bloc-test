import 'package:bloc_testing/bloc/bottom_bloc.dart';
import 'package:bloc_testing/bloc/top_bloc.dart';
import 'package:bloc_testing/models/constants.dart';
import 'package:bloc_testing/views/app_bloc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
              create: (_) => TopBloc(
                waitBeforeLoading: const Duration(seconds: 3),
                urls: image,
              ),
            ),
            BlocProvider<BottomBloc>(
              create: (_) => BottomBloc(
                waitBeforeLoading: const Duration(seconds: 3),
                urls: image,
              ),
            ),
          ],
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBlocView<TopBloc>(),
              AppBlocView<BottomBloc>(),
            ],
          ),
        ),
      ),
    );
  }
}
