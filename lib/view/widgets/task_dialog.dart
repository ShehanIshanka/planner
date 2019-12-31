import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskDialog {
  Future<String> taskDialog(BuildContext context) async {
    String state;
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add or Edit Tasks"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
//                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Lnegth should be 100.',
                                  labelText: 'Task',
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                initialValue: "",
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(100)
                                ],
                                validator: (val) => val.isEmpty ? 'Name is required' : null,
//            onSaved: (val) =>  = val.trim(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Card(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: new DropdownButton<String>(
//                      isExpanded: true,
                                          items: <String>['A', 'B', 'C', 'A', 'B', 'C', 'D']
                                              .map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          hint: new Text("Select City"),
                                          onChanged: (_) {},
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    child: IconButton(
                                      icon: Icon(Icons.delete_forever),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                state = "CANCEL";
                Navigator.pop(context, state);
              },
            ),
            FlatButton(
              child: const Text('SAVE'),
              onPressed: () {
                state = "SAVE";
                Navigator.pop(context, state);
              },
            )
          ],
        );
      },
    );
  }
}
