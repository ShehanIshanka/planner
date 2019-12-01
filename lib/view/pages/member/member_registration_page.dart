import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planner/common/registration_validator.dart';
import 'package:planner/model/beans/member/member.dart';
import 'package:planner/view/widgets/message_box.dart';

class MemberRegistration extends StatefulWidget {
  final Member member;
  final String status;

  MemberRegistration({Key key, @required this.member, @required this.status})
      : super(key: key);

  @override
  _MemberRegistration createState() =>
      new _MemberRegistration(member: member, status: status);
}

class _MemberRegistration extends State<MemberRegistration> {
  Member member;
  String status;
  String title;
  String _radioValue;

  _MemberRegistration({this.member, this.status});

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MessageBox _messageBox = new MessageBox();
  RegistrationValidator _registrationValidator = new RegistrationValidator();

  @override
  void initState() {
    setState(() {
      _radioValue = member.getGender();
      if (status == "new") {
        title = "New Member";
      } else if (status == "edit") {
        title = "Edit Member";
      }
    });
    super.initState();
  }

  void changeGender(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'male':
          member.setGender(value);
          break;
        case 'female':
          member.setGender(value);
          break;
        default:
          member.setGender("male");
      }
    });
  }

  void _submitForm(BuildContext context) {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _messageBox.showMessage(
          'Form is not valid!  Please review and correct.', _scaffoldKey);
    } else {
      form.save(); //This invokes each onSaved event
      Navigator.pop(context, member);
      Navigator.pushReplacementNamed(context, "/members");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your first and last name',
                      labelText: 'Name',
                    ),
                    initialValue: member.getName(),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) => val.isEmpty ? 'Name is required' : null,
                    onSaved: (val) => member.setName(val.trim()),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter your email address',
                      labelText: 'Email',
                    ),
                    initialValue: member.getEmail(),
                    inputFormatters: [new LengthLimitingTextInputFormatter(40)],
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => _registrationValidator.isValidEmail(value)
                        ? null
                        : 'Please enter a valid email address',
                    onSaved: (val) => member.setEmail(val),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person_pin),
                      hintText: 'Enter your title',
                      labelText: 'Title',
                    ),
                    initialValue: member.getPosition(),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) =>
                        val.isEmpty ? 'Title is required' : null,
                    onSaved: (val) => member.setPosition(val.trim()),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Radio(
                          value: "male",
                          groupValue: _radioValue,
                          onChanged: changeGender),
                      new Text('Male'),
                      new Radio(
                          value: "female",
                          groupValue: _radioValue,
                          onChanged: changeGender),
                      new Text('Female')
                    ],
                  ),
                  new Container(
//                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      _submitForm(context);
                    },
                  )),
                ],
              ))),
    );
  }
}
