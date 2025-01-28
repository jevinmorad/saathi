import 'package:flutter/material.dart';
import 'package:matrimonial_app/user_list.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    List<User> users = UserList().getUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: users.isEmpty
          ? Center(
        child: Text('No users available'),
      )
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          User user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}
