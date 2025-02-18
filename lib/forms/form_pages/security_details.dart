import 'package:flutter/material.dart';
import 'package:saathi/forms/components/center_icon.dart';
import 'package:saathi/forms/components/text_fields.dart';
import '../../database/models/user_model.dart';
import '../components/button.dart';

class SecurityDetails extends StatefulWidget {
  final VoidCallback onContinue;

  const SecurityDetails({super.key, required this.onContinue});

  @override
  State<SecurityDetails> createState() => _SecurityDetailsState();
}

class _SecurityDetailsState extends State<SecurityDetails> {
  final UserModel user = UserModel.getInstance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _mobileNumberFocusNode = FocusNode();

  bool _isButtonEnable = false;
  bool _emailTouched = false;
  bool _mobileNumberTouched = false;

  @override
  void initState() {
    super.initState();

    _emailController.text = user.email;
    _mobileNumberController.text = user.mobile;

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        setState(() => _emailTouched = true);
        _validateForm();
      }
    });

    _mobileNumberFocusNode.addListener(() {
      if (!_mobileNumberFocusNode.hasFocus) {
        setState(() => _mobileNumberTouched = true);
        _validateForm();
      }
    });

    _validateForm();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileNumberController.dispose();
    _emailFocusNode.dispose();
    _mobileNumberFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    bool isValid = formKey.currentState?.validate() ?? false;
    setState(() => _isButtonEnable = isValid);
  }

  void _onContinue() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
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
            // Center Icon Section
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: centerSvgIcon(
                  text:
                  'An active email ID & phone no. are required to secure your profile',
                  path: 'assets/images/form_icons/iconPageThree.svg',
                ),
              ),
            ),
            SizedBox(height: 30),

            // Email Section
            sectionTitle(title: 'Email'),
            SizedBox(height: 20),
            textField(
              controller: _emailController,
              label: 'Email',
              focusNode: _emailFocusNode,
              nextFocusNode: _mobileNumberFocusNode,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (!_emailTouched) return null;
                if (value == null || value.isEmpty) return 'Email is required';
                if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                    .hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              onChange: (value) {
                user.email = value!;
                _validateForm();
              },
              onFieldSubmitted: (_) {
                setState(() => _emailTouched = true);
                FocusScope.of(context).requestFocus(_mobileNumberFocusNode);
              },
            ),
            SizedBox(height: 30),

            // Mobile Number Section
            sectionTitle(title: 'Mobile no.'),
            SizedBox(height: 24),
            textField(
              controller: _mobileNumberController,
              label: 'Mobile no.',
              focusNode: _mobileNumberFocusNode,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              counterText: "",
              validator: (value) {
                if (!_mobileNumberTouched) return null;
                if (value == null || value.isEmpty) return 'Mobile number is required';
                if (value.length != 10) return 'Enter a valid 10-digit mobile number';
                return null;
              },
              onChange: (value) {
                user.mobile = value!;
                _validateForm();
              },
            ),

            // Continue Button Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 40),
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