import 'package:flutter/material.dart';
import 'package:saathi/database/models/user_model.dart';
import 'package:saathi/forms/components/drop_down.dart';
import '../components/button.dart';
import '../components/center_icon.dart';
import '../components/text_fields.dart';

class ReligionDetails extends StatefulWidget {
  final VoidCallback onContinue;

  const ReligionDetails({super.key, required this.onContinue});

  @override
  State<ReligionDetails> createState() => _ReligionDetailsState();
}

class _ReligionDetailsState extends State<ReligionDetails> {
  final UserModel user = UserModel.getInstance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> religionOptions = [
    'Hindu', 'Muslim', 'Christian', 'Jain', 'Sikh', 'Buddhist', 'Parsi',
    'Jewish', 'Other', 'No Religion', 'Spiritual - not religious'
  ];

  final List<String> communityOptions = [
    "Aka", "Arabic", "Arunachali", "Assamese", "Awadhi", "Baluchi", "Bhojpuri",
    "Bhutia", "Brahui", "Brij", "Burmese", "Chattisgarhi", "Chinese", "Coorgi",
    "Dogri", "French", "Garhwali", "Garo", "Haryanavi", "Himachali/Pahari",
    "Kashmiri", "Khandesi", "Khasi", "Konkani", "Kutchi", "Ladakhi", "Nepali",
    "Sindhi", "Sinhala", "Spanish", "Swedish", "Tagalog", "Tulu", "Other"
  ];

  final List<String> livingInOptions = [
    "India",
    "United States",
    "Canada",
    "United Kingdom",
    "Australia",
    "Germany",
    "France",
    "UAE",
    "Pakistan",
    "Bangladesh",
    "Nepal",
    "Sri Lanka",
    "Saudi Arabia",
    "Malaysia",
    "Singapore",
    "South Africa",
    "Other"
  ];

  bool _religionTouched = false;
  bool _communityTouched = false;
  bool _livingInTouched = false;

  bool get isFormValid =>
      user.religion.isNotEmpty &&
          user.community.isNotEmpty &&
          user.livingIn.isNotEmpty;

  void _validateForm() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center Icon Section
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: centerPngIcon(
                    path: 'assets/images/form_icons/iconPageTwo.png'),
              ),
            ),
            SizedBox(height: 20),

            // Religion Section
            sectionTitle(title: 'Your religion'),
            SizedBox(height: 25),
            DropDown(
              label: 'Religion',
              hintText: 'Select your religion',
              items: religionOptions,
              selectedValue: user.religion,
              onChange: (value) {
                setState(() {
                  user.religion = value;
                  _religionTouched = true;
                });
                _validateForm();
              },
            ),
            SizedBox(height: 30),

            // Community Section
            sectionTitle(title: 'Community'),
            SizedBox(height: 25),
            DropDown(
              label: 'Community',
              hintText: 'Select your community',
              items: communityOptions,
              selectedValue: user.community,
              onChange: (value) {
                setState(() {
                  user.community = value;
                  _communityTouched = true;
                });
                _validateForm();
              },
            ),
            SizedBox(height: 30),

            // Living In Section
            sectionTitle(title: 'Living in'),
            SizedBox(height: 25),
            DropDown(
              label: 'Country',
              hintText: 'Select where you are living',
              items: livingInOptions,
              selectedValue: user.livingIn,
              onChange: (value) {
                setState(() {
                  user.livingIn = value;
                  _livingInTouched = true;
                });
                _validateForm();
              },
            ),

            // Continue Button Section
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 40, horizontal: 40),
              child: ContinueButton(
                text: "Continue",
                onPressed: isFormValid ? () => widget.onContinue() : null,
                styleType: isFormValid
                    ? ButtonStyleType.enable
                    : ButtonStyleType.disable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}