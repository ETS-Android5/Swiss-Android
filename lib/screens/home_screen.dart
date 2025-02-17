import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/category.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/artist_applied_jobs_screen.dart';
import 'package:service_app/screens/edit_artist_profile_screen.dart';
import 'package:service_app/screens/near_by_screen.dart';
import 'package:service_app/screens/widgets/artist_job_item_widget.dart';
import 'package:service_app/screens/widgets/artists_list_widget.dart';
import 'package:service_app/screens/widgets/bottom_ff_navbar_widget.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/Global.dart';
import 'package:service_app/screens/customer_profile_screen.dart';
import 'package:service_app/screens/artist_profile_screen.dart';
import 'package:service_app/screens/widgets/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isIos;
  bool _isInit = true;
  String _catName = 'Select Category';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Global.incompleteProfile && Global.completeLater == false)
        await _showIncompleteProfileDialog();
      //Global.recordTheNumber(context, Global.userPhoneNumber);
    });
  }

  Future<void> _showIncompleteProfileDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Incomplete Profile',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Global.user.isCustomer
                    ? Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => CustomDrawer(
                            child: CustomerProfileScreen(),
                          ),
                        ),
                      )
                    : Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => CustomDrawer(
                            child: ArtistProfileScreen(),
                          ),
                        ),
                      );
              },
              child: Text(
                'Ok',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Global.completeLater = true;
                Navigator.pop(context);
              },
              child: Text(
                'Later',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
          content: Container(
            child: Text(
              'Please complete your Profile',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<JobProvider>(context, listen: false)
          .fetchSliderImages()
          .then((value) {
        Provider.of<Auth>(context, listen: false).currentUser.isCustomer
            ? Provider.of<Customer>(context, listen: false)
                .getAllCategories()
                .then(
                  (value) => setState(() {
                    _isInit = false;
                  }),
                )
            : Provider.of<JobProvider>(context, listen: false)
                .getAllJobs()
                .then(
                  (value) => setState(() {
                    _isInit = false;
                  }),
                );
      });
    }
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Mbyll Swiss Med?'),
            content: new Text('Dëshironi të mbyllni App?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget setupAlertDialoadContainer(List<Category> subCategories) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 2,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: subCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              setState(() {
                _catName = subCategories[index].name;
              });
              Provider.of<Customer>(context, listen: false)
                  .filterByCategories(subCategories[index].id);
              Navigator.of(context).pop();
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subCategories[index].name),
                Container(
                  child: Image.network(subCategories[index].image),
                  height: 50,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showSubCategoryDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        List<Category> subCategories =
            Provider.of<Customer>(context).subCategoriesList;
        return subCategories.length <= 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : AlertDialog(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  'Select Subcategory',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
                content: setupAlertDialoadContainer(subCategories),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final images = Provider.of<JobProvider>(context).images;
    final categories = Provider.of<Customer>(context).categories;
    final subCategories = Provider.of<Customer>(context).subCategoriesList;
    final user = Provider.of<Auth>(context).currentUser;
    final jobs = Provider.of<JobProvider>(context).artistJobs;
    final List<Widget> categoriesItems = categories
        .map(
          (category) => Padding(
            padding: EdgeInsets.only(right: 4.0, top: 4.0, bottom: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: InkWell(
                onTap: () {
                  if (category.subCategories > 0) {
                    Provider.of<Customer>(context, listen: false)
                        .getSubCategories(category.id);
                    _showSubCategoryDialog();
                  } else {
                    setState(() {
                      _catName = category.name;
                    });
                    Provider.of<Customer>(context, listen: false)
                        .filterByCategories(category.id);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(bottom: 12.0),
                        height: (deviceSize.width - 16) / 3,
                        width: (deviceSize.width - 16) / 3,
                        child:
                            category.image != null && category.image.isNotEmpty
                                ? Image.network(
                                    category.image,
                                    errorBuilder: (ctx, obj, _) {
                                      return Icon(
                                        CupertinoIcons.photo,
                                        size: 55,
                                        color: Theme.of(context).primaryColor,
                                      );
                                    },
                                  )
                                : Icon(
                                    CupertinoIcons.photo,
                                    size: 55,
                                    color: Theme.of(context).primaryColor,
                                  ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      left: 4,
                      right: 4,
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${category.name}',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
    categoriesItems.insert(
      0,
      Padding(
        padding: EdgeInsets.only(right: 4.0, top: 4.0, bottom: 4.0),
        child: InkWell(
          onTap: () {
            setState(() {
              _catName = 'All Categories';
            });
            Provider.of<Customer>(context, listen: false)
                .filterByCategories('all');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 12.0),
                    color: Colors.white,
                    height: (deviceSize.width - 16) / 3,
                    width: (deviceSize.width - 16) / 3,
                    child: Icon(
                      Icons.category,
                      color: Theme.of(context).primaryColor,
                      size: 55,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  left: 4,
                  right: 4,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'All Categories',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context).primaryColor, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          bottomNavigationBar: BottomFFNavbarWidget(
            index: 0,
          ),
          // floatingActionButton: user.isCustomer
          //     ? FloatingActionButton.extended(
          //         onPressed: () {
          //           Navigator.of(context).pushNamed(NearByScreen.routeName);
          //         },
          //         label: Text(
          //           'Nearby',
          //           style: Theme.of(context)
          //               .textTheme
          //               .headline6
          //               .copyWith(color: Colors.white),
          //         ),
          //       )
          //     : FloatingActionButton.extended(
          //         onPressed: () {
          //           Navigator.of(context)
          //               .pushNamed(ArtistAppliedJobsScreen.routeName);
          //         },
          //         label: Text(
          //           'Applied Jobs',
          //           style: Theme.of(context)
          //               .textTheme
          //               .headline6
          //               .copyWith(color: Colors.white),
          //         ),
          //       ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(user.isCustomer ? 'Shërbim' : 'Dashboard'),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => CustomDrawer.of(context).open(),
                );
              },
            ),
          ),
          body: _isInit
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : NestedScrollView(
                  headerSliverBuilder: (ctx, _) => [
                        if (user.isCustomer)
                          // SliverToBoxAdapter(
                          //   child: Padding(
                          //     padding: EdgeInsets.only(bottom: 4.0),
                          //     child: Card(
                          //       color: Theme.of(context).primaryColor,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10.0),
                          //       ),
                          //       elevation: 8.0,
                          //       child: Container(
                          //         height: (deviceSize.width - 16) / 4,
                          //         width: (deviceSize.width - 16),
                          //         padding: EdgeInsets.all(4.0),
                          //         child: CarouselSlider(
                          //           options: CarouselOptions(
                          //             viewportFraction: 0.25,
                          //             autoPlay: false,
                          //             aspectRatio: 1.3,
                          //             enlargeCenterPage: false,
                          //           ),
                          //           items: categoriesItems,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: 4.0, left: 4.0, top: 10.0),
                              height: deviceSize.height / 5,
                              width: deviceSize.width,
                              child: Carousel(
                                boxFit: BoxFit.cover,
                                dotSpacing: 15.0,
                                images: images
                                    .skip(1)
                                    .map(
                                      (url) => Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, exception, _) =>
                                            Icon(
                                          Icons.image,
                                          size: 60,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                autoplay: true,
                                animationCurve: Curves.fastOutSlowIn,
                                animationDuration: Duration(milliseconds: 1000),
                                dotSize: 6.0,
                                dotBgColor: Colors.transparent,
                                dotVerticalPadding: 1.0,
                                autoplayDuration: Duration(seconds: 10),
                              ),
                            ),
                          ),
                      ],
                  body:
                      //user.isCustomer
                      //  ?
                      PieChart()
                  // : Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: jobs.length <= 0
                  //         ? Center(
                  //             child: Text(
                  //               'No jobs available!',
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .headline6
                  //                   .copyWith(
                  //                     color: Theme.of(context).primaryColor,
                  //                     fontSize: 18,
                  //                   ),
                  //             ),
                  //           )
                  //         : ListView.builder(
                  //             itemCount: jobs.length,
                  //             itemBuilder: (ctx, i) =>
                  //                 ChangeNotifierProvider.value(
                  //               value: jobs[i],
                  //               child: ArtistJobItemWidget(),
                  //             ),
                  //           ),
                  //   ),
                  ),
        ),
      ),
    );
  }
}
