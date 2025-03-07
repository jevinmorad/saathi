import 'package:flutter/material.dart';
import 'package:saathi/database/local/db_connection.dart';
import 'package:saathi/database/models/user_model.dart';

import '../components/button.dart';
import '../components/center_icon.dart';
import '../components/text_fields.dart';

class BioDetails extends StatefulWidget {
  final VoidCallback onContinue;
  const BioDetails({super.key, required this.onContinue});

  @override
  State<BioDetails> createState() => _BioDetailsState();
}

class _BioDetailsState extends State<BioDetails> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final UserModel user = UserModel.getInstance;

  DBConnect dbConnect = DBConnect.getInstance;

  final TextEditingController _bioController = TextEditingController();
  final FocusNode _bioFocus = FocusNode();

  Future<void> saveUserData() async {
    try {
      // Convert user model to map and insert into the database
      int userId = await dbConnect.insertUser(user.toMap());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User added successfully! ID: $userId")),
      );

      // Navigate to the next page or close the form
      widget.onContinue();
    } catch (error) {
      // Show error message if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving user: $error")),
      );
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
                padding: const EdgeInsets.only(bottom: 20),
                child: centerSvgIcon(
                  path: 'assets/images/form_icons/iconPageOne.svg',
                  text: "Add a short description about you",
                ),
              ),
            ),

            // "Your Name" Section
            sectionTitle(title: 'About yourself'),
            SizedBox(height: 20),
            textField(
              controller: _bioController,
              label: 'Write about yourself here',
              maxLength: 40000,
              maxLine: 7,
              focusNode: _bioFocus,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Bio name is required';
                }
                return null;
              },
              onChange: (value) {
                setState(() {
                  user.bio = value!;
                });
              },
            ),

            // Continue Button Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              child: ContinueButton(
                text: "Continue",
                styleType: ButtonStyleType.enable,
                onPressed: () async {
                  if(formKey.currentState!.validate()) {
                    await saveUserData();
                    widget.onContinue();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
