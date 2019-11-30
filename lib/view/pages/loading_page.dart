import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:planner/utils/json/json_serde.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 5), () => "5");
  }

  void setupWorldTime() async{
    await sleep1();
    Navigator.pushReplacementNamed(context, "/home",arguments: {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body:Center(
          child: SpinKitRotatingCircle(
            color: Colors.white,
            size: 50.0,
          ),
        )
    );
  }
}
