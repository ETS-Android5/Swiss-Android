import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/work_order.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class ProductDetails extends StatefulWidget {
  final String workOrderId;

  ProductDetails({
    Key key,
    @required this.workOrderId,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetails> {
  // final GlobalKey<FormState> _formKey = GlobalKey();

  bool isInit = true;
  List<WorkOrder> workOrder = [];
  WorkOrder work = new WorkOrder();
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

  TextEditingController _selectedstartTimeController = TextEditingController();
  TextEditingController _selectedendTimeController = TextEditingController();
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
  void initState() {
    super.initState();

    Provider.of<Customer>(context, listen: false)
        .workerListsWorkOrdersbyID(this.widget.workOrderId)
        .then((value) {
      print(value[0]);
      // workOrder = value;
      work = value[0];

      _selectedstartTimeController.text = work.arrivalTime;
      _selectedendTimeController.text = work.departureTime;
      _selectedcompanyTimeController.text = work.companyTime;
      _selectedtimeOnSiteController.text = work.timeOnSite;
      _selectedtotalTravelTimeController.text = work.totalTravelTime;
      _selectedchargeController.text = work.charge;
      _selectedactivitiesDescriptionController.text =
          work.activitiesDescription;
      _selectedcodeController.text = work.code;
      _selectedtimeController.text = work.time;
      _selectedsWHWupdateDescriptionController.text =
          work.sWHWupdateDescription;
      _selectedremarkNextVisitController.text = work.remarkNextVisit;
      _selectedsparepartController.text = work.sparepart;
      _selectedsWHWupdates = work.sWHWupdates;
      _selectedisWorking = work.isWorking;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final int orderId = int.parse(widget.workOrderId);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detaje të punës'),
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
                controller: _selectedstartTimeController,
                enabled: false,
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
                onSaved: (val) => {_selectedstarttime = val},
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
                // initialValue: work.departureTime != null
                //     ? work.departureTime
                //     : DateTime.now().toString(),
                controller: _selectedendTimeController,
                enabled: false,
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
                  controller: _selectedcompanyTimeController,
                  enabled: false,
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
                  controller: _selectedtimeOnSiteController,
                  enabled: false,
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
                  controller: _selectedtotalTravelTimeController,
                  enabled: false,
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
                  controller: _selectedchargeController,
                  enabled: false,
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
                  controller: _selectedactivitiesDescriptionController,
                  enabled: false,
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedactivitiesDescription = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
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
                  controller: _selectedcodeController,
                  enabled: false,
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
                  controller: _selectedtimeController,
                  enabled: false,
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
                    controller: _selectedsWHWupdateDescriptionController,
                    enabled: false,
                    // controller: controller,
                    onChanged: ((value) {
                      setState(() {
                        _selectedsWHWupdateDescription = value;
                      });
                    }),
                    minLines:
                        2, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.number,
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
                  controller: _selectedremarkNextVisitController,
                  enabled: false,
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedremarkNextVisit = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
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
                  controller: _selectedsparepartController,
                  enabled: false,
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      _selectedsparepart = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Spare Part/Consumables',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.description_rounded),
                    ),
                  )),
              SizedBox(height: 20),
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
                            // Navigator.of(ctx).pop();
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
                          style: Theme.of(context).textTheme.headline6.copyWith(
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
