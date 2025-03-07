import 'package:flutter/material.dart';
import 'package:saathi/database/models/qualification_model.dart';
import 'package:saathi/forms/components/drop_down.dart';
import '../components/button.dart';
import '../components/center_icon.dart';
import '../components/text_fields.dart';

class QualificationDetails extends StatefulWidget {
  final VoidCallback onContinue;

  const QualificationDetails({super.key, required this.onContinue});

  @override
  State<QualificationDetails> createState() => _QualificationDetailsState();
}

class _QualificationDetailsState extends State<QualificationDetails> {
  final QualificationModel qualificationDetails = QualificationModel.getInstance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> qualificationOptions = [
    'B.E. / B.Tech',
    'M.E. / M.Tech',
    'PhD',
    'B.Sc.',
    'M.Sc.',
    'Diploma in Engineering',
    'BCA (Bachelor of Computer Applications)',
    'MCA (Master of Computer Applications)',
    'MBA (Master of Business Administration)',
    'BA / B.Com / BBA',
    'MA / M.Com / MBA',
    'Certification Courses',
    'Professional Qualifications (like CA, CFA)',
    'High School Diploma',
    'Postgraduate Diplomas'
  ];
  final TextEditingController _collegeController = TextEditingController();

  final FocusNode _collegeFocus = FocusNode();

  bool get isFormValid =>
      qualificationDetails.highestQualification.isNotEmpty;

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
                    path: 'assets/images/form_icons/iconPageTwo.png',
                    text: "Great! Few more details"
                ),
              ),
            ),
            SizedBox(height: 20),

            // Qualification Section
            sectionTitle(title: 'Highest Qualification'),
            SizedBox(height: 25),
            DropDown(
              label: 'your highest qualification',
              hintText: 'Select your highest qualification',
              items: qualificationOptions,
              selectedValue: qualificationDetails.highestQualification,
              onChange: (value) {
                setState(() {
                  qualificationDetails.highestQualification = value;
                });
                _validateForm();
              },
            ),
            SizedBox(height: 30),

            // College Section
            sectionTitle(title: 'College'),
            const SizedBox(height: 20),
            textField(
              controller: _collegeController,
              label: 'College',
              focusNode: _collegeFocus,
              textCapitalization: TextCapitalization.words,
              onChange: (value) {
                setState(() {
                  qualificationDetails.college = value!;
                });
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