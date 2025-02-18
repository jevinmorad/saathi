import 'package:flutter/cupertino.dart';
import 'package:saathi/database/models/user_model.dart';

import '../components/button.dart';
import '../components/center_icon.dart';
import '../components/drop_down.dart';
import '../components/text_fields.dart';

class LivingDetails extends StatefulWidget {
  final VoidCallback onContinue;
  const LivingDetails({super.key, required this.onContinue});

  @override
  State<LivingDetails> createState() => _LivingDetailsState();
}

class _LivingDetailsState extends State<LivingDetails> {
  final UserModel user = UserModel.getInstance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> stateOptions = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];

  List<String> cityOptions = [
    "Ahmedabad",
    "Surat",
    "Vadodara",
    "Rajkot",
    "Gandhinagar",
    "Bhavnagar",
    "Jamnagar",
    "Junagadh",
    "Anand",
    "Nadiad",
    "Bharuch",
    "Valsad",
    "Navsari",
    "Morbi",
    "Gandhidham",
    "Bhuj",
    "Porbandar",
    "Mehsana",
    "Palanpur",
    "Veraval",
    "Amreli",
    "Surendranagar",
    "Dahod",
    "Godhra",
    "Patan",
    "Botad",
    "Modasa",
    "Deesa",
    "Dwarka",
    "Somnath",
  ];

  List<String> subCommunityOptions = [
    "Patel - Leuva",
    "Patel - Kadva",
    "Brahmin - Iyer",
    "Brahmin - Iyengar",
    "Brahmin - Deshastha",
    "Brahmin - Chitpavan",
    "Brahmin - Saraswat",
    "Brahmin - Maithil",
    "Koli - Talpada Koli",
    "Koli - Pateliya Koli",
    "Rajput - Chauhan",
    "Rajput - Solanki",
    "Rajput - Sisodia",
    "Rajput - Rathore",
    "Maratha - Deshmukh",
    "Maratha - Shinde",
    "Maratha - Jadhav",
    "Lingayat - Sadar",
    "Lingayat - Banajiga",
    "Lingayat - Pancham",
    "Chaudhary - Anjana",
    "Chaudhary - Desai",
    "Chaudhary - Patel",
    "Yadav - Krishnaut",
    "Yadav - Gwala",
    "Yadav - Ahir",
    "Jat - Malik",
    "Jat - Dahiya",
    "Jat - Dhillon",
    "Jat - Mann",
  ];

  bool _isButtonEnable = false;

  @override
  void initState() {
    super.initState();
    _checkIfReturningUser();
  }

  /// If the user is coming back, enable the continue button
  void _checkIfReturningUser() {
    bool hasExistingData = user.state.isNotEmpty &&
        user.city.isNotEmpty &&
        user.subCommunity.isNotEmpty;
    setState(() => _isButtonEnable = hasExistingData);
  }

  void _validateForm() {
    bool isValid = user.state.isNotEmpty &&
        user.city.isNotEmpty &&
        user.subCommunity.isNotEmpty;
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
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: centerPngIcon(
                    path: 'assets/images/form_icons/iconPageTwo.png'),
              ),
            ),
            SizedBox(height: 20),
            sectionTitle(title: 'State'),
            SizedBox(height: 25),
            DropDown(
              label: 'State you live in',
              hintText: 'Select state you live in',
              items: stateOptions,
              selectedValue: user.state,
              onChange: (value) {
                setState(() {
                  user.state = value;
                  _validateForm();
                });
              },
            ),
            SizedBox(height: 30),
            sectionTitle(title: 'City'),
            SizedBox(height: 25),
            DropDown(
              label: 'City you live in',
              hintText: 'Select city you live in',
              items: cityOptions,
              selectedValue: user.city,
              onChange: (value) {
                setState(() {
                  user.city = value;
                  _validateForm();
                });
              },
            ),
            SizedBox(height: 30),
            sectionTitle(title: 'Sub-community'),
            SizedBox(height: 25),
            DropDown(
              label: 'Your Sub-Community',
              hintText: 'Select your sub-community',
              items: subCommunityOptions,
              selectedValue: user.subCommunity,
              onChange: (value) {
                setState(() {
                  user.subCommunity = value;
                  _validateForm();
                });
              },
            ),
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
