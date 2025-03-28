import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saathi/api/api_services.dart';
import 'package:saathi/database/local/const.dart';
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
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> users = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final fetchedUsers = await ApiService().getUsers(context);
    if (fetchedUsers != null) {
      setState(() => users = fetchedUsers.reversed.toList());
    }
  }

  String calculateAge(String dateOfBirthString) {
    final dob = DateFormat('dd/MM/yyyy').parse(dateOfBirthString);
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return '$age';
  }

  String formatHeight(String height) {
    final regex = RegExp(r'(\d+)ft (\d+)in');
    final match = regex.firstMatch(height);
    return match != null ? "${match.group(1)}' ${match.group(2)}\"" : height;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _UserProfileCard(user: user, loadUsers: _loadUsers);
        },
      ),
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function loadUsers;

  const _UserProfileCard({required this.user, required this.loadUsers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          _UserImageSection(user: user),
          _BioSection(user: user, loadUsers: loadUsers),
          _HobbiesSection(user: user, loadUsers: loadUsers),
          _BasicDetailsSection(user: user, loadUsers: loadUsers),
          _ContactDetailsSection(user: user, loadUsers: loadUsers),
          _ActionButtons(user: user, loadUsers: loadUsers),
        ],
      ),
    );
  }
}

class _UserImageSection extends StatelessWidget {
  final Map<String, dynamic> user;

  const _UserImageSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            user[IMAGE_URL] != null
                ? Image.network(user[IMAGE_URL], fit: BoxFit.fill)
                : Container(
              color: Colors.grey[200],
              child: const Icon(Icons.person, size: 100, color: Colors.grey),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.0, 0.7, 1.0, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user[FNAME]} ${user[LNAME][0]}',
                    style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_calculateAge(user[DATE_OF_BIRTH])} yrs, ${_formatHeight(user[HEIGHT])}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    '${user[COMMUNITY]}, ${user[SUB_COMMUNITY]} · ${user[STATE]}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAge(String dateOfBirthString) {
    final dob = DateFormat('dd/MM/yyyy').parse(dateOfBirthString);
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return '$age';
  }

  String _formatHeight(String height) {
    final regex = RegExp(r'(\d+)ft (\d+)in');
    final match = regex.firstMatch(height);
    return match != null ? "${match.group(1)}' ${match.group(2)}\"" : height;
  }
}

class _BioSection extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function loadUsers;

  const _BioSection({required this.user, required this.loadUsers});

  @override
  State<_BioSection> createState() => _BioSectionState();
}

class _BioSectionState extends State<_BioSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "About ${widget.user[FNAME]} ${widget.user[LNAME][0]}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _EditIcon(route: EditBio(user: widget.user), loadUsers: widget.loadUsers),
                ]
            ),
            const SizedBox(height: 12),
            Text(
              widget.user[BIO] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
              maxLines: _isExpanded ? null : 5,
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? "View Less " : "View More ",
                      style: const TextStyle(color: Color(0xFF3498DB), fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color(0xFF3498DB),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditIcon extends StatelessWidget {
  final Widget route;
  final Function loadUsers;
  const _EditIcon({required this.route, required this.loadUsers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF3498DB), // Flat blue color
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => route));
          loadUsers();
        },
        icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
        tooltip: "Edit data",
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function loadUsers;

  const _ActionButtons({required this.user, required this.loadUsers});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FavouriteButton(user: user, loadUsers: loadUsers),
          const SizedBox(width: 16),
          _RemoveUserButton(user: user, loadUsers: loadUsers),
        ],
      ),
    );
  }
}

class _FavouriteButton extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function loadUsers;

  const _FavouriteButton({required this.user, required this.loadUsers});

  @override
  State<_FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<_FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3498DB), // Flat blue color
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () async {
          widget.user[IS_FAVOURITE] = widget.user[IS_FAVOURITE] == '0' ? '1' :'0';
          ApiService().updateUser(map: widget.user, id: widget.user[ID], context: context);
          setState(() {});
        },
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(13),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        icon: Icon(
          widget.user[IS_FAVOURITE] == '0' ? Icons.favorite_outline_rounded : Icons.favorite_rounded,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}

