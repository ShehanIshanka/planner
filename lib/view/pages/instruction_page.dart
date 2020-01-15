import 'package:flutter/material.dart';
import 'package:planner/view/widgets/side_drawer.dart';

class Instructions extends StatefulWidget {
  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  final controller = new PageController();
  int currentPageValue = 0;

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  final List<Widget> introWidgetsList = <Widget>[
    Container(
      child: Image.asset('assets/instructions/1.png',scale: 0.2),
    ),
    Container(
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage('assets/instructions/2.png'))),
    ),
  ];

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new SideDrawer(),
      appBar: AppBar(
        title: Text("Instructions"),
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              PageView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: introWidgetsList.length,
                onPageChanged: (int page) {
                  getChangedPageAndMoveBar(page);
                },
                controller: controller,
                itemBuilder: (context, index) {
                  return introWidgetsList[index];
                },
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < introWidgetsList.length; i++)
                        if (i == currentPageValue) ...[circleBar(true)] else
                          circleBar(false),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
