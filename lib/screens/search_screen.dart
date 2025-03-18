import 'package:flutter/material.dart';
import 'package:saathi/forms/components/button.dart';
import 'package:saathi/forms/components/drop_down.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  double _minAge = 21;
  double _maxAge = 37;
  double _minHeight = 4.5;
  double _maxHeight = 7.0;

  List<String> maritalStatusOptions = [
    "Doesn't Matter",
    'Never Married',
    'Divorced',
    'Widowed',
    'Awaiting Divorce',
    'Annulled',
  ];
  List<String> dietOptions = [
    "Doesn't Matter",
    'Veg',
    'Non-Veg',
    'Occasionally Non-Veg',
    'Eggetarian',
    'Jain',
    'Vegan',
  ];
  final List<String> livingInOptions = [
    "Doesn't Matter",
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
  final List<String> religionOptions = [
    "Doesn't Matter",
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
    "Doesn't Matter",
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

  String maritalStatus = "Doesn't Matter";
  String diet = "Doesn't Matter";
  String religion = "Doesn't Matter";
  String community = "Doesn't Matter";
  String livingIn = "Doesn't Matter";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF2C3E50),
          elevation: 5,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextFormField(
                cursorColor: Colors.cyan,
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personalize your search",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Age Range
            _buildRangeSlider(
              title: "Age",
              min: 18,
              max: 60,
              currentMin: _minAge,
              currentMax: _maxAge,
              onChanged: (start, end) {
                setState(() {
                  _minAge = start;
                  _maxAge = end;
                });
              },
              unit: "yrs",
            ),

            // Height Range
            _buildRangeSlider(
              title: "Height",
              min: 4.0,
              max: 7.0,
              currentMin: _minHeight,
              currentMax: _maxHeight,
              onChanged: (start, end) {
                setState(() {
                  _minHeight = start;
                  _maxHeight = end;
                });
              },
              unit: "\"",
            ),

            // Dropdowns
            _buildDropdown(
              title: 'Marital Status',
              items: maritalStatusOptions,
              onChanged: (value) => {
                setState(() => maritalStatus = value!),
              },
              selectedValue: maritalStatus,
            ),

            _buildDropdown(
              title: 'Diet',
              items: dietOptions,
              selectedValue: diet,
              onChanged: (value) => {
                setState(() => diet = value!),
              },
            ),

            _buildDropdown(
              title: "Living in",
              items: livingInOptions,
              onChanged: (val) {
                setState(() => livingIn = val!);
              },
              selectedValue: livingIn,
            ),

            _buildDropdown(
              title: "Religion",
              items: religionOptions,
              onChanged: (val) {
                setState(() => religion = val!);
              },
              selectedValue: religion,
            ),

            _buildDropdown(
              title: "Community",
              items: communityOptions,
              onChanged: (val) {
                setState(() => community = val!);
              },
              selectedValue: community,
            ),

            // Search Now Button
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 17,
                horizontal: 30,
              ),
              child: ContinueButton(text: 'Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle({required String title}) {
    return Text(
      title,
      style: TextStyle(color: Colors.black45, fontSize: 15),
    );
  }

  Widget _buildRangeSlider({
    required String title,
    required double min,
    required double max,
    required double currentMin,
    required double currentMax,
    required Function(double, double) onChanged,
    required String unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title: title),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Min ${currentMin.toInt()} $unit"),
            Text("Max ${currentMax.toInt()} $unit"),
          ],
        ),
        RangeSlider(
          min: min,
          max: max,
          values: RangeValues(currentMin, currentMax),
          onChanged: (RangeValues values) {
            onChanged(values.start, values.end);
          },
          activeColor: Colors.cyan,
          inactiveColor: Colors.grey.shade300,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdown({
    required String title,
    required List<String> items,
    required String selectedValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title: title),
        SizedBox(height: 5),
        DropDown(
          label: title,
          hintText: 'Select preferred $title',
          items: items,
          selectedValue: selectedValue,
          onChange: onChanged,
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
