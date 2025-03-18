import 'package:flutter/material.dart';
import 'package:saathi/api/api_services.dart';
import 'package:saathi/database/models/user_model.dart';
import 'package:saathi/forms/components/button.dart';
import 'package:saathi/forms/components/hobby_icons.dart';
import 'package:saathi/screens/dashboard_screen.dart';

class HobbiesPage extends StatefulWidget {
  final VoidCallback onContinue;
  const HobbiesPage({super.key, required this.onContinue});

  @override
  State<HobbiesPage> createState() => _HobbiesPageState();
}

class _HobbiesPageState extends State<HobbiesPage> {
  UserModel user = UserModel.getInstance;
  bool _isLoading = false;

  final List<InterestCategory> _categories = [
    InterestCategory(
      title: 'Creative',
      interests: [
        Interest(hobby: Hobby.writing),
        Interest(hobby: Hobby.cooking),
        Interest(hobby: Hobby.singing),
        Interest(hobby: Hobby.photography),
        Interest(hobby: Hobby.playingInstruments),
        Interest(hobby: Hobby.painting),
        Interest(hobby: Hobby.diyCrafts),
        Interest(hobby: Hobby.acting),
        Interest(hobby: Hobby.poetry),
        Interest(hobby: Hobby.gardening),
        Interest(hobby: Hobby.blogging),
        Interest(hobby: Hobby.contentCreation),
        Interest(hobby: Hobby.designing),
      ],
    ),
    InterestCategory(
      title: 'Fun',
      interests: [
        Interest(hobby: Hobby.movies),
        Interest(hobby: Hobby.music),
        Interest(hobby: Hobby.travelling),
        Interest(hobby: Hobby.reading),
        Interest(hobby: Hobby.sports),
        Interest(hobby: Hobby.socialMedia),
        Interest(hobby: Hobby.gaming),
        Interest(hobby: Hobby.bingeWatching),
        Interest(hobby: Hobby.biking),
        Interest(hobby: Hobby.clubbing),
        Interest(hobby: Hobby.shopping),
        Interest(hobby: Hobby.standUps),
      ],
    ),
    InterestCategory(
      title: 'Fitness',
      interests: [
        Interest(hobby: Hobby.running),
        Interest(hobby: Hobby.cycling),
        Interest(hobby: Hobby.yogaMeditation),
        Interest(hobby: Hobby.walking),
        Interest(hobby: Hobby.workingOut),
        Interest(hobby: Hobby.trekking),
        Interest(hobby: Hobby.swimming),
      ],
    ),
    InterestCategory(
      title: 'Other Interests',
      interests: [
        Interest(hobby: Hobby.pets),
        Interest(hobby: Hobby.foodie),
        Interest(hobby: Hobby.newsPolitics),
        Interest(hobby: Hobby.socialServices),
        Interest(hobby: Hobby.homeDecor),
        Interest(hobby: Hobby.investments),
      ],
    ),
  ];

  // Check how many total items are selected
  bool get _hasSelectedAny {
    return _categories
        .any((cat) => cat.interests.any((interest) => interest.selected));
  }

  Future<void> saveSelectedHobbies() async {
    user.hobbies = _categories
        .expand((category) => category.interests)
        .where((interest) => interest.selected)
        .map((interest) => interest.hobby.name)
        .join(' ');

    await saveModelData();
    return;
  }

  Future<void> saveModelData() async {
    await ApiService().addUser(context: context, map: user.toMap());
    user.clear();
    return;
  }

  Future<void> _onContinue() async {
    setState(() {
      _isLoading = true;
    });
    await saveSelectedHobbies();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title text
                  Text(
                    "Now let's add your hobbies & interests",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "This will help find better Matches",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  // Build each category
                  ..._categories.map((category) {
                    return _buildCategoryCard(category);
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
            child: ContinueButton(
              text: _isLoading ? '' : 'Continue',
              styleType: _hasSelectedAny
                  ? ButtonStyleType.enable
                  : ButtonStyleType.disable,
              onPressed: _hasSelectedAny && !_isLoading ? _onContinue : null,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(InterestCategory category) {
    int visibleItemCount = 4;
    bool showViewMore = category.interests.length > visibleItemCount;
    int displayedCount = category.expanded
        ? category.interests.length
        : visibleItemCount.clamp(0, category.interests.length);

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Title
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),

              Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 3,
                children: category.interests
                    .take(displayedCount)
                    .map(
                      (interest) => FilterChip(
                    avatar: Icon(
                      interest.icon,
                      size: 18,
                      color: interest.selected
                          ? Colors.white
                          : Color(0xFF8C2A60),
                    ),
                    label: Text(
                      interest.name,
                      style: TextStyle(
                        color:
                        interest.selected ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: interest.selected,
                    selectedColor: Color(0xFF8C2A60),
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      setState(() {
                        interest.selected = selected;
                      });
                    },
                  ),
                )
                    .toList(),
              ),

              // "View more" (only if not expanded and there's more to show)
              if (!category.expanded && showViewMore)
                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    label: Text(
                      'View more',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      setState(() {
                        category.expanded = true;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class InterestCategory {
  final String title;
  final List<Interest> interests;
  bool expanded;

  InterestCategory({
    required this.title,
    required this.interests,
    this.expanded = false,
  });
}

class Interest {
  final Hobby hobby;
  bool selected;

  Interest({required this.hobby, this.selected = false});

  String get name => hobby.displayName;

  IconData get icon => hobby.icon;
}