import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/problemType.dart';
import 'package:service_app/models/serialNumber.dart';
import 'package:service_app/models/supportVisitType.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:signature/signature.dart';

class AddFeedBack extends StatefulWidget {
  static const routeName = '/shto-tikete';

  @override
  _AddFeedBackScreenState createState() => _AddFeedBackScreenState();
}

class _AddFeedBackScreenState extends State<AddFeedBack> {
  // final GlobalKey<FormState> _formKey = GlobalKey();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  bool isInit = true;
  String clientname;
  String address;
  String feedback;
  String pyetje1;
  String pyetje2;
  String pyetje3;
  String pyetje4;
  String pyetje5;
  String pyetje6;
  String pyetje7;
  String pyetje8;
  String pyetje9;
  String pyetje10;
  String pyetje11;
  String _signature = '';

  List<SerialNumber> mostlikely = [
    SerialNumber(id: '1', name: 'Sherbime te mira'),
    SerialNumber(id: '2', name: 'Cmime konkuruese'),
    SerialNumber(id: '3', name: 'Cilesi te larte te produkteve tona'),
    SerialNumber(id: '4', name: 'Fleksibilitet'),
    SerialNumber(
        id: '5', name: 'Mbeshtetje per trajnimin e vazhdueshem te stafit tuaj'),
  ];

