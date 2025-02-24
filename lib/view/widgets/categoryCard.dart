import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData iconData;
  final String categoryName;
  const CategoryCard({super.key, required this.iconData, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      // margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2)
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1)// Add a border using Border.all
              ),
            ),
            child: Icon(iconData, color: Theme.of(context).colorScheme.primary,),
          ),
          Text(categoryName),

        ],
      ),
    );
  }
}
