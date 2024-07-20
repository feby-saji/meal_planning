import 'package:flutter/material.dart';
import 'package:meal_planning/widgets/error_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

void openGmailWithSubject(BuildContext context) async {
  const String email = 'globalsoftlabs25@gmail.com';

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query:
        'subject=CallOut%20user%20Profile&body=Please%20provide%20your%20feedback%20here%0A%0A(Optional)%20You%20can%20also%20include%3A%0A%20%20-%20Screenshots%20(if%20applicable)%0A%20%20-%20Steps%20to%20reproduce%20an%20issue%20(if%20applicable)%0A%0AThank%20you%20for%20helping%20us%20improve%20the%20app!%0A',
  );

  try {
    await launchUrl(emailLaunchUri);
  } catch (e) {
    showErrorSnackbar(context, 'unable to launch gmail');
  }
}