class _RemoveUserButton extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function loadUsers;

  const _RemoveUserButton({required this.user, required this.loadUsers});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF34495E), // Dark slate color
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _showRemoveUserDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_remove_rounded, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                "Remove User",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated RemoveUserDialog with simpler colors
  void _showRemoveUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          elevation: 5,
          title: Row(
            children: [
              const Icon(Icons.person_remove_rounded, color: Color(0xFF34495E), size: 28),
              const SizedBox(width: 10),
              Text(
                'Remove User',
                style: TextStyle(color: const Color(0xFF333333), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to remove this user from the system?',
                  style: TextStyle(fontSize: 16, color: const Color(0xFF444444)),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF3498DB), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This action cannot be undone. All user data will be permanently removed.',
                          style: TextStyle(color: const Color(0xFF666666), fontSize: 14),
                        ),
                      ),
                    ],
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
                style: TextStyle(color: const Color(0xFF6C757D), fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF34495E), // Dark slate color
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  await ApiService().deleteUser(id: user[ID], context: context);
                  if (context.mounted) Navigator.pop(context);
                  loadUsers();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  'Remove User',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ContactDetailsSection extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function loadUsers;

  const _ContactDetailsSection({required this.user, required this.loadUsers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Contact Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _EditIcon(route: EditContactDetails(user: user), loadUsers: loadUsers,), // Reusable edit icon
                ],
              ),
              const SizedBox(height: 24),
              _DetailRow(
                icon: Icons.call,
                title: "Contact No.",
                value: "+91 ${user[MOBILE]}",
                color1: 0xFFF44E42,
                color2: 0xFFF44E42,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.email_sharp,
                title: "Email ID",
                value: "${user[EMAIL]}",
                color1: 0xFFF44E42,
                color2: 0xFFF44E42,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BasicDetailsSection extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function loadUsers;

  const _BasicDetailsSection({required this.user, required this.loadUsers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Basic Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _EditIcon(route: EditBasicDetails(user: user), loadUsers: loadUsers,), // Reusable edit icon
                ],
              ),
              const SizedBox(height: 24),
              _DetailRow(
                icon: Icons.calendar_month,
                title: "Birth Date",
                value: "Born on ${user[DATE_OF_BIRTH]}",
                color1: 0xFF95D565,
                color2: 0xFF8AB165,
              ),
              SizedBox(height: 16),
              _DetailRow(
                icon: Icons.person,
                title: "Marital Status",
                value: "${user[MARITAL_STATUS]}",
                color1: 0XFF95D565,
                color2: 0xFF8AB165,
              ),
              SizedBox(height: 16),
              _DetailRow(
                icon: Icons.location_on,
                title: "Lives in",
                value: "Lives in ${user[LIVING_IN]}",
                color1: 0xFF95D565,
                color2: 0xFF8AB165,
              ),
              SizedBox(height: 16),
              _DetailRow(
                icon: Icons.menu_book,
                title: "Religion & Mother Tongue",
                value: "${user[RELIGION]}, ${user[COMMUNITY]}",
                color1: 0xFF95D565,
                color2: 0xFF8AB165,
              ),
              SizedBox(height: 16),
              _DetailRow(
                icon: Icons.groups_rounded,
                title: "Community",
                value: user[SUB_COMMUNITY],
                color1: 0xFF95D565,
                color2: 0xFF8AB165,
              ),
              SizedBox(height: 16),
              _DetailRow(
                icon: Icons.restaurant_menu,
                title: "Diet Preferences",
                value: user[DIET],
                color1: 0xFF95D565,
                color2: 0xFF8AB165,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final int color1;
  final int color2;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
    this.color1 = 0,
    this.color2 = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Use a consistent color based on the section instead of gradients
    final Color iconColor = Color(color1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withOpacity(0.9),
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 19),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, color: Colors.black45),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HobbiesSection extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function loadUsers;

  const _HobbiesSection({required this.user, required this.loadUsers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hobbies & Interest",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _EditIcon(route: EditHobbiesPage(user: user), loadUsers: loadUsers), // Reusable edit icon
                ],
              ),
              const SizedBox(height: 10),
              if (user[HOBBIES] != null && user[HOBBIES].isNotEmpty)
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 3,
                  children: user[HOBBIES].split(' ').map<Widget>((hobbyName) {
                    final hobbyEnum = getHobbyEnumFromString(hobbyName);
                    final displayName = hobbyEnum?.displayName ?? hobbyName;
                    final icon = hobbyEnum?.icon ?? Icons.star;

                    return FilterChip(
                      avatar: Icon(icon, size: 18, color: const Color(0xFF8C2A60)),
                      label: Text(
                        displayName,
                        style: const TextStyle(color: Colors.black, fontSize: 13),
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
    );
  }
}