  // ignore_for_file: library_private_types_in_public_api, deprecated_member_use

  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:safeguard/Responsive.dart';
  import 'package:safeguard/model/menu_modal.dart';
  import 'package:flutter_svg/svg.dart';
  import 'package:safeguard/pages/Dashboard/widgets/Statistic.dart';
  import 'package:safeguard/pages/Profile/profile.dart';
  import 'package:safeguard/pages/home/widgets/statistique.dart';
  import 'package:safeguard/pages/widgets/dashboard_page.dart';
  import 'package:safeguard/pages/widgets/history.dart';
  import 'package:safeguard/pages/widgets/notifications.dart';
import 'package:safeguard/pages/widgets/profile/widgets/blog_page.dart';
  import 'package:safeguard/pages/widgets/settings_page.dart';
  import 'package:safeguard/pages/widgets/program/dashboard_page.dart';
  import 'package:safeguard/widgets/map_page.dart';
import 'package:safeguard/widgets/recent_files.dart';


  import 'controller_page.dart';
  import 'cultivate_page.dart';

  class Menu extends StatefulWidget {
    final GlobalKey<ScaffoldState> scaffoldKey;

    const Menu({super.key, required this.scaffoldKey});

    @override
    _MenuState createState() => _MenuState();
  }

  //menu page widgets..
  class _MenuState extends State<Menu> {
    List<MenuModel> menu = [
          MenuModel(icon: 'assets/', title: "Catastrophes"),
        MenuModel(icon: 'assets/svg/remote.svg', title: "Statistics"),
      //I just remove some stuff in this code that I think it will not needed soon.
      //MenuModel(icon: 'assets/svg/share-2.svg', title: "Connect"),
      MenuModel(icon: 'assets/svg/profile.svg', title: "Profile"),
      MenuModel(icon: 'assets/svg/home.svg', title: "Map"),
    MenuModel(icon: 'assets/svg/home.svg', title: "Program"),
      MenuModel(icon: 'assets/svg/history.svg', title: "Statistique"),
          MenuModel(icon: 'assets/svg/remote.svg', title: "Blog"),

      MenuModel(icon: 'assets/svg/signout.svg', title: "Exit"),
    ];

    int selected = 0;

    @override
    Widget build(BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey[800]!,
                width: 1,
              ),
            ),
            color: const Color(0xFF171821)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 40 : 80,
              ),
              for (var i = 0; i < menu.length; i++)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                    color: selected == i
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selected = i;
                      });
                      widget.scaffoldKey.currentState!.closeDrawer();

                      // Navigate to the corresponding page
                      switch (i) {
                        case 0: // Dashboard
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RecentFiles()),
                          );
                          break;
                        case 1: // SignIn
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>  const Statistic()),
                          );
                          break;
                        // Add similar cases for other menu items
                        case 2: //Notification
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>  ProfilePage()),
                          );
                          break;
                        case 3: //History
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>  MapPage()),
                          );
                          break;
                        case 4: //Settings
                            Navigator.of(context).push(
                            MaterialPageRoute(
                                    builder: (context) => DashboardProgram()),
                            );
                          break;
                        case 5: //SignUp
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>   StatistiquesPage())
                          );
                          break;
                               case 6: //Blog
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const BlogPage()),
                        );
                        break;
                    
                        case 7: //Exit
                          SystemNavigator.pop();
                        //close the application
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 7),
                          child: SvgPicture.asset(
                            menu[i].icon,
                            color: selected == i ? Colors.black : Colors.grey,
                          ),
                        ),
                        Text(
                          menu[i].title,
                          style: TextStyle(
                              fontSize: 16,
                              color: selected == i ? Colors.black : Colors.grey,
                              fontWeight: selected == i
                                  ? FontWeight.w600
                                  : FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          )),
        ),
      );
    }
  }
