import 'package:flutter/material.dart';

class UsersListScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UsersListScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(userData['picture']['large']),
            ),
            SizedBox(height: 16),
            Text(
              '${userData['name']['first']} ${userData['name']['last']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: ${userData['email']}'),
            SizedBox(height: 8),
            Text('Phone: ${userData['phone']}'),
            SizedBox(height: 8),
            Text(
                'Location: ${userData['location']['city']}, ${userData['location']['country']}'),
          ],
        ),
      ),
    );
  }
}
