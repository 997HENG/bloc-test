import 'package:bloc/bloc.dart';
import 'package:bloc_testing/apis/login_api.dart';
import 'package:bloc_testing/apis/notes_api.dart';
import 'package:bloc_testing/bloc/actions.dart';
import 'package:bloc_testing/bloc/app_state.dart';
import 'package:bloc_testing/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;
  final LoginHandle acceptableLoginHandle;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
    required this.acceptableLoginHandle,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        // start loading
        emit(
          const AppState(
            isLoading: true,
            logingError: null,
            loginHandle: null,
            fetchNotes: null,
          ),
        );
        // log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );

        emit(
          AppState(
            isLoading: false,
            logingError: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchNotes: null,
          ),
        );
      },
    ); //loginAction

    on<LoadNotesAction>(
      (event, emit) async {
        // start loading
        emit(
          AppState(
            isLoading: true,
            logingError: null,
            loginHandle: state.loginHandle,
            fetchNotes: null,
          ),
        );
        // get the login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != acceptableLoginHandle) {
          //invalid login handle, cannot fetch notes
          emit(
            AppState(
              isLoading: false,
              loginHandle: loginHandle,
              logingError: LoginErrors.invalidHandle,
              fetchNotes: null,
            ),
          );
          return;
        }
        // we have a valid login handle and want to fetch notes
        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );
        emit(
          AppState(
            isLoading: false,
            loginHandle: loginHandle,
            logingError: null,
            fetchNotes: notes,
          ),
        );
      },
    ); //loadNotesAction
  }
}
