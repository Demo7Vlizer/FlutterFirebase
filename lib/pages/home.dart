import 'package:flutter/material.dart';
import 'package:my_app/pages/employee.dart';
import 'package:my_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot>? employeeStream;

  @override
  void initState() {
    super.initState();
    getEmployeeData();
  }

  getEmployeeData() async {
    print("Fetching employee data...");
    var employeeData = await DatabaseMethods().getEmployeeDetails();
    print("Got employee data stream");
    setState(() {
      employeeStream = employeeData;
    });
  }

  Widget employeeList() {
    return StreamBuilder<QuerySnapshot>(
      stream: employeeStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print("No data available");
          return Center(child: Text('No employees found'));
        }

        print("Found ${snapshot.data!.docs.length} employees");
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name: ${ds.data().toString().contains('name') ? ds['name'] : 'N/A'}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Employee(
                                        isEdit: true,
                                        employeeData: {
                                          'id': ds.id,
                                          'name': ds['name'],
                                          'age': ds['age'],
                                          'address': ds['address'],
                                        },
                                      ),
                                    ),
                                  ).then((_) => getEmployeeData());
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await DatabaseMethods().deleteEmployee(ds.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Age: ${ds.data().toString().contains('age') ? ds['age'] : 'N/A'}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Address: ${ds.data().toString().contains('address') ? ds['address'] : 'N/A'}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Employee()),
          ).then((_) =>
              getEmployeeData()); // Refresh data when returning from Employee page
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              'Firebase',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: employeeList(),
            ),
          ],
        ),
      ),
    );
  }
}
