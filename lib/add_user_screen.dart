import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/user_list.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedGender;
  String? _selectCity;
  List<String> _selectHobbies = [];

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField(
                controller: _nameController,
                label: 'Name',
                hintText: 'Enter your full name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _textField(
                controller: _emailController,
                label: 'Email Address',
                hintText: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                      .hasMatch(value)) {
                    return 'Enter a valid email address.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _textField(
                controller: _mobileNumberController,
                label: 'Mobile number',
                hintText: 'Enter your mobile number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile number is required';
                  } else if (!RegExp(r"^\+?[0-9]{10,15}").hasMatch(value)) {
                    return 'Enter a valid mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _datePickerField(
                label: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                controller: _dobController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date of Birth is required.';
                  }
                  final parts = value.split('/');
                  final day = int.parse(parts[0]);
                  final month = int.parse(parts[1]);
                  final year = int.parse(parts[2]);
                  final dob = DateTime(year, month, day);
                  final today = DateTime.now();
                  final age = today.difference(dob).inDays ~/ 365;
                  if (age < 18 || age > 80) {
                    return 'Age must be between 18 and 80 years.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _dropdownField(
                label: 'City',
                options: [
                  'Rajkot',
                  'Surat',
                  'Ahmedabad',
                  'Baroda',
                  'Dang',
                  'Anand'
                ],
                onChanged: (value) {
                  setState(() {
                    _selectCity = value;
                  });
                },
                validator: (value) {
                  if (value == 'Select City' || value == null) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _radioButtons(
                label: 'Gender',
                options: ['Male', 'Female', 'Other'],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              SizedBox(height: 16),
              _checkBoxes(
                label: 'Hobbies',
                options: [
                  'Reading',
                  'Traveling',
                  'Gaming',
                  'Cooking',
                  'Playing'
                ],
                onChange: (value) {
                  setState(
                    () {
                      _selectHobbies = value;
                    },
                  );
                },
              ),
              SizedBox(height: 16),
              _textField(
                controller: _passwordController,
                label: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _textField(
                controller: _confirmPasswordController,
                label: 'Confirm password',
                hintText: 'Re-enter your password',
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Password do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final user = User(
                        name: _nameController.text,
                        email: _emailController.text,
                        mobileNumber: _mobileNumberController.text,
                        dob: _dobController.text,
                        gender: _selectedGender!,
                        city: _selectCity!,
                        hobbies: _selectHobbies,
                        password: _passwordController.text,
                      );

                      final userList = UserList();
                      print(user);
                      userList.addUser(user);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ],
    );
  }

  Widget _datePickerField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async {
            DateTime? pickDate = await showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
            );
            if (pickDate != null) {
              String formattedDate = DateFormat('dd/MM/yyyy').format(pickDate);
              setState(() {
                controller.text = formattedDate;
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              validator: validator,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.calendar_today),
                hintText: controller.text.isEmpty
                    ? 'Tap to select date'
                    : controller.text,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required List<String> options,
    required Function(String?)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: options.first,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _radioButtons({
    required String label,
    required List<String> options,
    required Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Column(
          children: options.map((String option) {
            return Row(
              children: [
                Radio<String>(
                  value: option,
                  groupValue: _selectedGender,
                  onChanged: onChanged,
                ),
                Text(option),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _checkBoxes({
    required String label,
    required List<String> options,
    required Function(List<String>)? onChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Column(
          children: options
              .map((String option) => Row(
                    children: [
                      Checkbox(
                        value: _selectHobbies.contains(option),
                        onChanged: (bool? value) {
                          if (value == true) {
                            _selectHobbies.add(option);
                          } else {
                            _selectHobbies.remove(option);
                          }
                          onChange?.call(_selectHobbies);
                        },
                      ),
                      Text(option),
                    ],
                  ))
              .toList(),
        )
      ],
    );
  }
}
