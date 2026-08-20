import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  final Function(String) onFilterSelected;

  const SearchFilter({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Breakfast', 'Chicken', 'Dessert', 'Side'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}