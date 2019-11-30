import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
//  const SideDrawer({Key key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Projects'),
              onTap: () {
//                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/home");
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Members'),
              onTap: () {
//                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/members");
              },
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
