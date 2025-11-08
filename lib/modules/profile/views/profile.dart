import 'package:flutter/material.dart';

const Color burntOrange = Color(0xFFC95C27);
const Color titleBrown = Color(0xFF5B3F30);

class ProfileTab extends StatelessWidget {
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: burntOrange.withOpacity(0.13),
                child: Icon(Icons.person, color: burntOrange, size: 46),
              ),
              SizedBox(height: 18),
              Text(
                "Your Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: titleBrown,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Name: Yash Shah",
                style: TextStyle(fontSize: 16, color: titleBrown),
              ),
              SizedBox(height: 4),
              Text(
                "Email: yashcshah2211@gmail.com",
                style: TextStyle(fontSize: 16, color: Color(0xFF795548)),
              ),
              SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: burntOrange,
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  // Implement profile edit
                },
                child: Text("Edit Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
