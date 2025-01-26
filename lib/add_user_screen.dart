import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  const AddUser({super.key});

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
                label: 'Email Address', hintText: 'Enter your email address'),
            SizedBox(
              height: 16,
            ),
            _textField(
                label: 'Mobile number', hintText: 'Enter your mobile number'),
            SizedBox(
              height: 16,
            ),
            _textField(label: 'Date of Birth', hintText: 'DD/MM/YYYY'),
            SizedBox(
              height: 16,
            ),
            _textField(label: 'City', hintText: 'Enter your city'),
            SizedBox(
              height: 16,
            ),
            _dropdownField(label: 'Gender', items: ['Male', 'Female', 'Other']),
            SizedBox(
              height: 16,
            ),
            _textField(label: 'Hobbies', hintText: 'Enter your hobbies'),
            SizedBox(
              height: 16,
            ),
            _textField(label: 'Password', hintText: 'Enter your password'),
            SizedBox(
              height: 16,
            ),
            _textField(
                label: 'Confirm password', hintText: 'Re-enter your password'),
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

  Widget _textField({required String label, required String hintText}) {
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

  Widget _dropdownField({required String label, required List<String> items}) {
    return Column(
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
              items: items.map((String item) {
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
}
