import 'package:flutter/material.dart';
import 'package:saathi/screens/about_us_screen.dart';

class CustomDrawer extends StatelessWidget {
  // final String userName;
  // final String userEmail;
  // final String userImageUrl;
  // final VoidCallback onLogout;
  // final VoidCallback onAboutUsPressed;

  const CustomDrawer({
    super.key,
    //   required this.userName,
    //   required this.userEmail,
    //   this.userImageUrl = "",
    //   required this.onLogout,
    //   required this.onAboutUsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF2C3E50), // Matching app bar color
            ),
            accountName: Text(
              'Harsh',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            accountEmail: Text(
              'Ramavat',
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 60,
                color: Color(0xFF2C3E50), // Matching the header color
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person,
                color: Color(0xFF34495E)), // Slightly lighter than header
            title: Text("My Profile", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Color(0xFF34495E)),
            title: Text("My Matches", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFF34495E)),
            title: Text("Settings", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Color(0xFF34495E)),
            title: Text("Privacy Policy", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          Expanded(child: Container()),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline, color: Color(0xFF34495E)),
            title: Text("About Us", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,
                color: Colors.red), // Kept red for logout
            title: Text("Log Out",
                style: TextStyle(fontSize: 16, color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
