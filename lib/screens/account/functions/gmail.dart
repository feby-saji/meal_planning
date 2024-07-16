
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGmailWithSubject(String subject, BuildContext ctx) async {
  const String email = 'globalsoftglabs25@gmail.com';
  final Uri feedbackUri = Uri(
    scheme: 'mailto',
    path: email,
    query: _encodeQueryParameters(<String, String>{
      'subject': subject,
      'body': '''


**Please provide your feedback here**

(Optional) You can also include:
  - Screenshots (if applicable)
  - Steps to reproduce an issue (if applicable)

Thank you for helping us improve the app!
''',
    }),
  );

  if (await canLaunchUrl(feedbackUri)) {
    await launchUrl(feedbackUri);
  } else {
    print('Could not launch email app');
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('Unable to launch email app. Please try again later.'),
      ),
    );
  }
}

String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
