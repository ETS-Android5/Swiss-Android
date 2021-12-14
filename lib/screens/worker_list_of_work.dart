import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/type_of_Work.dart';
import 'package:service_app/models/work_order.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class WorkerListOfWork extends StatefulWidget {
  @override
  _WorkerListOfWorkScreenState createState() => _WorkerListOfWorkScreenState();
}

class _WorkerListOfWorkScreenState extends State<WorkerListOfWork> {
  // final GlobalKey<FormState> _formKey = GlobalKey();

  bool isInit = true;
  bool isListVisible = false;

  int _selectedtype = 1;
  List<WorkOrder> workOrders = [];
  List<TypeOfWork> typeOfWork = [
    TypeOfWork(typeId: 1, typeName: 'Të hapura'),
    TypeOfWork(typeId: 2, typeName: 'Të përfunduara'),
    TypeOfWork(typeId: 3, typeName: 'Të papërfunduara'),
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
    Provider.of<JobProvider>(context, listen: false)
        .workerListOfWork(selectedType.toString())
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
        title: Text('Punët e Mia'),
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
                'Lista e punëve të mia',
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
          isEmpty: false,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<int>(
              isDense: true,
              onChanged: (int newValue) {
                setState(() {
                  _selectedtype = newValue;
                });
                // http request
                onSelectedDropDownChanged(_selectedtype);
                // isListVisible = true;
              },
              value: _selectedtype,
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
                // trailing: GestureDetector(
                //     child: Icon(
                //       Icons.remove_red_eye,
                //       color: Colors.blue,
                //     ),
                //     onTap: () {
                //       setState(() {
                //         //  _cart.remove(item);
                //       });
                //     }),
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
