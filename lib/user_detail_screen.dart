import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/add_user_screen.dart';
import 'user_list.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;
  final UserList userList;
  
  const UserDetailScreen(
      {super.key, required this.user, required this.userList});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.redAccent.shade100,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "User ID: ${user.email}", // Using email as a user ID
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                _sectionTitle("About"),
                _userDetail("Name", user.name),
                _userDetail("Gender", user.gender),
                _userDetail("Date of Birth", _formatDate(user.dob)),
                _showHobbies("Hobbies", user.hobbies),
                _userDetail("Martial Status", "Never Married"),
                _sectionTitle("Religious Background"),
                _userDetail("Country", "India"),
                _userDetail("City", user.city),
                _userDetail("Religion", "Hindu"),
                _userDetail("Caste", "Patel"),
                _userDetail("Sub Caste", "Lewa Patel"),
                _sectionTitle("Professional Details"),
                _userDetail("Higher Education", "B.Tech"),
                _userDetail("Occupation", "Software Engineer"),
                _sectionTitle("Contact Details"),
                _userDetail("Email", user.email),
                _userDetail("Phone", user.mobileNumber),
              ],
            ),
            const SizedBox(height: 20),

            // Edit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddUser(
                        user: user, userList: widget.userList,
                      ),
                    ),
                  );
                  setState(() {
                    user = widget.user;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Edit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
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

  Widget _showHobbies(String label, List<String> hobbies) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label : ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Hobbies",
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  String _formatDate(String dob) {
    try {
      DateTime birthDate = DateFormat('dd/MM/yyyy').parse(dob);
      return DateFormat('d MMM, yyyy').format(birthDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
