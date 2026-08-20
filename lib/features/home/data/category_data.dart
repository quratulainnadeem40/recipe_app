import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData icon;

  CategoryModel({
    required this.name,
    required this.icon,
  });
}

final List<CategoryModel> categoryList = [
  CategoryModel(name: 'Beef', icon: Icons.dinner_dining),
  CategoryModel(name: 'Chicken', icon: Icons.restaurant_menu),
  CategoryModel(name: 'Dessert', icon: Icons.cake_rounded),
  CategoryModel(name: 'Lamb', icon: Icons.outdoor_grill),
  CategoryModel(name: 'Miscellaneous', icon: Icons.space_dashboard_rounded),
  CategoryModel(name: 'Pasta', icon: Icons.ramen_dining),
  CategoryModel(name: 'Pork', icon: Icons.lunch_dining),
  CategoryModel(name: 'Seafood', icon: Icons.set_meal_rounded),
  CategoryModel(name: 'Side', icon: Icons.rice_bowl_rounded),
  CategoryModel(name: 'Starter', icon: Icons.local_pizza_rounded),
  CategoryModel(name: 'Vegan', icon: Icons.eco_rounded),
  CategoryModel(name: 'Vegetarian', icon: Icons.grass_rounded),
  CategoryModel(name: 'Breakfast', icon: Icons.free_breakfast_rounded),
  CategoryModel(name: 'Goat', icon: Icons.set_meal_outlined),
];