import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/artist_bookings_screen.dart';
import 'package:service_app/screens/chats_screen.dart';
import 'package:service_app/screens/notifications_screen.dart';
import 'package:service_app/screens/product_list.dart';
import 'package:service_app/screens/shto_tikete.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/screens/worker_addFeedback.dart';
import 'package:service_app/screens/worker_addworkOrder.dart';
import 'package:service_app/screens/worker_assigned_worklist.dart';

import '../customer_profile_screen.dart';
import '../worker_list_of_work.dart';
import '../worker_allclients.dart';

class BottomFFNavbarWidget extends StatefulWidget {
  final int index;
  const BottomFFNavbarWidget({
    Key key,
    @required this.index,
  }) : super(key: key);

  @override
  _BottomFFNavbarWidgetState createState() => _BottomFFNavbarWidgetState();
}

class _BottomFFNavbarWidgetState extends State<BottomFFNavbarWidget> {
  @override
  Widget build(BuildContext context) {
    final isCustomer = Provider.of<Auth>(context).currentUser.isCustomer;
    return FFNavigationBar(
      items: [
        FFNavigationBarItem(
          iconData: Icons.home,
          label: 'Dashboard',
        ),
        FFNavigationBarItem(
          iconData: Icons.add_box,
          label: 'Shto Tikete',
        ),
        isCustomer
            ? FFNavigationBarItem(
                iconData: Icons.shopping_bag_outlined,
                label: 'Bej Porosi',
              )
            : FFNavigationBarItem(
                iconData: Icons.work_outline_outlined,
                label: 'Të Hapura',
              ),
        FFNavigationBarItem(
          iconData: Icons.settings,
          label: 'Profili',
        ),
      ],
      onSelectTab: (index) {
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed('/');
            break;
          case 1:
            isCustomer
                ? Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => CustomDrawer(
                        child: ShtoTikete(),
                      ),
                    ),
                  )
                : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => CustomDrawer(
                        child: WorkerAllClients(),
                      ),
                    ),
                  );
            break;
          case 2:
            isCustomer
                ? Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => CustomDrawer(
                        child: BejPorosi(),
                      ),
                    ),
                  )
                : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => CustomDrawer(
                        child: AssignedWorkList(),
                      ),
                    ),
                  );
            break;
          case 3:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => CustomDrawer(
                  child: CustomerProfileScreen(),
                ),
              ),
            );
            break;
          // case 4:
          //   Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(
          //       builder: (ctx) => CustomDrawer(
          //         child: ShtoTikete(),
          //       ),
          //     ),
          //   );
          //   break;
        }
      },
      theme: FFNavigationBarTheme(
        selectedItemTextStyle: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.bold),
        unselectedItemTextStyle: Theme.of(context).textTheme.headline6,
        barBackgroundColor: Colors.white,
        selectedItemBorderColor: Theme.of(context).accentColor,
        selectedItemBackgroundColor: Theme.of(context).primaryColor,
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.black,
        showSelectedItemShadow: true,
        barHeight: 60,
      ),
      selectedIndex: widget.index,
    );
  }
}
