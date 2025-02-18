import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final String selectedValue;
  final Function(String) onChange;

  const DropDown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChange,
    required this.hintText,
  });

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? _selectedValue;
  final TextEditingController _searchController = TextEditingController();
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
    _filteredItems = widget.items;
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close Button (Separate Line)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black38),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.hintText,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 16),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filteredItems = widget.items
                                .where((item) => item
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                  ),

                  // Divider
                  SizedBox(height: 10),
                  Divider(color: Colors.grey.shade300, thickness: 1),

                  // Options List with Smaller Height Constraint
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            0.5, // adjust as needed
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return Column(
                            children: [
                              ListTile(
                                title:
                                    Text(item, style: TextStyle(fontSize: 16)),
                                trailing: _selectedValue == item
                                    ? Icon(Icons.check, color: Colors.blue)
                                    : null,
                                onTap: () {
                                  setState(() => _selectedValue = item);
                                  widget.onChange(item);
                                  Navigator.pop(context);
                                },
                                visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -4),
                              ),
                              Divider(
                                  color: Colors.grey.shade200, thickness: 0.3),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedValue?.isNotEmpty == true
                  ? _selectedValue!
                  : widget.label,
              style: TextStyle(
                fontSize: 16,
                color: _selectedValue?.isNotEmpty == true
                    ? Colors.black
                    : Colors.black.withOpacity(0.5),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
