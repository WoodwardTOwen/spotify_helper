import 'package:flutter/material.dart';

class CategoryListTile extends StatelessWidget {
  final String categoryName;

  const CategoryListTile({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        tileColor: Theme.of(context).colorScheme.primary,
        title: Text(
          categoryName,
          style: const TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              color: Colors.white),
          maxLines: 1,
        ),
        trailing: const Icon(
          Icons.sports_gymnastics,
          color: Colors.white,
        ),
      ),
    );
  }
}
