import 'package:flutter/material.dart';

const Color burntOrange = Color(0xFFC95C27);
const Color titleBrown = Color(0xFF5B3F30);

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/studymate.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Color.fromARGB(25, 255, 255, 255),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          children: [
            Text(
              "Settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: titleBrown,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 14),
            Card(
              child: SwitchListTile(
                title: Text("Dark Mode"),
                value: false,
                activeColor: burntOrange,
                onChanged: (val) {},
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications, color: burntOrange),
                title: Text("Notifications"),
                subtitle: Text("Enable/disable notifications"),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.security, color: burntOrange),
                title: Text("Privacy"),
                subtitle: Text("Manage privacy settings"),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.info_outline, color: burntOrange),
                title: Text("About Study Mate"),
                subtitle: Text("Version 1.0.0"),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
