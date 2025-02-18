import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saathi/database/models/user_model.dart';
import '../components/button.dart';
import '../components/center_icon.dart';
import '../components/text_fields.dart';
import '../components/radio_buttons.dart';

class PersonalDetails extends StatefulWidget {
  final VoidCallback onContinue;

  const PersonalDetails({super.key, required this.onContinue});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final UserModel user = UserModel.getInstance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();

  // These flags control when error messages are shown.
  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _dobTouched = false;

  /// Computes form validity based solely on field values.
  bool get isFormValid =>
      _firstNameController.text.trim().isNotEmpty &&
          _lastNameController.text.trim().isNotEmpty &&
          _dobController.text.trim().isNotEmpty &&
          user.gender.isNotEmpty;

  @override
  void initState() {
    super.initState();

    // Pre-populate controllers with existing user data.
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _dobController.text = user.dateOfBirth;

    // Mark each field as "touched" when it loses focus.
    _firstNameFocus.addListener(() {
      if (!_firstNameFocus.hasFocus) {
        setState(() => _firstNameTouched = true);
      }
    });

    _lastNameFocus.addListener(() {
      if (!_lastNameFocus.hasFocus) {
        setState(() => _lastNameTouched = true);
      }
    });

    _dobFocus.addListener(() {
      if (!_dobFocus.hasFocus) {
        setState(() => _dobTouched = true);
      }
    });
  }

  /// Opens a date picker and updates the date of birth.
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year - 80, now.month, now.day);
    DateTime lastDate = DateTime(now.year - 21, now.month, now.day);

    DateTime initialDate;
    if (_dobController.text.trim().isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(_dobController.text);
      } catch (e) {
        initialDate = lastDate;
      }
    } else {
      initialDate = lastDate;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _dobController.text = formattedDate;
        user.dateOfBirth = formattedDate;
        _dobTouched = true;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _dobFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool formValid = isFormValid;
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
                padding: const EdgeInsets.only(bottom: 20),
                child: centerSvgIcon(
                  path: 'assets/images/form_icons/iconPageOne.svg',
                ),
              ),
            ),

            // "Your Name" Section
            sectionTitle(title: 'Your Name'),
            const SizedBox(height: 20),
            textField(
              controller: _firstNameController,
              label: 'First Name',
              focusNode: _firstNameFocus,
              nextFocusNode: _lastNameFocus,
              textCapitalization: TextCapitalization.words,
              // Show error only if this field was touched.
              validator: (value) {
                if (_firstNameTouched && (value == null || value.trim().isEmpty)) {
                  return 'First name is required';
                }
                return null;
              },
              onChange: (value) {
                setState(() {
                  user.firstName = value!;
                });
              },
              onFieldSubmitted: (value) {
                setState(() => _firstNameTouched = true);
                FocusScope.of(context).requestFocus(_lastNameFocus);
              },
            ),
            const SizedBox(height: 22),
            textField(
              controller: _lastNameController,
              label: 'Last Name',
              focusNode: _lastNameFocus,
              nextFocusNode: _dobFocus,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (_lastNameTouched && (value == null || value.trim().isEmpty)) {
                  return 'Last name is required';
                }
                return null;
              },
              onChange: (value) {
                setState(() {
                  user.lastName = value!;
                });
              },
              onFieldSubmitted: (value) {
                setState(() => _lastNameTouched = true);
              },
            ),
            const SizedBox(height: 24),

            // "Date of birth" Section
            sectionTitle(title: 'Date of birth'),
            const SizedBox(height: 20),
            textField(
              controller: _dobController,
              label: 'Date of Birth',
              focusNode: _dobFocus,
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: (value) {
                if (_dobTouched && (value == null || value.trim().isEmpty)) {
                  return 'Date of birth is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // "Your Gender" Section
            sectionTitle(title: 'Your Gender'),
            const SizedBox(height: 15),
            radioButtons(
              options: const ['Male', 'Female'],
              selectedValue: user.gender,
              onChange: (value) {
                setState(() {
                  user.gender = value;
                });
              },
            ),

            // Continue Button Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              child: ContinueButton(
                text: "Continue",
                onPressed: formValid
                    ? () {
                  FocusScope.of(context).unfocus();
                  widget.onContinue();
                }
                    : null,
                styleType: formValid
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