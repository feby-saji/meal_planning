import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms & Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '1. Introduction\n\n'
                'Welcome to Meal Planning, provided by GlobalSoftlabs ("we," "our," or "us"). '
                'These Terms and Conditions ("Terms") govern your use of our app and services. '
                'By using our app, you agree to comply with and be bound by these Terms. Please read them carefully.\n\n'
                '2. Account Creation\n\n'
                'To use Meal Planning, you must create an account. You are responsible for maintaining '
                'the confidentiality of your account information and for all activities that occur under your account.\n\n'
                '3. Subscription\n\n'
                '3.1 Subscription Details\n\n'
                '- Subscription Rate: USD 0.39 per month (subject to change)\n'
                '- Grace Period: 7 days\n'
                '- Account Hold Period: 30 days\n'
                '- Billing Date: Charging occurs at the next billing date\n'
                '- Availability: Subscription is available worldwide\n\n'
                '3.2 Billing and Payment\n\n'
                '- Your subscription will automatically renew each month unless canceled at least 24 hours before the end of the current period.\n'
                '- Payment will be charged to your Google Play account at confirmation of purchase.\n'
                '- If a payment fails, you will have a 7-day grace period to update your payment method. If not updated within the grace period, your account will be placed on hold for 30 days, during which you can update your payment method to restore your subscription.\n\n'
                '3.3 Cancellation\n\n'
                '- You can cancel your subscription at any time through your Google Play account settings.\n'
                '- Cancellation will take effect at the end of the current billing cycle, and you will continue to have access to your subscription until then.\n\n'
                '4. User Conduct\n\n'
                'You agree not to use Meal Planning for any unlawful purpose or in any way that could harm the app, its users, or third parties.\n\n'
                '5. Intellectual Property\n\n'
                'All content, trademarks, and data on Meal Planning are the property of GlobalSoftlabs or its licensors. Unauthorized use is prohibited.\n\n'
                '6. Limitation of Liability\n\n'
                'GlobalSoftlabs will not be liable for any damages arising from the use or inability to use Meal Planning.\n\n'
                '7. Governing Law\n\n'
                'These Terms shall be governed by and construed in accordance with the laws of India.\n\n'
                '8. Changes to Terms\n\n'
                'We reserve the right to update these Terms at any time. Changes will be effective immediately upon posting. Your continued use of Meal Planning constitutes acceptance of the new Terms.\n\n'
                '9. Contact Information\n\n'
                'If you have any questions about these Terms, please contact us at globalsoftlabs25@gmail.com.\n',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
