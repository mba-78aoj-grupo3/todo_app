part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  Stream<LoginState> applyAsync(LoginBloc bloc);

  @override
  List<Object> get props => [];
}

@immutable
class FillScreenContentEvent extends LoginEvent {
  FillScreenContentEvent();

  @override
  Stream<LoginState> applyAsync(LoginBloc bloc) async* {
    yield ContentState(LoginDefaultEmpty.loginEmpty);
  }
}

@immutable
class AttemptLoginEvent extends LoginEvent {
  AttemptLoginEvent({
    required this.currentState,
    required this.email,
    required this.password,
    required this.onResponse,
  });

  final ContentState currentState;
  final String email;
  final String password;
  final Function(String? errorMessage) onResponse;

  @override
  Stream<LoginState> applyAsync(LoginBloc bloc) async* {
    yield ContentState(currentState.content.copyWith(isLoading: true));

    switch (currentState.content.action) {
      case LoginAction.login:
        yield* _performLogin(bloc);
        break;
      case LoginAction.register:
        yield* _performRegistration(bloc);
        break;
    }
  }

  @override
  List<Object> get props => [currentState];

  Stream<LoginState> _performLogin(LoginBloc bloc) async* {
    final message = await bloc._authenticator.login(email, password);
    yield* _streamForResponse(message);
  }

  Stream<LoginState> _performRegistration(LoginBloc bloc) async* {
    final message = await bloc._authenticator.createUser(email, password);
    yield* _streamForResponse(message);
  }

  Stream<LoginState> _streamForResponse(String? message) async* {
    if (message != null) {
      yield ContentState(currentState.content.copyWith(isLoading: false));
    }

    onResponse(message);
  }
}

@immutable
class ChangeLoginActionEvent extends LoginEvent {
  ChangeLoginActionEvent(this.content);

  final LoginScreenContent content;

  @override
  Stream<LoginState> applyAsync(LoginBloc bloc) async* {
    switch (content.action) {
      case LoginAction.login:
        yield ContentState(RegisterDefaultEmpty.registerEmpty);
        break;
      default:
        yield ContentState(LoginDefaultEmpty.loginEmpty);
        break;
    }
  }
}
