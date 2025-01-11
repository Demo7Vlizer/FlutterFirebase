import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employee');

  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    try {
      print("Adding employee with data: $employeeInfoMap");
      await employeesCollection.doc(id).set(employeeInfoMap);
      print("Employee added successfully");
    } catch (e) {
      print("Error adding employee: $e");
      throw e;
    }
  }

  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return employeesCollection.snapshots();
  }

  Future deleteEmployee(String docId) async {
    try {
      await employeesCollection.doc(docId).delete();
      print("Employee deleted successfully");
    } catch (e) {
      print("Error deleting employee: $e");
      throw e;
    }
  }

  Future updateEmployee(String docId, Map<String, dynamic> newData) async {
    try {
      print("Updating employee with data: $newData");
      await employeesCollection.doc(docId).update(newData);
      print("Employee updated successfully");
    } catch (e) {
      print("Error updating employee: $e");
      throw e;
    }
  }
}
