import 'package:budget_tracker/styles/app_color.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  String category;
  IconData icon;

  CategoryModel({required this.category, required this.icon});
}

List<CategoryModel> expenseCategories = [
  CategoryModel(
    category: "Food",
    icon: Icons.restaurant,
  ),
  CategoryModel(
    category: "Housing",
    icon: Icons.home,
  ),
  CategoryModel(
    category: "Transportation",
    icon: Icons.directions_car,
  ),
  CategoryModel(
    category: "Shopping",
    icon: Icons.shopping_bag,
  ),
  CategoryModel(
    category: "Others",
    icon: Icons.more_horiz,
  ),
];
List<CategoryModel> incomeCategories = [
  CategoryModel(
    category: "Salary",
    icon: Icons.attach_money,
  ),
  CategoryModel(
    category: "Business",
    icon: Icons.business_center,
  ),
  CategoryModel(
    category: "Freelance",
    icon: Icons.work_outline,
  ),
  CategoryModel(
    category: "Investments",
    icon: Icons.trending_up,
  ),
  CategoryModel(
    category: "Others",
    icon: Icons.more_horiz,
  ),
];
