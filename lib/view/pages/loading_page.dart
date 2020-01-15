import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:planner/utils/file/file_stream.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  FileStream _fileStream = new FileStream();

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 2), () => "5");
  }

  void setup() async {
    await sleep1();
    await _fileStream.createDirectory("data");
    await _fileStream.createDirectory("projects");
    await _fileStream.createDirectory("members");
    Navigator.pushReplacementNamed(context, "/members", arguments: {});
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
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/launch_image.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 200,
                      animation: true,
                      lineHeight: 10.0,
                      animationDuration: 1200,
                      percent: 1,
                      center: Text(""),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.blue,
                    ),
                ],
              ),

            ],
          ),
        ));
  }
}
