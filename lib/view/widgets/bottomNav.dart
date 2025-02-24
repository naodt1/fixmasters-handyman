import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconly/iconly.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        height: kBottomNavigationBarHeight + 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () => onTap(0),
              icon: Icon(
                currentIndex ==0  ? IconlyBold.graph : IconlyLight.graph,
                color: currentIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            IconButton(
              onPressed: () => onTap(1),
              icon: Icon(
                currentIndex == 1  ? IconlyBold.calendar : IconlyLight.calendar,
                color: currentIndex == 1
                    ?  Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),

            ),
            IconButton(
              onPressed: () => onTap(2),
              icon: Icon(
                currentIndex == 2  ? IconlyBold.chat : IconlyLight.chat,
                color: currentIndex == 2
                    ?  Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            IconButton(
              onPressed: () => onTap(3),
              icon: Icon(
                currentIndex == 3  ? IconlyBold.profile : IconlyLight.profile,
                color: currentIndex == 3
                    ?  Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}