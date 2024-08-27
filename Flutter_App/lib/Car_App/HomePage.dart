import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Color gold = Color(0xFFFFD835);
final Color darkNavyBlue = Color(0xFF000033);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;
    final double iconSize = size.width * 0.1;
    final double fontSizeTitle = size.width * 0.06;
    final double fontSizeMember = size.width * 0.04;
    final double paddingHorizontal = size.width * 0.05;
    final double paddingVertical = size.height * 0.02;

    return WillPopScope(
      onWillPop: () async => false, // Disables the back button
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home Page',
            style: GoogleFonts.pacifico(
              fontSize: fontSizeTitle,
              color: darkNavyBlue,
            ),
          ),
          backgroundColor: gold,
          automaticallyImplyLeading: false, // Hides the app bar back button
        ),
        body: Container(
          decoration: BoxDecoration(
            color: darkNavyBlue,
          ),
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Welcome To Our Application',
                  style: GoogleFonts.pacifico(
                    fontSize: fontSizeTitle,
                    color: gold,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Team Members',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        color: gold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buildTeamMemberRow('Omar Hassan Abdel Ghani', '22010164', iconSize, fontSizeMember),
                    _buildTeamMemberRow('Ali Alaa Ali Hassan', '22010153', iconSize, fontSizeMember),
                    _buildTeamMemberRow('Abdullah Atef Khamis', '22010140', iconSize, fontSizeMember),
                    _buildTeamMemberRow('Moaz Ahmed Sayed Ahmed', '22010261', iconSize, fontSizeMember),
                  ],
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/car_mode');
                  },
                  icon: Icon(FontAwesomeIcons.car, color: darkNavyBlue, size: iconSize),
                  label: Text(
                    'Car Mode',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkNavyBlue,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Navigate to login page
                  },
                  child: Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: darkNavyBlue, backgroundColor: gold,
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Times New Roman',
                    fontSize: 14,), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberRow(String name, String id, double iconSize, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.userNinja, color: gold, size: iconSize),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$name - ID: $id',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: fontSize,
                color: gold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
