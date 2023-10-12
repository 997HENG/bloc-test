import 'package:bloc_testing/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? logingError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchNotes;

  const AppState.empty()
      : isLoading = false,
        loginHandle = null,
        logingError = null,
        fetchNotes = null;

  const AppState({
    required this.isLoading,
    required this.loginHandle,
    required this.logingError,
    required this.fetchNotes,
  });

  @override
  String toString() => {
        'isloading': isLoading,
        'loginError': logingError,
        'loginHandle': loginHandle,
        'fetchNotes': fetchNotes,
      }.toString();
}
