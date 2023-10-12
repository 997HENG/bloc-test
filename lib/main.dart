import 'package:bloc_testing/apis/login_api.dart';
import 'package:bloc_testing/apis/notes_api.dart';
import 'package:bloc_testing/bloc/actions.dart';
import 'package:bloc_testing/bloc/app_bloc.dart';
import 'package:bloc_testing/dialogs/generic_dialog.dart';
import 'package:bloc_testing/dialogs/loading_screen.dart';
import 'package:bloc_testing/models.dart';
import 'package:bloc_testing/strings.dart';
import 'package:bloc_testing/views/iterable_list_view.dart';
import 'package:bloc_testing/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_state.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.amber[300]),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              homePage,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {
              // loading screen
              if (appState.isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                  text: pleaseWait,
                );
              } else {
                LoadingScreen.instance().hide();
              }
              final logeinError = appState.logingError;
              if (logeinError != null) {
                showGenericDialog(
                  context: context,
                  title: loginErrorDialogTitle,
                  content: loginErrorDialogContent,
                  optionBuilder: () => {ok: true},
                );
              }

              // if we are loggedin, but we have no fetch notes, fetch them now
              if (appState.isLoading == false &&
                  appState.logingError == null &&
                  appState.loginHandle == const LoginHandle.fooBar() &&
                  appState.fetchNotes == null) {
                context.read<AppBloc>().add(
                      const LoadNotesAction(),
                    );
              }
            },
            builder: (context, appState) {
              final notes = appState.fetchNotes;
              if (notes == null) {
                return LoginView(
                  onLoginTapped: (email, password) {
                    context.read<AppBloc>().add(
                          LoginAction(
                            email: email,
                            password: password,
                          ),
                        );
                  },
                );
              } else {
                return notes.toListView();
              }
            },
          )),
    );
  }
}
