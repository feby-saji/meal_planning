import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome to GlobalSoftlabs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Founded in 2024, GlobalSoftlabs is dedicated to developing innovative solutions '
              'that simplify everyday tasks. We are passionate about improving the way families '
              'plan and enjoy meals with our Meal Planning app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'At GlobalSoftlabs, we strive to empower families to achieve healthier lifestyles '
              'by making meal planning convenient and accessible to everyone. Our mission is to '
              'provide tools that inspire balanced eating habits and save time in the kitchen.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Have questions or feedback? We’d love to hear from you! Reach out to us at '
              'globalsoftlabs25@gmail.com for updates and more information about Meal Planning.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
