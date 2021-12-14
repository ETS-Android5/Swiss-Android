import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/dish.dart';
import 'package:service_app/providers/customer.dart';

class Cart extends StatefulWidget {
  final List<Dish> _cart;

  Cart(this._cart);

  @override
  _CartState createState() => _CartState(this._cart);
}

class _CartState extends State<Cart> {
  _CartState(this._cart);

  List<Dish> _cart;
  List<String> cartIds = List<String>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shporta'),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
      ),
      body: ListView.builder(
          itemCount: _cart.length,
          itemBuilder: (context, index) {
            var item = _cart[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  leading: Image.network(item.product_image),
                  title: Text(item.product_name),
                  trailing: GestureDetector(
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          _cart.remove(item);
                        });
                      }),
                ),
              ),
            );
          }),
      floatingActionButton: test(),
    );
  }

  Widget test() {
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: () {
          List<String> cartIds = [];
          if (widget._cart.isNotEmpty) {
            cartIds.clear();
            for (int i = 0; i < widget._cart.length; i++) {
              cartIds.add(widget._cart[i].id);
            }
            print(cartIds);
          }
          Provider.of<Customer>(context, listen: false)
              .addClientOrder(cartIds)
              .then((value) => {Navigator.of(context).pop()});
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Porosit tani",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
