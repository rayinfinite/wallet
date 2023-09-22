import 'package:flutter/material.dart';

class DailyExpense {
  List<ExpenseItem> expenseItems = [];
  double totalExpenseAmount = 0.0;
  DateTime date = DateTime.now();
  String formattedDate = "";
  bool isExpanded = true;

  DailyExpense() {
    expenseItems = [
      ExpenseItem(id: 0, expenseAmount: 100.0),
      ExpenseItem(id: 1, expenseAmount: 50.0),
      // 添加更多的 ExpenseItem 对象
    ];
    totalExpenseAmount =
        expenseItems.fold(0.0, (double previousValue, ExpenseItem item) {
      return previousValue + item.expenseAmount;
    });
    date = expenseItems[0].date;
    formattedDate = "${date.year}-${date.month}-${date.day}";
  }
}

class ExpenseItem {
  final int id;
  final IconData icon;
  final String expenseTitle;
  final double expenseAmount;
  final DateTime date;

  ExpenseItem({
    required this.id,
    required this.expenseAmount,
    DateTime? date,
  })  : date = date ?? DateTime.now(),
        icon = Catagory.icons[id]!,
        expenseTitle = Catagory.names[id]!;
}

class Catagory {
  Catagory();
  static int positive = 0;
  static int negative = -1;
  static Map<int, String> names = {
    0: "Shopping",
    1: "Food",
    2: "Transportation",
    3: "Entertainment",
    4: "Health",
    5: "Others",
  };
  static Map<int, IconData> icons = {
    0: Icons.shopping_cart,
    1: Icons.restaurant,
    2: Icons.directions_car,
    3: Icons.movie,
    4: Icons.local_hospital,
    5: Icons.more_horiz,
  };
  static void add(bool isPositive, String name, IconData icon) {
    if (isPositive) {
      names[positive] = name;
      icons[positive] = icon;
      positive++;
    } else {
      names[negative] = name;
      icons[negative] = icon;
      negative--;
    }
  }
}
