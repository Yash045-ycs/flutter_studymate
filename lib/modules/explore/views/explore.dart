import 'package:flutter/material.dart';

const Color burntOrange = Color(0xFFC95C27);
const Color titleBrown = Color(0xFF5B3F30);

class ExploreTab extends StatelessWidget {
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
              "Explore Resources",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: titleBrown,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 14),
            Card(
              color: Color(0xFFF7E9D7),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.library_books, color: burntOrange),
                title: Text("Articles & Guides"),
                subtitle: Text("Learn from curated study materials"),
                onTap: () {},
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Color(0xFFF7E9D7),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.star, color: burntOrange),
                title: Text("Recommended Apps"),
                subtitle: Text("Discover learning tools and apps"),
                onTap: () {},
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Color(0xFFF7E9D7),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.people_outline, color: burntOrange),
                title: Text("Community Forums"),
                subtitle: Text("Share and discuss study tips"),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
