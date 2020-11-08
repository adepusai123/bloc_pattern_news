import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news_retry_app/bloc/bottom_navbar_bloc.dart';
import 'package:news_retry_app/style/theme.dart';

import 'tabs/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100),
      //   child: AppBar(),
      // ),
      appBar: AppBar(
        title: Text("NewsApp"),
        backgroundColor: AppTheme.mainColor,
      ),
      body: SafeArea(
        child: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            switch (snapshot.data) {
              case NavBarItem.HOME:
                return HomeScreen();
                break;
              case NavBarItem.SOURCES:
                return Text('SOURCES');
                break;
              case NavBarItem.SEARCH:
                return Text('SEARCH');
                break;
            }
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (context, AsyncSnapshot<NavBarItem> snapshot) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[100], spreadRadius: 0, blurRadius: 10)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: snapshot.data.index,
                onTap: _bottomNavBarBloc.pickItem,
                fixedColor: AppTheme.mainColor,
                iconSize: 20,
                items: [
                  BottomNavigationBarItem(
                    label: "Home",
                    icon: Icon(
                      EvaIcons.homeOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.home,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "Sources",
                    icon: Icon(
                      EvaIcons.gridOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.grid,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "Search",
                    icon: Icon(
                      EvaIcons.searchOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.search,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
