import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/model/login/login_screen_content.dart';
import 'package:todo_app/presentation/login/login_screen.dart';

import '../../bloc/login/login_bloc.dart';

class LoginScreenController extends StatelessWidget {
  const LoginScreenController({
    required this.onLoggedIn,
  });

  final VoidCallback onLoggedIn;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (oldState, newState) {
        return oldState != newState;
      },
      builder: (context, state) {
        if (state is ContentState) {
          return LoginScreen(
            onLogInPressed: (email, password) =>
                _tryLogin(context, state, email, password),
            onChangeTypePressed: (content) => _changeLoginAction(context, content),
            content: state.content,
          );
        }

        return Container();
      },
    );
  }

  void _tryLogin(
    BuildContext context,
    ContentState state,
    String email,
    String password,
  ) {
    BlocProvider.of<LoginBloc>(context).add(AttemptLoginEvent(
      currentState: state,
      email: email,
      password: password,
      onResponse: (message) => _checkResponse(context, message),
    ));
  }

  void _changeLoginAction(
    BuildContext context,
    LoginScreenContent content,
  ) {
    BlocProvider.of<LoginBloc>(context)
        .add(ChangeLoginActionEvent(content));
  }

  void _checkResponse(BuildContext context, String? message) {
    if (message == null) {
      onLoggedIn();
    } else {
      _presentSnackMessage(context, message);
    }
  }

  void _presentSnackMessage(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
}
