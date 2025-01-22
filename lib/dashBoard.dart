import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medihelp/login.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'patient_info.dart';
import 'doctor_page.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool showTemperature = false;
  final databaseReference = FirebaseDatabase.instance.reference();

  // Function to show a confirmation dialog for logout
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                // Navigate to the login or another screen after logout
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medi Help'),
        backgroundColor: Colors.green, // Set AppBar color to green
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'), // Add your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: showTemperature == false
              ? ElevatedButton(
            onPressed: () {
              setState(() {
                showTemperature = true;
              });
            },
            child: Text(
              "Diagnostic",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(50),
              backgroundColor: Colors.green, // Set button color to green
              foregroundColor: Colors.green, // Set text color to green
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: databaseReference.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    DatabaseEvent event = snapshot.data!;

                    if (event.snapshot.value != null) {
                      Iterable<DataSnapshot> value = event.snapshot.children;

                      var bodyTemp = value.first.value;
                      var heartRate = value.last.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircularPercentIndicator(
                            radius: 90,
                            animation: true,
                            animationDuration: 1200,
                            lineWidth: 15.0,
                            percent: 0.4,
                            center: new Text(
                              "Body Temp: \n \t \t $bodyTemp",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.butt,
                            backgroundColor: Colors.pink,
                            progressColor: Colors.cyan,
                          ),
                          SizedBox(width: 20),
                          CircularPercentIndicator(
                            radius: 90,
                            animation: true,
                            animationDuration: 1200,
                            lineWidth: 15.0,
                            percent: 0.4,
                            center: new Text(
                              "Heart Rate: \n \t\t\t\t\t $heartRate",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.butt,
                            backgroundColor: Colors.green,
                            progressColor: Colors.red,
                          ),
                        ],
                      );
                    } else {
                      return Text("No data found in Firebase.");
                    }
                  }

                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  return Text("Waiting for data...");
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your logic for Doctor Info here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorPage()),
                  );
                },
                child: Text(
                  "Doctor Info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set button color to green
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Patient Info page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientInfo()),
                  );
                },
                child: Text(
                  "Patient Info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set button color to green
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
