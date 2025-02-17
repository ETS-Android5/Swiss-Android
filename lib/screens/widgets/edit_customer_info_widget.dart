import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/Global.dart';
import 'package:service_app/providers/auth.dart';

class EditCustomerInfoWidget extends StatefulWidget {
  @override
  _EditCustomerInfoWidgetState createState() => _EditCustomerInfoWidgetState();
}

class _EditCustomerInfoWidgetState extends State<EditCustomerInfoWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String gender;
  bool _isInit = true;
  Map<String, String> _newData = {
    'name': '',
    'mobile': '',
  };
  @override
  Widget build(BuildContext context) {
    String _oldNumber;
    final user = Provider.of<Auth>(context).currentUser;
    final size = MediaQuery.of(context).size;
    if (_isInit) {
      print('gender: ${user.gender}');
      gender = user.gender;
      _newData['name'] = user.name;
      _newData['mobile'] = user.mobile;
      _oldNumber = user.mobile;
      _isInit = false;
    }
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Informacion Personal',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: user.name,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Emri i pasaktë!';
                  }
                },
                onSaved: (value) {
                  _newData['name'] = value;
                },
                decoration: InputDecoration(
                  labelText: 'Emri i plotë',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            if (user.isCustomer)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: user.accountHolder,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Emri i kontaktit i pasaktë!';
                    }
                  },
                  onSaved: (value) {
                    _newData['account_holder_name'] = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Emri i Kontaktit',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: user.email,
                validator: (value) {
                  if (value.isEmpty ||
                      !value.contains('@') ||
                      !value.contains('.')) {
                    return 'Email i pasaktë!';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  enabled: false,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: Global.userPhoneNumber,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Nr.Tel i pasaktë!';
                  }
                },
                onSaved: (value) {
                  _newData['mobile'] = value;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nr.Tel',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 8.0), child: Text('Gender')),
            Row(
              children: [
                Radio(
                  value: '1',
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = '1';
                    });
                  },
                ),
                Text('Mashkull'),
                SizedBox(
                  width: size.width / 4,
                ),
                Radio(
                  value: '0',
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = '0';
                    });
                  },
                ),
                Text('Femër'),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      Navigator.of(context).pop();
                      Provider.of<Auth>(context, listen: false)
                          .editPersonalInfo(
                        _newData['name'],
                        _newData['mobile'],
                        gender,
                        _newData['account_holder_name'],
                      );
                      /*
                      if(_newData['mobile'] != _oldNumber) {
                        Provider.of<Auth>(context, listen: false).logoutFromPhoneAuth();
                        Provider.of<Auth>(context, listen: false).validatePhoneOrShowValidationScreen();
                      }
                      */
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Theme.of(context).primaryColor,
                      ),
                      width: (size.width / 2) - 20,
                      child: Text(
                        'Ruaj',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Theme.of(context).primaryColor,
                      ),
                      width: (size.width / 2) - 20,
                      child: Text(
                        'Anullo',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
