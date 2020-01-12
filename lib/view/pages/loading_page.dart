import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:planner/utils/file/file_stream.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  FileStream _fileStream = new FileStream();
  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 5), () => "5");
  }

  void setup() async{
    await sleep1();
    await _fileStream.createDirectory("data");
    await _fileStream.createDirectory("projects");
    await _fileStream.createDirectory("members");
    Navigator.pushReplacementNamed(context, "/instructions",arguments: {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
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
