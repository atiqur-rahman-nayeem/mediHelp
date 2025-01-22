import 'package:flutter/material.dart';

class Doctor {
  final int id;
  final String name;
  final String specialist;
  final String mobileNumber;
  final String hospitalName;
  final String photoUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialist,
    required this.mobileNumber,
    required this.hospitalName,
    required this.photoUrl,
  });
}

class DoctorPage extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      id: 1801025,
      name: 'Dr. Atiqur Rahman',
      specialist: 'Cardiologist',
      mobileNumber: '555-123-4567',
      hospitalName: 'City Hospital',
      photoUrl:
      "https://media.licdn.com/dms/image/C5603AQGW1z24QE4cvQ/profile-displayphoto-shrink_800_800/0/1587676261949?e=2147483647&v=beta&t=ygA8Cu8UP2xwXc7owl7EFgxFdw3Tk6FRYqHdjl_-XwQ",
    ),
    Doctor(
      id: 1801020,
      name: 'Dr. Md Abdul Halim Khan',
      specialist: 'Dermatologist',
      mobileNumber: '555-987-6543',
      hospitalName: 'General Hospital',
      photoUrl:
      'https://media.licdn.com/dms/image/D5603AQGUuOV_ZX7Juw/profile-displayphoto-shrink_800_800/0/1684598310269?e=2147483647&v=beta&t=1Jb6lcBjLnipMKXI1qKvqAt4w3RuFErQiSbovx-LayU',
    ),
    Doctor(
      id: 1801010,
      name: 'Sadikur Rahman Sadik',
      specialist: 'Pediatrician',
      mobileNumber: '555-234-5678',
      hospitalName: "Children's Clinic",
      photoUrl: 'assets/pin.png',
    ),
    Doctor(
      id: 1801033,
      name: 'Dr. Md Shohanur Rahman Shohan',
      specialist: 'Orthopedic Surgeon',
      mobileNumber: '555-876-5432',
      hospitalName: 'Ortho Hospital',
      photoUrl:
      'https://media.licdn.com/dms/image/C5603AQFk9Uh93BuUTw/profile-displayphoto-shrink_100_100/0/1599716427407?e=2147483647&v=beta&t=JphC3FwRTrnR3aN3cEhjilfRfPaLXHIVnPVF88MI0TA',
    ),
    Doctor(
      id: 1801015,
      name: 'Dr. Partho Sharothi Chowhan',
      specialist: 'Ophthalmologist',
      mobileNumber: '555-345-6789',
      hospitalName: 'Eye Care Center',
      photoUrl:
      'https://media.licdn.com/dms/image/D5603AQFNBfd1AYA8Cw/profile-displayphoto-shrink_800_800/0/1697420710969?e=2147483647&v=beta&t=_HrfkMIwa1Rqvbee37Gc_e-K1XrVd6UV2HWi9hQdLfI',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Info'),
        backgroundColor: Colors.green, // Set the app bar color to green
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(doctor.photoUrl),
            ),
            title: Text(doctor.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${doctor.id}'),
                Text('Specialist: ${doctor.specialist}'),
                Text('Mobile Number: ${doctor.mobileNumber}'),
                Text('Hospital Name: ${doctor.hospitalName}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DoctorPage(),
  ));
}
