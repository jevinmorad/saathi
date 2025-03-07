import 'package:flutter/material.dart';
import 'package:saathi/forms/components/button.dart';
import 'package:saathi/forms/components/center_icon.dart';
import 'package:saathi/forms/components/text_fields.dart';

class EditBio extends StatefulWidget {
  final String currentBio;

  const EditBio({super.key, required this.currentBio});

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  final FocusNode _bioFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _bioController.text = widget.currentBio;
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bio'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center Icon Section
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: centerSvgIcon(
                          path: 'assets/images/form_icons/iconPageOne.svg',
                          text: "Add a short description about you",
                        ),
                      ),
                    ),

                    // "About Yourself" Section
                    sectionTitle(title: 'About yourself'),
                    SizedBox(height: 20),
                    textField(
                      controller: _bioController,
                      label: 'Write about yourself here',
                      maxLength: 4000,
                      maxLine: 7,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bio name is required';
                        }
                        return null;
                      },
                      focusNode: _bioFocusNode,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Continue Button (fixed at the bottom)
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: ContinueButton(
              text: "Confirm",
              styleType: ButtonStyleType.enable,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('Returning updated bio: ${_bioController.text}');
                  Navigator.pop(context, _bioController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
