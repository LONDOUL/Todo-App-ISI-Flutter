import 'package:flutter/material.dart';
import 'package:todo_app/common/commons.dart';
import 'package:todo_app/common/menu_item.dart';

class MenuScreen extends StatefulWidget {
  final VoidCallback toggleMenu;
  const MenuScreen({super.key, required this.toggleMenu});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: screenWidth * .15),
        color: primaryBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80.0,
            ),
            // Bouton de retour
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * .32),
                  child: IconButton(
                    icon: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: Colors.white.withOpacity(.15),
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: widget.toggleMenu,
                  ),
                ),
              ],
            ),
            // L'avatar
            Container(
              padding: const EdgeInsets.all(5.0),
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 3.0,
                    color: businessIndicator,
                  ),
                  shape: BoxShape.circle),
              child: const CircleAvatar(
                foregroundImage: AssetImage("assets/images/logo.jpeg"),
              ),
            ),
            // Le nom d'utilisateur
            const Text(
              "M. Amédée",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            //Menu Items
            const MenuItem(
              icon: Icons.bookmark_outline_rounded,
              title: "Templates",
            ),
            const MenuItem(
              icon: Icons.grid_view_rounded,
              title: "Catégories",
            ),
            const MenuItem(
              icon: Icons.pie_chart_rounded,
              title: "Analyses",
            ),
            //Le text du Bas
            Expanded(
              child: Container(),
            ),
            RichText(
              text: TextSpan(
                  text: "Conçu par\n\n",
                  style: TextStyle(
                      color: Colors.white.withOpacity(.3),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800),
                  children: const <TextSpan>[
                    TextSpan(
                      text: "Amédée NADJILEM LONDOUL",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 40.0,
            )
          ],
        ),
      ),
    );
  }
}