  final _ratingController = TextEditingController();
  int _rating;
  int _userRating = 3;
  int _ratingBarMode = 1;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData _selectedIcon;
  @override
  void didChangeDependencies() {
    if (isInit) {}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shto Koment'),
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
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      clientname = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Emri i Klientit',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.label),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              TextFormField(
                  // controller: controller,
                  onChanged: ((value) {
                    setState(() {
                      address = value;
                    });
                  }),
                  minLines:
                      2, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.number,
                  //  inputFormatters: [test],
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Adresa e Klientit',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: Icon(Icons.map),
                    ),
                  )),
              SizedBox(height: 10),
              Divider(),
              TextFormField(
                // controller: _problemdescController,
                onChanged: ((value) {
                  setState(() {
                    this.feedback = value;
                  });
                }),
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Shkruaj komentin tënd këtu',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(), // add padding to adjust icon
                    child: Icon(Icons.feedback_outlined),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text('•	Vleresimi i pergjithshem me produktet/sherbimet tona?'),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  pyetje1 = rating.toString();
                },
              ),
              SizedBox(height: 10),
              Divider(),
              Text('•	Shkalla e vleresimit nga nderveprimi me tregun: '),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  pyetje2 = rating.toString();
                },
              ),
              SizedBox(height: 10),
              Divider(),
              Text(
                  '•	Vleresimi i realizimit te sherbimit/si dhe sherbimet e mirembajtjes mbas shitjes?'),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  pyetje3 = rating.toString();
                },
              ),
              SizedBox(height: 10),
              Divider(),
              Text(
                  '•	Vleresimi per afatet kohore te dorezimit te sherbimeve/produkteve?'),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  pyetje4 = rating.toString();
                },
              ),
              SizedBox(height: 10),
              Divider(),
              Text(
                  '•	Shkalla ne te cilen produkti/ sherbimi ploteson kerkesat tuaja fillestare?'),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  pyetje5 = rating.toString();
                },
              ),
              SizedBox(height: 10),
              Divider(),
              Text(
                  '•	Si do ta vleresonit nderveprimin tuaj me punonjesit tane?'),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  pyetje6 = rating.toString();
                },
              ),
              SizedBox(height: 10),
              Divider(),
              Text('•	Cfare ju pelqen me shume rreth kompanise Swissmed?'),
              Container(
                  width: size.width,
                  child: new InputDecorator(
                    decoration: InputDecoration(
                        suffixIcon: new Icon(
                          Icons.medical_services_outlined,
                          color: Colors.pink,
                        ),
                        labelStyle: TextStyle(fontSize: 16.0)),
                    isEmpty: pyetje7 == null,
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton<String>(
                        value: pyetje7,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            pyetje7 = newValue;
                          });
                        },
                        items: mostlikely.map((SerialNumber value) {
                          return new DropdownMenuItem<String>(
                            value: value.id,
                            child: new Text(
                              value.name,
                              style: new TextStyle(fontSize: 10.0),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 10.0)),
              // RatingBar.builder(
              //   initialRating: 3,
              //   minRating: 1,
              //   direction: Axis.horizontal,
              //   allowHalfRating: false,
              //   itemCount: 5,
              //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //   itemBuilder: (context, _) => Icon(
              //     Icons.star,
              //     color: Colors.amber,
              //   ),
              //   onRatingUpdate: (rating) {
              //     pyetje7 = rating.toString();
              //   },
              // ),
              SizedBox(height: 10),
              Divider(),
              TextFormField(
                // controller: _problemdescController,
                onChanged: ((value) {
                  setState(() {
                    this.pyetje8 = value;
                  });
                }),
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText:
                      '•	Cilat produkte ose shërbime dëshironi të kemi, të cilat ndihmojnë në përmirësimin e efikasitetit tuaj?',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(), // add padding to adjust icon
                    child: Icon(Icons.feedback_outlined),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
              Text('•	A do te rekomandoni Swissmed tek palet e treta?'),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: '1',
                    groupValue: pyetje9,
                    onChanged: (val) {
                      setState(() {
                        pyetje9 = val;
                      });
                    },
                  ),
                  Text(
                    'Yes',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                    value: '0',
                    groupValue: pyetje9,
                    onChanged: (val) {
                      setState(() {
                        pyetje9 = val;
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
              if (pyetje9 == '0')
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
                        pyetje10 = value;
                      });
                    }),
                    minLines:
                        2, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.number,
                    //  inputFormatters: [test],
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Ju lutem jepni arsyet:',
                      prefixIcon: Padding(
                        padding:
                            EdgeInsets.only(), // add padding to adjust icon
                        child: Icon(Icons.description_outlined),
                      ),
                    )),
              SizedBox(height: 10),
              Divider(),
              TextFormField(
                // controller: _problemdescController,
                onChanged: ((value) {
                  setState(() {
                    this.pyetje11 = value;
                  });
                }),
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText:
                      'Sugjerimet tuaja per permiresime nga kendveshtrimi juaj:',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(), // add padding to adjust icon
                    child: Icon(Icons.feedback_outlined),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 30),
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
                            'Jeni i sigurtë që doni të shtoni një koment?',
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: new Text('Jo'),
                            ),
                            new FlatButton(
                              onPressed: () async {
                                final Uint8List data =
                                    await _controller.toPngBytes();
                                _signature = base64.encode(data);
                                Navigator.of(ctx).pop();
                                showLoadingDialog(context);
                                Provider.of<JobProvider>(context, listen: false)
                                    .addClientFeedBack(
                                      clientname,
                                      address,
                                      feedback,
                                      pyetje1,
                                      pyetje2,
                                      pyetje3,
                                      pyetje4,
                                      pyetje5,
                                      pyetje6,
                                      pyetje7,
                                      pyetje8,
                                      pyetje9,
                                      pyetje10,
                                      pyetje11,
                                      _signature,
                                    )
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
                              text: ' Shto Koment ',
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

  Widget _ratingBar(int mode) {
    switch (mode) {
      case 1:
        return RatingBar.builder(
          initialRating: 2,
          minRating: 0,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: false,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating as int;
            });
          },
          updateOnDrag: true,
        );
      case 2:
        return RatingBar(
          initialRating: 3,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: _image('assets/heart.png'),
            half: _image('assets/heart_half.png'),
            empty: _image('assets/heart_border.png'),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating as int;
            });
          },
          updateOnDrag: true,
        );
      case 3:
        return RatingBar.builder(
          initialRating: 3,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating as int;
            });
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }

  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: Colors.amber,
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
                child: Text("Please Wait..."),
              ),
            ],
          ),
        );
      },
    );
  }
}
