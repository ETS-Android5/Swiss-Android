import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/type_of_Work.dart';
import 'package:service_app/models/work_order.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/product_details.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class ListOfWork extends StatefulWidget {
  @override
  _ListOfWorkScreenState createState() => _ListOfWorkScreenState();
}

class _ListOfWorkScreenState extends State<ListOfWork> {
  // final GlobalKey<FormState> _formKey = GlobalKey();

  bool isInit = true;
  bool isListVisible = false;

  int _selectedtype = 1;
  List<WorkOrder> workOrders = [];
  List<TypeOfWork> typeOfWork = [
    TypeOfWork(typeId: 1, typeName: 'Të hapura'),
    TypeOfWork(typeId: 2, typeName: 'Të mbyllura'),
    TypeOfWork(typeId: 3, typeName: 'Të faturuara'),
    TypeOfWork(typeId: 4, typeName: 'Të pa mbyllura')
  ];

  @override
  void didChangeDependencies() {
    if (isInit) {
      onSelectedDropDownChanged(1);
    }
    super.didChangeDependencies();
  }

  void onSelectedDropDownChanged(int selectedType) {
    isListVisible = true;
    workOrders.clear();
    Provider.of<Customer>(context, listen: false)
        .listOfWork(selectedType.toString())
        .then((listOrder) {
      if (listOrder != null) {
        workOrders = listOrder;
      } else {
        listOrder = [];
      }
      setState(() {
        isInit = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Punët'),
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
                'Zgjidh Listën e Punëve:',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              //DropDOWN
              Container(
                child: Center(
                  child: _listOfWorkTypes(),
                ),
              ),

              SizedBox(height: 10),
              Divider(),
              Container(
                child: Center(
                  child: isListVisible == true ? listOfWork() : Text('test'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listOfWorkTypes() {
    return new Container(
        child: new InputDecorator(
          decoration: InputDecoration(
              suffixIcon: new Icon(
                Icons.medical_services_outlined,
                color: Colors.pink,
              ),
              labelStyle: TextStyle(fontSize: 16.0)),
          isEmpty: _selectedtype == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<int>(
              value: _selectedtype,
              isDense: true,
              onChanged: (int newValue) {
                setState(() {
                  _selectedtype = newValue;
                });
                // http request
                onSelectedDropDownChanged(newValue);
                // isListVisible = true;
              },
              items: typeOfWork.map((TypeOfWork value) {
                return new DropdownMenuItem<int>(
                  value: value.typeId,
                  child: new Text(
                    value.typeName,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0));
  }

  Widget listOfWork() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: workOrders.length,
        itemBuilder: (context, index) {
          var item = workOrders[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Card(
              elevation: 4.0,
              child: ListTile(
                leading: Icon(Icons.work),
                title: Text(item.productName),
                subtitle: Text(item.serialNumber),
                trailing: GestureDetector(
                    child: Icon(
                      Icons.remove_red_eye,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => CustomDrawer(
                                child: ProductDetails(
                              workOrderId: item.workOrderId,
                            )),
                          ),
                        );
                        //  _cart.remove(item);
                      });
                    }),
              ),
            ),
          );
        });
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
