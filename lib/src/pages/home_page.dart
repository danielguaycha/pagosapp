import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pagosapp/src/pages/index_page.dart';
// import 'package:pagosapp/src/pages/payments/add_expense_page.dart';
import 'package:pagosapp/src/pages/payments/list_expense_page.dart';
import 'package:pagosapp/src/plugins/style.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime backbuttonpressedTime;
  PageController _pageController;
  int _currentIndex = 0;

  final List<Widget> _children = [
      IndexPage(),
      ListExpensePage(),
      Center(child: Text("Hola")),
  ]; 

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: _children[_currentIndex], // new
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _children
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Style.primary,
        selectedItemColor: Style.secondary[400],
        elevation: 12,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex, // new
        items:<BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: Text("Home"),
          ),          
          BottomNavigationBarItem(
            icon: new Icon(Icons.plus_one),
            title: Text("Gastos"),
          ),          
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Usuario')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 10), curve: Curves.decelerate);
    });
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
    if (backButton) {
      backbuttonpressedTime = currentTime;      
      Fluttertoast.showToast(
        msg: "Presione nuevamente para salir",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0
      );
      return false;
    }    
    return true;
  }
}