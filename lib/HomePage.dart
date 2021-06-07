import 'package:expeditions/UI/Screens/ChatScreen.dart';
import 'package:expeditions/UI/Screens/PlacesOverviewScreen.dart';
import 'package:expeditions/UI/Screens/ProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends StatelessWidget {
  static final id = 'home-page';

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);

  List<Widget> _buildScreens() {
    return [ProfileScreen(), PlacesOverviewScreen(), ChatScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: CupertinoColors.systemGrey3,
        inactiveColorPrimary: CupertinoColors.systemGrey3,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Expeditions"),
        activeColorPrimary: CupertinoColors.systemGrey3,
        inactiveColorPrimary: CupertinoColors.systemGrey3,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.chat_bubble_2),
        title: ("Chat"),
        activeColorPrimary: CupertinoColors.systemGrey3,
        inactiveColorPrimary: CupertinoColors.systemGrey3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      margin: EdgeInsets.all(4),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).primaryColor,
      // Default is Colors.white.
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(16.0),
        colorBehindNavBar: Theme.of(context).backgroundColor,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
