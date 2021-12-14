import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:service_app/main.dart';
import 'package:service_app/models/problemType.dart';
import 'package:service_app/models/serialNumber.dart';
import 'package:service_app/models/supportVisitType.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/product_list.dart';
import 'package:service_app/screens/widgets/app_drawer_list_widget.dart';
import 'package:service_app/screens/widgets/booking_list_item_widget.dart';
import 'package:service_app/screens/widgets/bottom_ff_navbar_widget.dart';
import 'package:service_app/screens/widgets/cart.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class ShtoTikete extends StatefulWidget {
  static const routeName = '/shto-tikete';

  @override
  _ShtoTiketeScreenState createState() => _ShtoTiketeScreenState();
}

class _ShtoTiketeScreenState extends State<ShtoTikete> {
  // final GlobalKey<FormState> _formKey = GlobalKey();

  bool isInit = true;
  ProblemType _selectedProvince;
  SupportVisitType _selectedSupport;
  SerialNumber _selectedSerialNumber;
  String _problemdesc = '';
  String _supportVisitText = '';
  bool isShown = false;
  final _problemdescController = TextEditingController();
  final _supportController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false)
          .getAllProblemTypes()
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
      Provider.of<Customer>(context, listen: false)
          .getAllSupportVisitType()
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
      Provider.of<Customer>(context, listen: false)
          .getAllProdDropDown()
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shto Tiketë'),
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
                'Serial Number:',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              //DropDOWN
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_serialNumber()],
                  ),
                ),
              ),

              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Support Visit Type:',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              //DropDOWN
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _supportVisitType(),
                      isShown == true ? text() : Text('')
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Problem Type:',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              //DropDOWN
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_problemType()],
                  ),
                ),
              ),

              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              TextFormField(
                // controller: _problemdescController,
                onChanged: ((value) {
                  setState(() {
                    this._problemdesc = value;
                  });
                }),
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Write Problem Discription here',
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => new AlertDialog(
                          content: new Text(
                            'Dëshironi të bëni një porosi?',
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: new Text('Jo'),
                            ),
                            new FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                showLoadingDialog(context);
                                Provider.of<Customer>(context, listen: false)
                                    .shtoTikete(
                                        _selectedSerialNumber.id,
                                        _selectedProvince.id,
                                        this._problemdesc,
                                        _selectedSupport.id,
                                        this._supportVisitText)
                                    .then(
                                      (value) => {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/')
                                      },
                                    );
                              },
                              child: new Text('Po'),
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
                                Icons.add,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextSpan(
                              text: ' Shto Tiketë ',
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
                            'Dëshironi të anulloni?',
                          ),
                          actions: <Widget>[
                            new TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: new Text('Jo'),
                            ),
                            new TextButton(
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (ctx) => ProductList()));
                                //Navigator.of(ctx).pop();
                                Navigator.of(context).pushReplacementNamed('/');

                                //showLoadingDialog(context);
                              },
                              child: new Text('Po'),
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
                              text: ' Anullo ',
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

  Widget _problemType() {
    final problemTypes = Provider.of<Customer>(context).problemTypes;
    return new Container(
        child: new InputDecorator(
          decoration: InputDecoration(
              suffixIcon: new Icon(
                Icons.medical_services_outlined,
                color: Colors.pink,
              ),
              //  labelText: "Problem Type",
              labelStyle: TextStyle(fontSize: 16.0)),
          isEmpty: _selectedProvince == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<ProblemType>(
              value: _selectedProvince,
              isDense: true,
              onChanged: (ProblemType newValue) {
                setState(() {
                  _selectedProvince = newValue;
                });
              },
              items: problemTypes.map((ProblemType value) {
                return new DropdownMenuItem<ProblemType>(
                  value: value,
                  child: new Text(
                    value.problemType,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0));
  }

  Widget _supportVisitType() {
    final supportVisitTypes = Provider.of<Customer>(context).supportVisitTypes;
    return new Container(
        child: new InputDecorator(
          decoration: InputDecoration(
              suffixIcon: new Icon(
                Icons.medical_services_outlined,
                color: Colors.pink,
              ),
              //  labelText: "Problem Type",
              labelStyle: TextStyle(fontSize: 16.0)),
          isEmpty: _selectedProvince == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<SupportVisitType>(
              value: _selectedSupport,
              isDense: true,
              onChanged: (SupportVisitType newValue) {
                setState(() {
                  _selectedSupport = newValue;
                  if (newValue.supportVisitType == 'Other') {
                    // _selectedSupport = newValue;
                    isShown = true;
                  } else {
                    isShown = false;
                  }
                });
              },
              items: supportVisitTypes.map((SupportVisitType value) {
                return new DropdownMenuItem<SupportVisitType>(
                  value: value,
                  child: new Text(
                    value.supportVisitType,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0));
  }

  Widget _serialNumber() {
    final serialNumber = Provider.of<Customer>(context).serialNumbers;
    return new Container(
        child: new InputDecorator(
          decoration: InputDecoration(
              suffixIcon: new Icon(
                Icons.medical_services_outlined,
                color: Colors.pink,
              ),
              //  labelText: "Problem Type",
              labelStyle: TextStyle(fontSize: 16.0)),
          isEmpty: _selectedProvince == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<SerialNumber>(
              value: _selectedSerialNumber,
              isDense: true,
              onChanged: (SerialNumber newValue) {
                setState(() {
                  _selectedSerialNumber = newValue;
                });
              },
              items: serialNumber.map((SerialNumber value) {
                return new DropdownMenuItem<SerialNumber>(
                  value: value,
                  child: new Text(
                    value.name,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0));
  }

  Widget text() {
    return TextFormField(
        // controller: _supportController,
        onChanged: ((value) {
          setState(() {
            this._supportVisitText = value;
          });
        }),
        minLines:
            2, // any number you need (It works as the rows for the textarea)
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Please describe your support visit type.',
        ));
  }

  Future<void> _showMessageDialog(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

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
                child: Text("Ju lutem prisni..."),
              ),
            ],
          ),
        );
      },
    );
  }
}
