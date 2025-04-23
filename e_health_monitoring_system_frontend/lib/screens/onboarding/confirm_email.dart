import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/services/register_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmEmailNotifier extends ChangeNotifier {
  ConfirmEmailNotifier(this._userId);
  final String _userId;

  final _service = const RegisterService();
  EmailStatus status = EmailStatus.unconfirmed;

  void checkEmail() async {
    await Future.delayed(Duration(seconds: 5));
    if (!hasListeners) {
      return;
    }

    var resp = await _service.checkEmailConfirmed(_userId);
    var body = jsonDecode(resp.body);
    if (body case {"isEmailConfirmed": bool isConfirmed}) {
      if (isConfirmed) {
        status = EmailStatus.confirmed;
      }
    } else {
      status = EmailStatus.internalError;
    }

    // because the method is async the notifier
    //can be disposed before getting here
    if (hasListeners) {
      notifyListeners();
    }
  }
}

class ConfirmEmailScreen extends StatelessWidget {
  const ConfirmEmailScreen(this.userId, {super.key});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfirmEmailNotifier>(
      create: (context) => ConfirmEmailNotifier(userId),
      builder: (context, _) {
        return Consumer<ConfirmEmailNotifier>(
          builder: (context, value, child) {
            switch (value.status) {
              case EmailStatus.confirmed:
                return Text("confirmed");
              case EmailStatus.unconfirmed:
                {
                  value.checkEmail();
                  return CircularProgressIndicator();
                }
              case EmailStatus.internalError:
                return Text("error");
            }
          },
        );
      },
    );
  }
}
