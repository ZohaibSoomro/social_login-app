import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              user.photoURL ??
                  'https://tse2.mm.bing.net/th?id=OIP.fBYQQAMqYDFxOh5dWobzLgHaFj&pid=Api&P=0',
            ),
          ),
          const SizedBox(height: 30),
          Text('${user.displayName}'),
          const SizedBox(height: 10),
          Text('${user.email}'),
          const SizedBox(height: 10),
          Text('${user.phoneNumber}'),
        ],
      ),
    );
  }
}
