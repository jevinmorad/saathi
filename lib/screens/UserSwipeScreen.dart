import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saathi/database/local/const.dart';
import 'package:saathi/database/local/db_connection.dart';
import 'package:saathi/forms/components/hobby_icons.dart';
import 'package:saathi/forms/edit_pages/basic_details_edit.dart';
import 'package:saathi/forms/edit_pages/bio_details_edit.dart';
import 'package:saathi/forms/edit_pages/contact_details_edit.dart';
import 'package:saathi/forms/edit_pages/hobbies_edit.dart';

class UserSwipeScreen extends StatefulWidget {
  const UserSwipeScreen({super.key});

  @override
  State<UserSwipeScreen> createState() => _UserSwipeScreenState();
}

class _UserSwipeScreenState extends State<UserSwipeScreen> {
  List<Map<String, dynamic>> users = [];
  final PageController _pageController = PageController();
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<Map<String, dynamic>> fetchedUsers =
        await DBConnect.getInstance.getAllUsersWithPhoto();

    for (var user in fetchedUsers) {
      List<String> hobbies =
          await DBConnect.getInstance.getInterests(user[USER_ID]);
      user[INTERESTS] = hobbies;
    }

    setState(() {
      users = fetchedUsers;
    });
  }

  String calculateAge(String dateOfBirthString) {
    final DateTime dob = DateFormat('dd/MM/yyyy').parse(dateOfBirthString);
    final DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return '$age';
  }

  String formatHeight(String height) {
    final regex = RegExp(r'(\d+)ft (\d+)in');
    final match = regex.firstMatch(height);

    if (match != null) {
      String feet = match.group(1) ?? '0';
      String inches = match.group(2) ?? '0';
      return "$feet' $inches\"";
    }
    return height;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Swipe"),
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _pageController,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final Uint8List? photo = user['PHOTO'];

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  // Background image
                                  photo != null
                                      ? Image.memory(
                                          photo,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.person,
                                            size: 100,
                                            color: Colors.grey,
                                          ),
                                        ),

                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(
                                                0.4), // Darker at top
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black.withOpacity(
                                                0.6), // Darker at bottom
                                          ],
                                          stops: [0.0, 0.7, 1.0, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Text overlay
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user[FNAME]} ${user[LNAME][0]}' ??
                                              'No Name',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '${calculateAge(user[DATE_OF_BIRTH])} yrs, ${formatHeight(user[HEIGHT])}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '${user[DBConnect.COMMUNITY]}, ${user[DBConnect.SUB_COMMUNITY]} · ${user[DBConnect.STATE]}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, bottom: 10, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "About ${user[FNAME]} ${user[LNAME][0]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final updatedBio =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditBio(
                                                    currentBio:
                                                        user[BIO] ?? ''),
                                              ),
                                            );

                                            // Check if the bio was updated and is different from the current bio
                                            if (updatedBio != null &&
                                                updatedBio != user[BIO]) {
                                              // Update the bio in the user object
                                              user[BIO] = updatedBio;

                                              // Update the bio in the database
                                              await DBConnect.getInstance
                                                  .updateUser(
                                                user[USER_ID],
                                                {DBConnect.BIO: updatedBio},
                                              );

                                              // Refresh the UI
                                              setState(() {
                                                _loadUsers();
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.edit),
                                          color: Colors.cyan,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      user[BIO] ?? 'No description available',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: isExpanded ? null : 1,
                                      overflow: isExpanded
                                          ? null
                                          : TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isExpanded = !isExpanded;
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              isExpanded
                                                  ? "View Less "
                                                  : "View More ",
                                              style: TextStyle(
                                                color: Colors.cyan,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(
                                              isExpanded
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Colors.cyan,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Hobbies Section
                          // Hobbies Section
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Hobbies & Interest",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final updatedHobbies =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditHobbiesPage(
                                                  userId: user[USER_ID],
                                                ),
                                              ),
                                            );
                                            if (updatedHobbies != null &&
                                                user[INTERESTS] !=
                                                    updatedHobbies) {
                                              DBConnect.getInstance
                                                  .updateInterest(
                                                      user[DBConnect.USER_ID],
                                                      updatedHobbies);
                                              setState(() {
                                                _loadUsers();
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.cyan,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    if (user[INTERESTS] != null &&
                                        user[INTERESTS].isNotEmpty)
                                      Wrap(
                                        alignment: WrapAlignment.start,
                                        spacing: 8,
                                        runSpacing: 3,
                                        children: user[INTERESTS]
                                            .map<Widget>((hobbyName) {
                                          // Convert the hobby name to a Hobby enum
                                          Hobby? hobbyEnum =
                                              getHobbyEnumFromString(hobbyName);

                                          // Use the displayName property if the enum is found, otherwise use the raw hobby name
                                          String displayName =
                                              hobbyEnum?.displayName ??
                                                  hobbyName;

                                          // Use the icon from the enum if found, otherwise use a default icon
                                          IconData icon =
                                              hobbyEnum?.icon ?? Icons.star;

                                          return FilterChip(
                                            avatar: Icon(
                                              icon,
                                              size: 18,
                                              color: Color(0xFF8C2A60),
                                            ),
                                            label: Text(
                                              displayName, // Use the displayName or raw hobby name
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            ),
                                            backgroundColor: Colors.white,
                                            onSelected: (bool value) {},
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Basic Details Section
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Basic Details",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final updatedBasicDetails =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditBasicDetails(
                                                        user: user),
                                              ),
                                            );
                                            if (updatedBasicDetails != null) {
                                              updatedBasicDetails
                                                  .remove(INTERESTS);
                                              updatedBasicDetails
                                                  .remove('PHOTO');
                                              await DBConnect.getInstance
                                                  .updateUser(
                                                user[USER_ID],
                                                updatedBasicDetails,
                                              );

                                              // Refresh the UI
                                              setState(() {
                                                _loadUsers();
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.cyan,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24),
                                    _buildDetailRow(
                                      Icons.calendar_month,
                                      "Birth Date",
                                      "Born on ${user[DATE_OF_BIRTH]}",
                                      color1: 0xFF95D565,
                                      color2: 0xFF8AB165,
                                    ),
                                    SizedBox(height: 16),
                                    _buildDetailRow(
                                      Icons.person,
                                      "Marital Status",
                                      "${user[MARITAL_STATUS]}",
                                      color1: 0XFF95D565,
                                      color2: 0xFF8AB165,
                                    ),
                                    SizedBox(height: 16),
                                    _buildDetailRow(
                                      Icons.location_on,
                                      "Lives in",
                                      "Lives in ${user[LIVING_IN]}",
                                      color1: 0xFF95D565,
                                      color2: 0xFF8AB165,
                                    ),
                                    SizedBox(height: 16),
                                    _buildDetailRow(
                                      Icons.menu_book,
                                      "Religion & Mother Tongue",
                                      "${user[RELIGION]}, ${user[COMMUNITY]}",
                                      color1: 0xFF95D565,
                                      color2: 0xFF8AB165,
                                    ),
                                    SizedBox(height: 16),
                                    _buildDetailRow(
                                      Icons.groups_rounded,
                                      "Community",
                                      user[SUB_COMMUNITY],
                                      color1: 0xFF95D565,
                                      color2: 0xFF8AB165,
                                    ),
                                    SizedBox(height: 16),
                                    _buildDetailRow(
                                      Icons.restaurant_menu,
                                      "Diet Preferences",
                                      user[DIET],
                                      color1: 0xFF95D565,
                                      color2: 0xFF8AB165,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Contact details section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Contact Details",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final updatedContact =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditContactDetails(
                                                  user: user,
                                                ),
                                              ),
                                            );
                                            if (updatedContact != null) {
                                              updatedContact.remove(INTERESTS);
                                              updatedContact.remove('PHOTO');
                                              await DBConnect.getInstance
                                                  .updateUser(
                                                user[USER_ID],
                                                updatedContact,
                                              );

                                              // Refresh the UI
                                              setState(() {
                                                _loadUsers();
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.edit),
                                          color: Colors.cyan,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24),
                                    _buildDetailRow(
                                      Icons.call,
                                      "Contact No.",
                                      "+91 ${user[MOBILE]}",
                                      color1: 0xFFF44E42,
                                      color2: 0xFFF44E42,
                                    ),
                                    SizedBox(height: 16),
                                    _buildDetailRow(
                                      Icons.email_sharp,
                                      "Email ID",
                                      "${user[DBConnect.EMAIL]}",
                                      color1: 0xFFF44E42,
                                      color2: 0xFFF44E42,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),

                    // Edit and Delete Buttons (always visible)
                    Positioned(
                      bottom: 10,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Edit Button
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 3,
                              shadowColor: Colors.blue.withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.favorite_outlined,
                                    color: Colors.white),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                          // Delete Button
                          ElevatedButton(
                            onPressed: () {
                              // Show confirmation dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Row(
                                      children: [
                                        Icon(Icons.warning_amber_rounded,
                                            color: Colors.red, size: 28),
                                        SizedBox(width: 10),
                                        Text('Confirm Deletion'),
                                      ],
                                    ),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Are you sure you want to delete this user?',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'This action cannot be undone.',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Perform the delete operation
                                          DBConnect.getInstance
                                              .deleteUser(user[USER_ID]);

                                          // Close the dialog
                                          Navigator.pop(context);

                                          // Reload the user list
                                          setState(() {
                                            _loadUsers();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              shadowColor: Colors.red.withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value, {
    int color1 = 0,
    int color2 = 0,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(2.5, 1),
              colors: <Color>[
                Color(color1),
                Color(color2),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: 19,
            ),
          ),
        ),
        SizedBox(width: 12), // Space between icon and text

        // Text Details
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black45,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
