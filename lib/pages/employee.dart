import 'package:flutter/material.dart';
import 'package:my_app/service/database.dart';
import 'package:random_string/random_string.dart';

class Employee extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? employeeData;

  const Employee({
    Key? key,
    this.isEdit = false,
    this.employeeData,
  }) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late String employeeId;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.employeeData != null) {
      nameController.text = widget.employeeData!['name'];
      ageController.text = widget.employeeData!['age'];
      addressController.text = widget.employeeData!['address'];
      employeeId = widget.employeeData!['id'];
    }
  }

  void saveEmployee() async {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic> employeeInfoMap = {
      "name": nameController.text.trim(),
      "age": ageController.text.trim(),
      "address": addressController.text.trim(),
    };

    try {
      if (widget.isEdit) {
        await DatabaseMethods().updateEmployee(employeeId, employeeInfoMap);
      } else {
        String id = randomAlphaNumeric(10);
        employeeInfoMap["id"] = id;
        await DatabaseMethods().addEmployeeDetails(employeeInfoMap, id);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving employee: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.isEdit ? Colors.blue : Colors.orange,
        title: Text(
          widget.isEdit ? 'Edit Employee' : 'Add Employee',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: widget.isEdit ? Colors.blue : Colors.orange,
              height: 100,
              child: Center(
                child: Icon(
                  widget.isEdit ? Icons.edit_document : Icons.person_add,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.isEdit ? Colors.blue : Colors.orange,
                    ),
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    controller: nameController,
                    label: 'Full Name',
                    hint: 'Enter employee name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 16),
                  buildTextField(
                    controller: ageController,
                    label: 'Age',
                    hint: 'Enter employee age',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  buildTextField(
                    controller: addressController,
                    label: 'Address',
                    hint: 'Enter employee address',
                    icon: Icons.location_on,
                    maxLines: 3,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: saveEmployee,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.isEdit ? Colors.blue : Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.isEdit ? 'Update Employee' : 'Add Employee',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: widget.isEdit ? Colors.blue : Colors.orange,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.isEdit ? Colors.blue : Colors.orange,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.isEdit ? Colors.blue : Colors.orange,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
