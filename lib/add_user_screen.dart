import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/user_list.dart';

class AddUser extends StatefulWidget {
  final UserList userList;
  final int? index;
  const AddUser({super.key, required this.userList, this.index});

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
  String? _selectCity = 'Select City';
  List<String> _selectHobbies = [];
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.index != null) {
      User user = widget.userList.getUserAt(widget.index!);
      _nameController.text = user.name;
      _emailController.text = user.email;
      _mobileNumberController.text = user.mobileNumber;
      _dobController.text = user.dob;
      _selectedGender = user.gender;
      _selectCity = user.city;
      _selectHobbies = user.hobbies;
      _passwordController.text = user.password;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textField(
                  _nameController,
                  label: 'Name',
                  hint: 'Enter your full name',
                  icon: Icons.person,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                _textField(
                  _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                _textField(
                  _mobileNumberController,
                  label: 'Mobile Number',
                  hint: 'Enter your phone number',
                  icon: Icons.phone,
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
                _datePicker(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your date of birth';
                    }
                    DateTime dob = DateFormat('dd/MM/yyyy').parse(value);
                    DateTime today = DateTime.now();
                    int age = today.year - dob.year;
                    if (dob.add(Duration(days: age * 365)).isAfter(today)) {
                      age--;
                    }
                    if (age < 18) {
                      return 'You must be at least 18 years old to register';
                    }
                    return null;
                  },
                ),
                _dropdownField(
                  options: [
                    'Rajkot',
                    'Surat',
                    'Ahmedabad',
                    'Baroda',
                    'Dang',
                    'Anand'
                  ],
                  onChanged: (value) => setState(() => _selectCity = value),
                ),
                _radioButton(
                  options: ['Male', 'Female', 'Other'],
                  groupedValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                _checkBoxes(),
                SizedBox(height: 10,),
                _textField(
                  _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock,
                  iconButton: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  obscureText: !_showPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                _textField(
                  _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter password',
                  icon: Icons.lock,
                  iconButton: IconButton(
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                    icon: Icon(_showConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  obscureText: !_showConfirmPassword,
                  validator: (value) {
                    if (_passwordController.text != value) {
                      return "Password not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding:
                      EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedGender == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select a gender')),
                          );
                          return;
                        }
                        if (_selectCity == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select a city')),
                          );
                          return;
                        }
                        if (_selectHobbies.length > 1 &&
                            _selectHobbies.contains('None')) {
                          _selectHobbies.remove('None');
                        }
                        final user = User(
                          name: _nameController.text,
                          email: _emailController.text,
                          mobileNumber: _mobileNumberController.text,
                          dob: _dobController.text,
                          gender: _selectedGender!,
                          city: _selectCity!,
                          hobbies: _selectHobbies,
                          password: _passwordController.text,
                          isFavourite: false,
                        );

                        if(widget.index!=null) {
                          widget.userList.addUserAt(widget.index!, user);
                        }
                        else {
                          widget.userList.addUser(user);
                        }
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller, {
        required String label,
        required String hint,
        required IconData icon,
        IconButton? iconButton,
        TextInputType keyboardType = TextInputType.text,
        TextCapitalization textCapitalization = TextCapitalization.none,
        bool obscureText = false,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textCapitalization: textCapitalization, // Corrected usage
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.redAccent),
          suffixIcon: iconButton,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _datePicker({String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        validator: validator,
        decoration: InputDecoration(
          labelText: "Date of Birth",
          prefixIcon: Icon(Icons.calendar_today, color: Colors.redAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onTap: () async {
          DateTime today = DateTime.now();
          DateTime firstDate = DateTime(today.year - 80, today.month, today.day);
          DateTime lastDate = DateTime(today.year - 18, today.month, today.day);

          DateTime? pickedDate = await showDatePicker(
            context: context,
            firstDate: firstDate,
            lastDate: lastDate,
            initialDate: _dobController.text.isEmpty?lastDate:DateFormat('dd/MM/yyyy').parse(_dobController.text),
          );
          if (pickedDate != null) {
            setState(() {
              _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            });
          }
        },
      ),
    );
  }

  Widget _dropdownField({
    required List<String> options,
    required Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: _selectCity,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _radioButton({
    required List<String> options,
    required String? groupedValue,
    required Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Column(  // Change from Row to Column
            children: options.map((gender) {
              return RadioListTile(
                title: Text(gender),
                value: gender,
                groupValue: groupedValue,
                onChanged: onChanged,
                activeColor: Colors.redAccent,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _checkBoxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hobbies',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...['Reading', 'Traveling', 'Gaming', 'Cooking', 'Playing']
            .map((hobby) {
          return CheckboxListTile(
            title: Text(hobby),
            value: _selectHobbies.contains(hobby),
            onChanged: (bool? selected) {
              setState(() {
                selected == true
                    ? _selectHobbies.add(hobby)
                    : _selectHobbies.remove(hobby);
              });
            },
            activeColor: Colors.redAccent,
          );
        }),
      ],
    );
  }
}