import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/dish.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/cart.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class BejPorosi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: ProductList(title: 'Bëj Porosi'),
    );
  }
}

class ProductList extends StatefulWidget {
  ProductList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool isInit = true;

  // ignore: deprecated_member_use
  List<Dish> _dishes = List<Dish>();

  // ignore: deprecated_member_use
  List<Dish> _cartList = List<Dish>();

  // @override
  // void initState() {
  //   super.initState();
  //   _populateDishes();
  // }

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false).getAllProds().then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        title: Text('Bëj Porosi'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
              color: Colors.white,
            );
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 36.0,
                    color: Colors.white,
                  ),
                  if (_cartList.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          _cartList.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                if (_cartList.isNotEmpty)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Cart(_cartList),
                    ),
                  );
              },
            ),
          )
        ],
      ),
      body: _buildGridView(),
    );
  }

  ListView _buildListView() {
    _dishes = Provider.of<Customer>(context).allprods;
    return ListView.builder(
      itemCount: _dishes.length,
      itemBuilder: (context, index) {
        var item = _dishes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 2.0,
          ),
          child: Card(
            elevation: 4.0,
            child: ListTile(
              leading: Icon(
                item.icon,
                color: item.color,
              ),
              title: Text(item.product_name),
              trailing: GestureDetector(
                child: (!_cartList.contains(item))
                    ? Icon(
                        Icons.add_circle,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                onTap: () {
                  setState(() {
                    if (!_cartList.contains(item))
                      _cartList.add(item);
                    else
                      _cartList.remove(item);
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  GridView _buildGridView() {
    _dishes = Provider.of<Customer>(context).allprods;
    return GridView.builder(
        padding: const EdgeInsets.all(4.0),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _dishes.length,
        itemBuilder: (context, index) {
          var item = _dishes[index];
          return Card(
              elevation: 5.0,
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Icon(
                      //   item.icon,
                      //   color: (_cartList.contains(item))
                      //       ? Colors.grey
                      //       : item.color,
                      //   size: 100.0,
                      // ),
                      Image.network(
                        item.product_image,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        item.product_name,
                        textAlign: TextAlign.center,
                        //style: Theme.of(context).textTheme.subhead,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: (!_cartList.contains(item))
                            ? Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                        onTap: () {
                          setState(() {
                            if (!_cartList.contains(item))
                              _cartList.add(item);
                            else
                              _cartList.remove(item);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  // void _populateDishes() {
  //   var dish = Provider.of<Customer>(context).allprods;
  // var list = <Dish>[
  //   Dish(
  //     product_name: 'Chicken Zinger',
  //     icon: Icons.fastfood,
  //     color: Colors.amber,
  //   ),
  //   Dish(
  //     product_name: 'Chicken Zinger without chicken',
  //     icon: Icons.print,
  //     color: Colors.deepOrange,
  //   ),
  //   Dish(
  //     product_name: 'Rice',
  //     icon: Icons.child_care,
  //     color: Colors.brown,
  //   ),
  //   Dish(
  //     product_name: 'Beef burger without beef',
  //     icon: Icons.whatshot,
  //     color: Colors.green,
  //   ),
  //   Dish(
  //     product_name: 'Laptop without OS',
  //     icon: Icons.laptop,
  //     color: Colors.purple,
  //   ),
  //   Dish(
  //     product_name: 'Mac wihout macOS',
  //     icon: Icons.laptop_mac,
  //     color: Colors.blueGrey,
  //   ),
  // ];

  //   setState(() {
  //     _dishes = dish;
  //   });
  // }
}
