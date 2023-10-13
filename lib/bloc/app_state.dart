import 'package:bloc_testing/models.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:collection/collection.dart';

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

  @override
  bool operator ==(covariant AppState other) {
    final otherPropertiesAreEqual = isLoading == other.isLoading &&
        logingError == other.logingError &&
        loginHandle == other.loginHandle;
    if (fetchNotes == null && other.fetchNotes == null) {
      return otherPropertiesAreEqual;
    } else {
      return otherPropertiesAreEqual &&
          (fetchNotes?.isEqualTo(other.fetchNotes) ?? false);
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        logingError,
        loginHandle,
        fetchNotes,
      );
}

extension UnorderedEquality on Object {
  bool isEqualTo(other) => const DeepCollectionEquality.unordered().equals(
        this,
        other,
      );
}
