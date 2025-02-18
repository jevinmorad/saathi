import 'package:flutter/material.dart';
import 'package:saathi/database/models/user_model.dart';

import '../components/button.dart';
import '../components/center_icon.dart';
import '../components/drop_down.dart';
import '../components/text_fields.dart';

class MaritalStatus extends StatefulWidget {
  final VoidCallback onContinue;
  const MaritalStatus({super.key, required this.onContinue});

  @override
  State<MaritalStatus> createState() => _MaritalStatusState();
}

class _MaritalStatusState extends State<MaritalStatus> {
  final UserModel user = UserModel.getInstance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> maritalStatusOptions = [
    'Never Married',
    'Divorced',
    'Widowed',
    'Awaiting Divorce',
    'Annulled',
  ];
  List<String> heightOptions = [
    '4ft 5in - 134cm',
    '4ft 6in - 137cm',
    '4ft 7in - 139cm',
    '4ft 8in - 142cm',
    '4ft 9in - 144cm',
    '4ft 10in - 147cm',
    '4ft 11in - 149cm',
    '5ft - 152cm',
    '5ft 1in - 154cm',
    '5ft 2in - 157cm',
    '5ft 3in - 160cm',
    '5ft 4in - 163cm',
    '5ft 5in - 165cm',
    '5ft 6in - 168cm',
    '5ft 7in - 170cm',
    '5ft 8in - 173cm',
    '5ft 9in - 175cm',
    '5ft 10in - 178cm',
    '5ft 11in - 180cm',
    '6ft - 182cm',
    '6ft 1in - 185cm',
    '6ft 2in - 188cm',
    '6ft 3in - 191cm',
    '6ft 4in - 193cm',
    '6ft 5in - 196cm',
    '6ft 6in - 198cm',
    '6ft 7in - 201cm',
    '6ft 8in - 203cm',
    '6ft 9in - 206cm',
    '6ft 10in - 208cm',
    '6ft 11in - 211cm',
    '7ft - 213cm',
  ];
  List<String> dietOptions = [
    'Veg',
    'Non-Veg',
    'Occasionally Non-Veg',
    'Eggetarian',
    'Jain',
    'Vegan',
  ];

  bool _isButtonEnable = false;

  @override
  void initState() {
    super.initState();
    if(user!=null) {
      _checkIfReturningUser();
    }
  }

  /// Enable "Continue" if user has already filled details before
  void _checkIfReturningUser() {
    bool hasExistingData = user.maritalStatus.isNotEmpty &&
        user.height.isNotEmpty &&
        user.diet.isNotEmpty;
    setState(() => _isButtonEnable = hasExistingData);
  }

  void _validateForm() {
    bool isValid = user.maritalStatus.isNotEmpty &&
        user.height.isNotEmpty &&
        user.diet.isNotEmpty;
    setState(() => _isButtonEnable = isValid);
  }

  void _onContinue() {
    if (_isButtonEnable) {
      widget.onContinue();
    }
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
            // Center Icon
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: centerPngIcon(
                    path: 'assets/images/form_icons/iconPageTwo.png'),
              ),
            ),
            SizedBox(height: 20),

            // Marital Status
            sectionTitle(title: 'Marital Status'),
            SizedBox(height: 25),
            DropDown(
              label: 'Your Marital Status',
              hintText: 'Select your marital status',
              items: maritalStatusOptions,
              selectedValue: user.maritalStatus,
              onChange: (value) {
                setState(() {
                  user.maritalStatus = value;
                  _validateForm();
                });
              },
            ),
            SizedBox(height: 30),

            // Height
            sectionTitle(title: 'Height'),
            SizedBox(height: 25),
            DropDown(
              label: 'Your Height',
              hintText: 'Select your height',
              items: heightOptions,
              selectedValue: user.height,
              onChange: (value) {
                setState(() {
                  user.height = value;
                  _validateForm();
                });
              },
            ),
            SizedBox(height: 30),

            // Diet
            sectionTitle(title: 'Diet'),
            SizedBox(height: 25),
            DropDown(
              label: 'Your Diet',
              hintText: 'Select your diet',
              items: dietOptions,
              selectedValue: user.diet,
              onChange: (value) {
                setState(() {
                  user.diet = value;
                  _validateForm();
                });
              },
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              child: ContinueButton(
                text: "Continue",
                onPressed: _isButtonEnable ? _onContinue : null,
                styleType: _isButtonEnable
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
