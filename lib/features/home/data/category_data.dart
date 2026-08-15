import 'package:flutter/material.dart';

class CategoryData {
  final String name;
  final IconData icon;

  const CategoryData({
    required this.name,
    required this.icon,
  });
}

class CategoryList {
  static const List<CategoryData> categories = [
    CategoryData(
      name: 'Chicken',
      icon: Icons.restaurant_rounded,
    ),
    CategoryData(
      name: 'Beef',
      icon: Icons.lunch_dining_rounded,
    ),
    CategoryData(
      name: 'Dessert',
      icon: Icons.cake_rounded,
    ),
    CategoryData(
      name: 'Seafood',
      icon: Icons.set_meal_rounded,
    ),
    CategoryData(
      name: 'Pasta',
      icon: Icons.ramen_dining_rounded,
    ),
    CategoryData(
      name: 'Vegetarian',
      icon: Icons.eco_rounded,
    ),
    CategoryData(
      name: 'Breakfast',
      icon: Icons.breakfast_dining_rounded,
    ),
    CategoryData(
      name: 'Lamb',
      icon: Icons.dinner_dining_rounded,
    ),
  ];
}