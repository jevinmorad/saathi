import 'package:flutter/material.dart';
import 'package:saathi/forms/form_pages/bio_details.dart';
import 'package:saathi/forms/form_pages/hobbies_page.dart';
import 'package:saathi/forms/form_pages/living_details.dart';
import 'package:saathi/forms/form_pages/marital_status.dart';
import 'package:saathi/forms/form_pages/personal_details.dart';
import 'package:saathi/forms/form_pages/profile_photo.dart';
import 'package:saathi/forms/form_pages/religion_details.dart';
import 'package:saathi/forms/form_pages/security_details.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage++;
    });
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _currentPage > 0
            ? IconButton(
                onPressed: _previousPage,
                icon: Icon(Icons.arrow_back_sharp),
              )
            : null,
      ),
      body: Column(
        children: [
          Flexible(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                PersonalDetails(onContinue: _nextPage),
                SecurityDetails(onContinue: _nextPage),
                ReligionDetails(onContinue: _nextPage),
                LivingDetails(onContinue: _nextPage),
                MaritalStatus(onContinue: _nextPage),
                BioDetails(onContinue: _nextPage),
                ProfilePhoto(onContinue: _nextPage),
                HobbiesPage(onContinue: _nextPage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}