import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
//  const SideDrawer({Key key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: new Image.asset(
                  'assets/drawer.png'
                ),
              ),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Projects'),
              onTap: () {
//                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/projects");
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
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Instructions'),
              onTap: () {
//                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/instructions");
              },
            ),
          ],
        ),
      ),
    );
  }
}
