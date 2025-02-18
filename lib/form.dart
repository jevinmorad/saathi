import 'package:flutter/material.dart';

class PersonalDetailsPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personal Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Please enter name" : null,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: "Gender"),
                items: ["Male", "Female", "Other"].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) {},
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Mobile"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Please enter mobile number" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "Please enter email" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationDetailsPage()),
                    );
                  }
                },
                child: Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationDetailsPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LocationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "City"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "State"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Country"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SuccessPage()),
                    );
                  }
                },
                child: Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Success")),
      body: Center(
        child: Text("Form submitted successfully!"),
      ),
    );
  }
}