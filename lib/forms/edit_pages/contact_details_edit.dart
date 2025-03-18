import 'package:flutter/material.dart';
import 'package:saathi/api/api_services.dart';
import 'package:saathi/database/local/const.dart';
import 'package:saathi/forms/components/button.dart';
import 'package:saathi/forms/components/center_icon.dart';
import 'package:saathi/forms/components/text_fields.dart';

class EditContactDetails extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditContactDetails({super.key, required this.user});

  @override
  State<EditContactDetails> createState() => _EditContactDetailsState();
}

class _EditContactDetailsState extends State<EditContactDetails> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _mobileNumberFocusNode = FocusNode();

  bool _isButtonEnable = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _emailController.text = widget.user[EMAIL];
    _mobileNumberController.text = widget.user[MOBILE];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
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
    bool isMobileValid = _mobileNumberController.text.length == 10;

    setState(() => _isButtonEnable = isValid && isMobileValid);
  }

  void _onContinue() {
    if (formKey.currentState?.validate() ?? false) {
      widget.user[EMAIL] = _emailController.text;
      widget.user[MOBILE] = _mobileNumberController.text;
      Navigator.pop(context, widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center Icon Section
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: centerSvgIcon(
                    text:
                        'An active email ID & phone no. are required to secure your profile',
                    path: 'assets/images/form_icons/iconPageThree.svg',
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Email Section
              sectionTitle(title: 'Email'),
              const SizedBox(height: 20),
              textField(
                controller: _emailController,
                label: 'Email',
                focusNode: _emailFocusNode,
                nextFocusNode: _mobileNumberFocusNode,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                onChange: (value) => _validateForm(),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_mobileNumberFocusNode);
                },
              ),
              const SizedBox(height: 30),

              // Mobile Number Section
              sectionTitle(title: 'Mobile no.'),
              const SizedBox(height: 24),
              textField(
                controller: _mobileNumberController,
                label: 'Mobile no.',
                focusNode: _mobileNumberFocusNode,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                counterText: "",
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Mobile number is required';
                  if (value.length != 10)
                    return 'Enter a valid 10-digit mobile number';
                  return null;
                },
                onChange: (value) => _validateForm(),
                onFieldSubmitted: (_) {
                  _validateForm();
                },
              ),

              // Continue Button Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
                child: ContinueButton(
                  isLoading: _isLoading,
                  text: "Continue",
                  onPressed: _isButtonEnable
                      ? () async {
                          widget.user[EMAIL] = _emailController.text;
                          widget.user[MOBILE] = _mobileNumberController.text;
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isLoading = true;
                          });
                          await ApiService().updateUser(
                            context: context,
                            id: widget.user[ID],
                            map: widget.user,
                          );
                          _onContinue();
                        }
                      : null,
                  styleType: _isButtonEnable
                      ? ButtonStyleType.enable
                      : ButtonStyleType.disable,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
