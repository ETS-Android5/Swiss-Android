import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:signature/signature.dart';

class CompleteJob extends StatefulWidget {
  final String workOrderId;

  CompleteJob({
    Key key,
    @required this.workOrderId,
  }) : super(key: key);

  @override
  _CompleteJobScreenState createState() => _CompleteJobScreenState();
}

class _CompleteJobScreenState extends State<CompleteJob> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  // final GlobalKey<FormState> _formKey = GlobalKey();

  bool isInit = true;
  String _selectedstarttime = '';
  String _selectedendtime = '';
  String _selectedcompanyTime = '';
  String _selectedtimeOnSite = '';
  String _selectedtotalTravelTime = '';
  String _selectedcharge = '';
  String _selectedactivitiesDescription = '';
  String _selectedcode = '';
  String _selectedtime = '';
  String _selectedsWHWupdates = '';
  String _selectedsWHWupdateDescription = '';
  String _selectedisWorking = '';
  String _selectedremarkNextVisit = '';
  String _selectedsparepart = '';
  String _signature = '';
  // final picker = ImagePicker(); // ky eshte deklarimi i picker

  TextEditingController _selectedcompanyTimeController =
      TextEditingController();
  TextEditingController _selectedtimeOnSiteController = TextEditingController();
  TextEditingController _selectedtotalTravelTimeController =
      TextEditingController();
  TextEditingController _selectedchargeController = TextEditingController();
  TextEditingController _selectedactivitiesDescriptionController =
      TextEditingController();
  TextEditingController _selectedcodeController = TextEditingController();
  TextEditingController _selectedtimeController = TextEditingController();
  TextEditingController _selectedsWHWupdateDescriptionController =
      TextEditingController();
  TextEditingController _selectedremarkNextVisitController =
      TextEditingController();
  TextEditingController _selectedsparepartController = TextEditingController();

  @override
  void didChangeDependencies() {
    //if (isInit) {}

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Përfundo Punën'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          //  key: _formKey,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Arrival Time',
                style: TextStyle(fontSize: 14),
              ),
              Divider(),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  if (date.weekday == 6 || date.weekday == 7) {
                    return false;
                  }

                  return true;
                },
                onChanged: (val) => {_selectedstarttime = val},
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
              SizedBox(height: 20),
              Text(
                'Departure Time',
                style: TextStyle(fontSize: 14),
              ),
              Divider(),
              //DropDOWN
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  if (date.weekday == 6 || date.weekday == 7) {
                    return false;
                  }

                  return true;
                },
                onChanged: (val) => {_selectedendtime = val},
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Company Time',
              //   Icon(Icons.business_outlined),
              //   this._selectedcompanyTime,
              //   // this._selectedcompanyTimeController,
              //   TextInputType.number,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedcompanyTime = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Company Time',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.business_outlined),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Working Time On Site',
              //   Icon(Icons.work_sharp),
              //   this._selectedtimeOnSite,
              //   // this._selectedtimeOnSiteController,
              //   TextInputType.number,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedtimeOnSite = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Working Time On Site',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.work_sharp),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Total Travel Time',
              //   Icon(Icons.directions_bus_filled_outlined),
              //   this._selectedtotalTravelTime,
              //   // this._selectedtotalTravelTimeController,
              //   TextInputType.number,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedtotalTravelTime = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Total Travel Time',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.directions_bus_filled_outlined),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Charge',
              //   Icon(Icons.money_outlined),
              //   this._selectedcharge,
              //   // this._selectedchargeController,
              //   TextInputType.number,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedcharge = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Charge',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.money_outlined),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Activities Description',
              //   Icon(Icons.description),
              //   this._selectedactivitiesDescription,
              //   // this._selectedactivitiesDescriptionController,
              //   TextInputType.text,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedactivitiesDescription = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  // keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Activities Description',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.description),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Referral Code',
              //   Icon(Icons.code),
              //   this._selectedcode,
              //   // this._selectedcodeController,
              //   TextInputType.text,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedcode = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Referral Code',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.code),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Time',
              //   Icon(Icons.timelapse_outlined),
              //   this._selectedtime,
              //   //  this._selectedtimeController,
              //   TextInputType.number,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedtime = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Time',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.timelapse_outlined),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              Text(
                'SW & HW updates:',
                style: TextStyle(fontSize: 14),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: '1',
                    groupValue: _selectedsWHWupdates,
                    onChanged: (val) {
                      setState(() {
                        _selectedsWHWupdates = val;
                      });
                    },
                  ),
                  Text(
                    'Yes',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                    value: '0',
                    groupValue: _selectedsWHWupdates,
                    onChanged: (val) {
                      setState(() {
                        _selectedsWHWupdates = val;
                      });
                    },
                  ),
                  Text(
                    'No',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              if (_selectedsWHWupdates == '1')
                // inputType(
                //   'SW & HW Update Description:',
                //   Icon(Icons.description_outlined),
                //   this._selectedsWHWupdateDescription,
                //   //  this._selectedsWHWupdateDescriptionController,
                //   TextInputType.text,
                // ),
                TextFormField(
                    // controller: controller,
                    onChanged: ((value) {
                      setState(() {
                        _selectedsWHWupdateDescription = value;
                      });
                    }),
                    minLines:
                        2, // any number you need (It works as the rows for the textarea)
                    //  keyboardType: TextInputType.number,
                    //  inputFormatters: [test],
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'SW & HW Update Description:',
                      prefixIcon: Padding(
                        padding:
                            EdgeInsets.only(), // add padding to adjust icon
                        child: Icon(Icons.description_outlined),
                      ),
                    )),
              SizedBox(height: 10),
              Divider(),
              Text(
                'Analyzer left on perfect working conditions: ',
                style: TextStyle(fontSize: 14),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: '1',
                    groupValue: _selectedisWorking,
                    onChanged: (val) {
                      setState(() {
                        _selectedisWorking = val;
                      });
                    },
                  ),
                  Text(
                    'Yes',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                    value: '0',
                    groupValue: _selectedisWorking,
                    onChanged: (val) {
                      setState(() {
                        _selectedisWorking = val;
                      });
                    },
                  ),
                  Text(
                    'No',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Remarks For Next Visit',
              //   Icon(Icons.description),
              //   this._selectedremarkNextVisit,
              //   // this._selectedremarkNextVisitController,
              //   TextInputType.number,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedremarkNextVisit = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  // keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Remarks For Next Visit',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.description),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              // inputType(
              //   'Spare Part/Consumables',
              //   Icon(Icons.description_rounded),
              //   this._selectedsparepart,
              //   // this._selectedsparepartController,
              //   TextInputType.number,
              // ),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedsparepart = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  // keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Spare Part/Consumables',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.description_rounded),
                    ),
                  )),
              SizedBox(height: 50),

              Container(
                height: 50,
                child: const Center(
                  child: Text('Enter your signiture'),
                ),
              ),
              //SIGNATURE CANVAS
              Signature(
                controller: _controller,
                height: 300,
                backgroundColor: Colors.grey[300],
              ),
              //OK AND CLEAR BUTTONS
              Container(
                decoration: const BoxDecoration(color: Colors.black),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //SHOW EXPORTED IMAGE IN NEW ROUTE
                    IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.blue,
                      onPressed: (null),
                      //async {
                      // if (_controller.isNotEmpty) {
                      //   final Uint8List data = await _controller.toPngBytes();
                      //   //  log(data.toString());
                      //   if (data != null) {
                      //     final _signature = base64.encode(data);
                      //     log(_signature);
                      //final imageEncoded = base64.encode(_signature);
                      // log(imageEncoded.toString());
                      // await Navigator.of(context).push(
                      //   MaterialPageRoute<void>(
                      //     builder: (BuildContext context) {
                      //       return Scaffold(
                      //         appBar: AppBar(),
                      //         body: Center(
                      //           child: Container(
                      //             color: Colors.grey[300],
                      //             child: Image.memory(data),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // );
                      //     }
                      //   }
                      // },
                    ),
                    //CLEAR CANVAS
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() => _controller.clear());
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => new AlertDialog(
                          content: new Text(
                            'Are you Sure you want to Complete this Job?',
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: new Text('No'),
                            ),
                            new FlatButton(
                              onPressed: () async {
                                final Uint8List data =
                                    await _controller.toPngBytes();
                                _signature = base64.encode(data);
                                Navigator.of(ctx).pop();
                                showLoadingDialog(context);
                                Provider.of<JobProvider>(context, listen: false)
                                    .workercompleteWo(
                                      this.widget.workOrderId,
                                      this._selectedstarttime,
                                      this._selectedendtime,
                                      this._selectedcompanyTime,
                                      this._selectedtimeOnSite,
                                      this._selectedtotalTravelTime,
                                      this._selectedcharge,
                                      this._selectedactivitiesDescription,
                                      this._selectedcode,
                                      this._selectedtime,
                                      this._selectedsWHWupdates,
                                      this._selectedsWHWupdateDescription,
                                      this._selectedisWorking,
                                      this._selectedremarkNextVisit,
                                      this._selectedsparepart,
                                      this._signature,
                                    )
                                    .then(
                                      (value) => {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/')
                                      },
                                    );
                              },
                              child: new Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.done_all,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextSpan(
                              text: ' Përfundo punën ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => new AlertDialog(
                          content: new Text(
                            'Are you Sure you want to cancel?',
                          ),
                          actions: <Widget>[
                            new TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: new Text('No'),
                            ),
                            new TextButton(
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (ctx) => ProductList()));
                                //Navigator.of(ctx).pop();
                                Navigator.of(context).pushReplacementNamed('/');

                                //showLoadingDialog(context);
                              },
                              child: new Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.cancel,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextSpan(
                              text: ' Cancel ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget inputType(
  //   String hint,
  //   Icon icon,
  //   String input,
  //   TextInputType keyboarType,
  // ) {
  //   return TextFormField(
  //       // controller: controller,
  //       onChanged: ((value) {
  //         setState(() {
  //           if (input == _selectedcompanyTime) {
  //             input = value;
  //           } else if (input == _selectedtimeOnSite) {
  //             input = value;
  //           }
  //         });
  //       }),
  //       minLines:
  //           2, // any number you need (It works as the rows for the textarea)
  //       keyboardType: keyboarType,
  //       //  inputFormatters: [test],
  //       maxLines: null,
  //       decoration: InputDecoration(
  //         hintText: hint,
  //         prefixIcon: Padding(
  //           padding: EdgeInsets.only(), // add padding to adjust icon
  //           child: icon,
  //         ),
  //       ));
  // }

  showLoadingDialog(BuildContext ctx) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(),
              Container(
                margin: EdgeInsets.only(left: 7),
                child: Text("Please Wait..."),
              ),
            ],
          ),
        );
      },
    );
  }
}
