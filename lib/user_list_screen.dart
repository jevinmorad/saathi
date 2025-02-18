import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saathi/user_detail_screen.dart';
import 'package:saathi/user_list.dart';
import 'package:saathi/add_user_screen.dart';

class UserListScreen extends StatefulWidget {
  final UserList userList;

  const UserListScreen({super.key, required this.userList});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];
  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    users = widget.userList.getUsers();
    filteredUsers = users;
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.city.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()) ||
              user.mobileNumber.contains(query) ||
              _calculateAge(user.dob).contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Your Match',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: filteredUsers.isEmpty
          ? Text('User not found')
          : Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, city, age, email, phone...',
                      prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    onChanged: _filterUsers,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailScreen(
                                  user: user,
                                  userList: widget.userList,
                                ),
                              ),
                            );
                          },
                          child: _userCard(user, index, context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _userCard(User user, int index, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.redAccent.shade100,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 5),
            _userDetails(Icons.location_city, 'City', user.city),
            _userDetails(Icons.email, 'Email', user.email),
            _userDetails(Icons.phone, 'Mobile', user.mobileNumber),
            _userDetails(Icons.person_outline, 'Gender', user.gender),
            _userDetails(Icons.cake, 'Age', _calculateAge(user.dob)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                      users[index].isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      users[index].isFavourite = !users[index].isFavourite;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUser(
                          userList: widget.userList,
                          index: index,
                          user: user,
                        ),
                      ),
                    );
                    setState(() {
                      users = widget.userList.getUsers();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, user, index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _userDetails(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 20),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAge(String dob) {
    try {
      DateTime birthDate = DateFormat('dd/MM/yyyy').parse(dob);
      int age = DateTime.now().year - birthDate.year;
      if (DateTime.now().month < birthDate.month ||
          (DateTime.now().month == birthDate.month &&
              DateTime.now().day < birthDate.day)) {
        age--;
      }
      return '$age years';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, User user, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.userList.deleteUser(index);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
