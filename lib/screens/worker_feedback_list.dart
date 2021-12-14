import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/feedback.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class FeedBackList extends StatefulWidget {
  @override
  _FeedBackListScreenState createState() => _FeedBackListScreenState();
}

class _FeedBackListScreenState extends State<FeedBackList> {
  // final GlobalKey<FormState> _formKey = GlobalKey();

  bool isInit = true;
  List<MyFeedBack> feedbacks = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      feedbacks.clear();
      Provider.of<JobProvider>(context, listen: false)
          .getClientFeedBackbyid()
          .then((value) {
        if (value != null) {
          feedbacks = value;
        } else {
          value = [];
        }
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
        title: Text('Komentet'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
            );
          },
        ),
      ),
      body: Padding(
        //  key: _formKey,
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: listOfFeedback(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listOfFeedback() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          var item = feedbacks[index];
          return Card(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 5.0, left: 6.0, right: 6.0, bottom: 6.0),
              child: ExpansionTile(
                title: Text(item.clientName),
                children: <Widget>[
                  Text('Adresa:' + item.address),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Komenti: ' + item.feedback),
                  SizedBox(
                    height: 25,
                  )
                ],
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
