import 'package:flutter/material.dart';
import 'package:saathi/api/api_services.dart';
import 'package:saathi/database/local/const.dart';
import 'package:saathi/forms/components/button.dart';
import 'package:saathi/forms/components/hobby_icons.dart';
import 'package:saathi/forms/form_pages/hobbies_page.dart';

class EditHobbiesPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const EditHobbiesPage({super.key, required this.user});

  @override
  State<EditHobbiesPage> createState() => _EditHobbiesPageState();
}

class _EditHobbiesPageState extends State<EditHobbiesPage> {
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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedHobbies();
  }

  Future<void> _loadSelectedHobbies() async {
    // Fetch the user's selected hobbies
    final List<String> selectedHobbies = widget.user[HOBBIES].split(' ');

    // Mark the selected hobbies in the _categories list
    for (var category in _categories) {
      for (var interest in category.interests) {
        if (selectedHobbies.contains(interest.hobby.name)) {
          interest.selected = true;
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _saveSelectedHobbies() async {
    String selectedHobbies = _categories
        .expand((category) => category.interests)
        .where((interest) => interest.selected)
        .map((interest) => interest.hobby.name)
        .join(' ');

    widget.user[HOBBIES] = selectedHobbies;

    await ApiService()
        .updateUser(map: widget.user, id: widget.user[ID], context: context);

    Navigator.pop(context);
  }

  bool get _hasSelectedAny {
    return _categories
        .any((cat) => cat.interests.any((interest) => interest.selected));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
        child: ContinueButton(
          styleType: _hasSelectedAny
              ? ButtonStyleType.enable
              : ButtonStyleType.disable,
          isLoading: _isLoading,
          onPressed: _hasSelectedAny
              ? () => {
                    setState(() => _isLoading = true),
                    _saveSelectedHobbies(),
                  }
              : null,
          text: 'Continue',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
