import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saathi/api/api_services.dart';
import 'package:saathi/database/local/const.dart';
import 'package:saathi/forms/components/button.dart';
import 'package:saathi/forms/components/center_icon.dart';
import 'package:saathi/forms/components/drop_down.dart';
import 'package:saathi/forms/components/radio_buttons.dart';
import 'package:saathi/forms/components/text_fields.dart';

class EditBasicDetails extends StatefulWidget {
  final Map<String, dynamic> user;
  const EditBasicDetails({super.key, required this.user});

  @override
  State<EditBasicDetails> createState() => _EditBasicDetailsState();
}

class _EditBasicDetailsState extends State<EditBasicDetails> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();

  bool _isLoading = false;

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
        widget.user[DATE_OF_BIRTH] = _dobController.text;
      });
    }
  }

  final List<String> religionOptions = [
    'Hindu',
    'Muslim',
    'Christian',
    'Jain',
    'Sikh',
    'Buddhist',
    'Parsi',
    'Jewish',
    'Other',
    'No Religion',
    'Spiritual - not religious'
  ];

  final List<String> communityOptions = [
    "Aka",
    "Arabic",
    "Arunachali",
    "Assamese",
    "Awadhi",
    "Baluchi",
    "Bhojpuri",
    "Bhutia",
    "Brahui",
    "Brij",
    "Burmese",
    "Chattisgarhi",
    "Chinese",
    "Coorgi",
    "Dogri",
    "French",
    "Garhwali",
    "Garo",
    "Haryanavi",
    "Himachali/Pahari",
    "Kashmiri",
    "Khandesi",
    "Khasi",
    "Konkani",
    "Kutchi",
    "Ladakhi",
    "Nepali",
    "Sindhi",
    "Sinhala",
    "Spanish",
    "Swedish",
    "Tagalog",
    "Tulu",
    "Other"
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

  @override
  void initState() {
    super.initState();

    _firstNameController.text = widget.user[FNAME];
    _lastNameController.text = widget.user[LNAME];
    _dobController.text = widget.user[DATE_OF_BIRTH];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
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
      
              // "Your Name" Section
              sectionTitle(title: 'Your Name'),
              SizedBox(height: 20),
              textField(
                controller: _firstNameController,
                label: 'First Name',
                focusNode: _firstNameFocus,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'First name is required';
                  return null;
                },
                onChange: (value) {
                  setState(() {
                    widget.user[FNAME] = value;
                  });
                },
              ),
              SizedBox(height: 22),
              textField(
                controller: _lastNameController,
                label: 'Last Name',
                focusNode: _lastNameFocus,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Last name is required';
                  return null;
                },
              ),
              SizedBox(height: 25),
      
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
                  if (value == null || value.trim().isEmpty) return 'Date of birth is required';
                  return null;
                },
              ),
              SizedBox(height: 25),
      
              // "Your Gender" Section
              sectionTitle(title: 'Your Gender'),
              const SizedBox(height: 15),
              radioButtons(
                options: const ['Male', 'Female'],
                selectedValue: widget.user[GENDER],
                onChange: (value) {
                  setState(() {
                    widget.user[GENDER] = value;
                  });
                },
              ),
              SizedBox(height: 25),
      
              // Religion Section
              sectionTitle(title: 'Your religion'),
              SizedBox(height: 25),
              DropDown(
                label: 'Religion',
                hintText: 'Select your religion',
                items: religionOptions,
                selectedValue: widget.user[RELIGION],
                onChange: (value) {
                  setState(() {
                    widget.user[RELIGION] = value;
                  });
                },
              ),
              SizedBox(height: 25),
      
              // Community Section
              sectionTitle(title: 'Community'),
              SizedBox(height: 25),
              DropDown(
                label: 'Community',
                hintText: 'Select your community',
                items: communityOptions,
                selectedValue: widget.user[COMMUNITY],
                onChange: (value) {
                  setState(() {
                    widget.user[COMMUNITY] = value;
                  });
                },
              ),
              SizedBox(height: 25),
      
              // Living In Section
              sectionTitle(title: 'Living in'),
              SizedBox(height: 25),
              DropDown(
                label: 'Country',
                hintText: 'Select where you are living',
                items: livingInOptions,
                selectedValue: widget.user[LIVING_IN],
                onChange: (value) {
                  setState(() {
                    widget.user[LIVING_IN] = value;
                  });
                },
              ),
              SizedBox(height: 25),

              // Marital Status
              sectionTitle(title: 'Marital Status'),
              SizedBox(height: 25),
              DropDown(
                label: 'Your Marital Status',
                hintText: 'Select your marital status',
                items: maritalStatusOptions,
                selectedValue: widget.user[MARITAL_STATUS],
                onChange: (value) {
                  setState(() {
                    widget.user[MARITAL_STATUS] = value;
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
                selectedValue: widget.user[HEIGHT],
                onChange: (value) {
                  setState(() {
                    widget.user[HEIGHT] = value;
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
                selectedValue: widget.user[DIET],
                onChange: (value) {
                  setState(() {
                    widget.user[DIET] = value;
                  });
                },
              ),
      
              // Continue Button Section
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                  child: ContinueButton(
                    text: "Continue",
                    styleType:  ButtonStyleType.enable,
                    isLoading: _isLoading,
                    onPressed: () async => {
                      setState(() => _isLoading = true),
                      widget.user[FNAME] = _firstNameController.text,
                      widget.user[LNAME] = _lastNameController.text,
                      widget.user[DATE_OF_BIRTH] = _dobController.text,
                      await ApiService().updateUser(context: context, id: widget.user[ID], map: widget.user),
                      if(context.mounted) Navigator.of(context).pop(),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
