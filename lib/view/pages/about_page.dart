import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planner/view/widgets/side_drawer.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new SideDrawer(),
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: new EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'This app is developed to help project management tasks.\n'
                  'This app has following features.\n'
                  ' 1. Add members of your team.\n'
                  ' 2. Create projects and assign tasks to selected members.',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 100,
                  style: TextStyle(fontSize: 18),
                ),
//              Card(
//                child: Image.asset('assets/launch_image.png', scale: 0.1),
//              ),
                Container(
                  //
                  child: Image(
                    image: AssetImage('assets/launch_image.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Text(
                  'Vector images are extracted from https://www.vecteezy.com',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 100,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
