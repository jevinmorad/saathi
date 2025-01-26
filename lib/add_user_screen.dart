import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textField(label: 'Full Name', hintText: 'Enter your full name'),
            SizedBox(
              height: 16,
            ),
            _textField(
                label: 'Email Address', hintText: 'Enter your email address', keyboardType: TextInputType.emailAddress),
            SizedBox(
              height: 16,
            ),
            _textField(
                label: 'Mobile number', hintText: 'Enter your mobile number', keyboardType: TextInputType.phone),
            SizedBox(
              height: 16,
            ),
            _textField(label: 'Date of Birth', hintText: 'DD/MM/YYYY', keyboardType: TextInputType.datetime),
            SizedBox(
              height: 16,
            ),
            _dropdownField(label: 'City', options: ['Rajkot', 'Surat', 'Ahmedabad', 'Baroda', 'Dang', 'Anand']),
            SizedBox(
              height: 16,
            ),
            _radioButtons(
                label: 'Gender', options: ['Male', 'Female', 'Other']),
            SizedBox(
              height: 16,
            ),
            _checkBoxes(label: 'Hobbies', options: ['Reading', 'Traveling', 'Gaming', 'Cooking', 'Playing']),
            SizedBox(
              height: 16,
            ),
            _textField(label: 'Password', hintText: 'Enter your password', obscureText: true),
            SizedBox(
              height: 16,
            ),
            _textField(
                label: 'Confirm password', hintText: 'Re-enter your password', obscureText: true),
            SizedBox(
              height: 32,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                onPressed: () {},
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({required String label, required String hintText, TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        TextField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField({required String label, required List<String> options}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: options.first,
              items: options.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? value) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _radioButtons({required String label, required List<String> options}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Column(
          children: options
              .map(
                (String option) => Row(
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: null,
                      onChanged: (String? value) {},
                    ),
                    Text(option),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _checkBoxes({required String label, required List<String> options}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Column(
          children: options.map((String option) => Row(
            children: [
              Checkbox(value: false, onChanged: (bool? value){}),
              Text(option),
            ],
          )).toList(),
        )
      ],
    );
  }
}
