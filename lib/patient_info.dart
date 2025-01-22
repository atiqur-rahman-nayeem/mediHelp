import 'package:flutter/material.dart';
import 'dart:math';

class PatientInfo extends StatefulWidget {
  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  List<Map<String, dynamic>> patientData = [];

  int currentIndex = 0;
  int displayCount = 5;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateRandomPatientData(1000);
  }

  void generateRandomPatientData(int numberOfPatients) {
    final Random random = Random();
    for (int i = 1; i <= numberOfPatients; i++) {
      patientData.add({
        'id': i,
        'name': 'Patient $i',
        'mobile': '0171${random.nextInt(100000000)}',
        'address': 'Bangladesh, District ${random.nextInt(64)}',
      });
    }
  }

  void showNextPatients() {
    if (currentIndex + displayCount < patientData.length) {
      setState(() {
        currentIndex += displayCount;
      });
    }
  }

  void showPreviousPatients() {
    if (currentIndex - displayCount >= 0) {
      setState(() {
        currentIndex -= displayCount;
      });
    }
  }

  void searchPatient() {
    final searchText = searchController.text;
    final patient = patientData.firstWhere(
          (p) => p['id'].toString() == searchText,
      orElse: () => {
        'id': 'N/A',
        'name': 'N/A',
        'mobile': 'N/A',
        'address': 'N/A',
      },
    );

    if (patient['id'] == 'N/A') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Patient Not Found'),
            content: Text('No patient found with the provided ID.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Patient Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ID: ${patient['id']}'),
                Text('Name: ${patient['name']}'),
                Text('Mobile: ${patient['mobile']}'),
                Text('Address: ${patient['address']}'),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> patientRows = [];
    for (int i = currentIndex; i < patientData.length && i < currentIndex + displayCount; i++) {
      Map<String, dynamic> patient = patientData[i];
      patientRows.add(
        DataRow(
          cells: [
            DataCell(Text('${patient['id']}')),
            DataCell(Text('${patient['name']}')),
            DataCell(Text('${patient['mobile']}')),
            DataCell(
              Container(
                width: 150,
                child: Text('${patient['address']}'),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Info'),
        backgroundColor: Colors.green, // Set the AppBar background color to green.
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Add your exit functionality here
              // For example, you can use SystemNavigator.pop() to exit the app.
              // Note: This feature might not be available on all platforms.
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pin.png'), // Set the background image.
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '',
                style: TextStyle(fontSize: 20),
              ),
              DataTable(
                columnSpacing: 15,
                columns: [
                  DataColumn(
                    label: Text('ID'),
                    numeric: true,
                  ),
                  DataColumn(label: Text('Name')),
                  DataColumn(
                    label: Text('Mobile'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Address'),
                  ),
                ],
                rows: patientRows,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: showPreviousPatients,
                    child: Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Set the button color to green.
                    ),
                  ),
                  SizedBox(width: 150),
                  ElevatedButton(
                    onPressed: showNextPatients,
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Set the button color to green.
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(labelText: 'Search by ID'),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: searchPatient,
                    child: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Set the button color to green.
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: PatientInfo()));
