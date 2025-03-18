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

  bool _isButtonEnabled = false;
  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _dobTouched = false;

  @override
  void initState() {
    super.initState();

    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _dobController.text = user.dateOfBirth;

    _firstNameFocus.addListener(() {
      if (!_firstNameFocus.hasFocus) {
        setState(() => _firstNameTouched = true);
        _validateForm();
      }
    });

    _lastNameFocus.addListener(() {
      if (!_lastNameFocus.hasFocus) {
        setState(() => _lastNameTouched = true);
        _validateForm();
      }
    });

    _dobFocus.addListener(() {
      if (!_dobFocus.hasFocus) {
        setState(() => _dobTouched = true);
        _validateForm();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
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

  void _validateForm() {
    bool isValid = formKey.currentState?.validate() ?? false;
    bool isGenderSelected = user.gender.isNotEmpty;

    setState(() => _isButtonEnabled = isValid && isGenderSelected);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year - 80, now.month, now.day);
    DateTime lastDate = DateTime(now.year - 21, now.month, now.day);

    DateTime initialDate = lastDate;
    if (_dobController.text.trim().isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(_dobController.text);
      } catch (e) {
        initialDate = lastDate;
      }
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
        _validateForm();
      });
    }
  }

  void _onContinue() {
    if (formKey.currentState?.validate() ?? false) {
      user.firstName = _firstNameController.text.trim();
      user.lastName = _lastNameController.text.trim();
      widget.onContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25),
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
              validator: (value) {
                if (!_firstNameTouched) return null;
                if (value == null || value.trim().isEmpty) {
                  return 'First name is required';
                }
                return null;
              },
              onChange: (value) {
                setState(() {
                  user.firstName = value!;
                  _validateForm();
                });
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_lastNameFocus);
              },
            ),
            const SizedBox(height: 22),
            textField(
              controller: _lastNameController,
              label: 'Last Name',
              focusNode: _lastNameFocus,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (!_lastNameTouched) return null;
                if (value == null || value.trim().isEmpty) {
                  return 'Last name is required';
                }
                return null;
              },
              onChange: (value) {
                setState(() {
                  user.lastName = value!;
                  _validateForm();
                });
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
                if (!_dobTouched) return null;
                if (value == null || value.trim().isEmpty) {
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
                  _validateForm();
                });
              },
            ),

            // Continue Button Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              child: ContinueButton(
                text: "Continue",
                onPressed: _isButtonEnabled
                    ? () {
                        _onContinue();
                        FocusScope.of(context).unfocus();
                      }
                    : null,
                styleType: _isButtonEnabled
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
