import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/work_order.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:service_app/screens/worker_complete_job.dart';

class AssignedWorkList extends StatefulWidget {
  @override
  _AssignedWorkListScreenState createState() => _AssignedWorkListScreenState();
}

class _AssignedWorkListScreenState extends State<AssignedWorkList> {
  // final GlobalKey<FormState> _formKey = GlobalKey();

  bool isInit = true;
  bool isListVisible = false;
  bool isSuccess = false;

  int _selectedtype = 1;
  List<WorkOrder> workOrders = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      onSelectedDropDownChanged();
    }
    super.didChangeDependencies();
  }

  void onSelectedDropDownChanged() {
    isListVisible = true;
    workOrders.clear();
    Provider.of<JobProvider>(context, listen: false)
        .workerListOfWork('1')
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
              child: Slidable(
                actionPane: SlidableScrollActionPane(),
                actionExtentRatio: 0.25,
                actions: <Widget>[
                  new IconSlideAction(
                    caption: 'Përfundo',
                    color: Colors.green,
                    icon: Icons.done_all,
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => CustomDrawer(
                          child: CompleteJob(
                            workOrderId: workOrders[index].workOrderId,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new IconSlideAction(
                    caption: 'Anullo',
                    color: Colors.red,
                    icon: Icons.cancel,
                    onTap: () {
                      Provider.of<JobProvider>(context, listen: false)
                          .woNotComplete(workOrders[index].workOrderId)
                          .then((isSuccess) {
                        // Navigator.of(context).pop();
                        _showMessageDialog(isSuccess
                                ? 'Puna u shënua e papërfunduar'
                                : 'Ndodhi një gabim!')
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CustomDrawer(
                                    child: super.widget,
                                  ),
                                )));
                      });
                    },
                  ),
                ],
                child: ListTile(
                  leading: Icon(Icons.work),
                  title: Text(item.productName),
                  subtitle: Text(item.serialNumber),
                  // trailing: GestureDetector(
                  //     child: Icon(
                  //       Icons.search,
                  //       color: Colors.blue,
                  //     ),
                  //     onTap: () {
                  //       setState(() {
                  //         //  _cart.remove(item);
                  //       });
                  //     }),
                ),
              ),
            ),
          );
        });
  }

  // showLoadingDialog(BuildContext ctx) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: ctx,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: new Row(
  //           children: [
  //             CircularProgressIndicator(),
  //             Container(
  //               margin: EdgeInsets.only(left: 7),
  //               child: Text("Please Wait..."),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
}
