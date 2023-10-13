import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_testing/bloc/actions.dart';
import 'package:bloc_testing/bloc/app_bloc.dart';
import 'package:bloc_testing/apis/login_api.dart';
import 'package:bloc_testing/apis/notes_api.dart';
import 'package:bloc_testing/bloc/app_state.dart';
import 'package:bloc_testing/models.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  }) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

const acceptableLoginHandle = LoginHandle(token: 'abc');

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be AppState.empty()',
    build: () => AppBloc(
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
      acceptableLoginHandle: acceptableLoginHandle,
    ),
    verify: (appState) => expect(
      appState.state,
      const AppState.empty(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'Can we log in with correct credentials?',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'bar@baz.com',
        acceptedPassword: 'foo',
        handleToReturn: acceptableLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
      acceptableLoginHandle: acceptableLoginHandle,
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginHandle: null,
        logingError: null,
        fetchNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginHandle: LoginHandle(token: 'abc'),
        logingError: null,
        fetchNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'We should not be able to log in with invalid credentials',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@bar.com',
        acceptedPassword: 'baz',
        handleToReturn: acceptableLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
      acceptableLoginHandle: acceptableLoginHandle,
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginHandle: null,
        logingError: null,
        fetchNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginHandle: null,
        logingError: LoginErrors.invalidHandle,
        fetchNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Load some notes with a valid login handle',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@bar.com',
        acceptedPassword: 'baz',
        handleToReturn: acceptableLoginHandle,
      ),
      notesApi: const DummyNotesApi(
        acceptedLoginHandle: acceptableLoginHandle,
        notesToReturnForAcceptedLoginHandle: mockNotes,
      ),
      acceptableLoginHandle: acceptableLoginHandle,
    ),
    act: (appBloc) {
      appBloc.add(
        const LoginAction(
          email: 'foo@bar.com',
          password: 'baz',
        ),
      );
      appBloc.add(
        const LoadNotesAction(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginHandle: null,
        logingError: null,
        fetchNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginHandle: acceptableLoginHandle,
        logingError: null,
        fetchNotes: null,
      ),
      const AppState(
        isLoading: true,
        loginHandle: acceptableLoginHandle,
        logingError: null,
        fetchNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginHandle: acceptableLoginHandle,
        logingError: null,
        fetchNotes: mockNotes,
      ),
    ],
  );
}
