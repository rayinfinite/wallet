import 'package:flutter/material.dart';
import 'package:wallet/components/input_sheet.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  String day = 'Today';

  List<ExpenseItem> expenseItems = [];
  double totalExpenseAmount = 0.0;

  @override
  void initState() {
    super.initState();
    expenseItems = [
      ExpenseItem(
          icon: Icons.shopping_cart, expenseTitle: '购物', expenseAmount: 100.0),
      ExpenseItem(
          icon: Icons.restaurant, expenseTitle: '餐饮', expenseAmount: 50.0),
      // 添加更多的 ExpenseItem 对象
    ];
    totalExpenseAmount =
        expenseItems.fold(0.0, (double previousValue, ExpenseItem item) {
      return previousValue + item.expenseAmount;
    });
  }

  String getCurrentDate() {
    // 获取当前日期
    DateTime now = DateTime.now();

    // 使用DateFormat来格式化日期
    String formattedDate = "${now.year}-${now.month}-${now.day}";

    return formattedDate;
  }

  Widget card(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // 设置内边距
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5.0,
        child: Column(
          children: [
            _buildTableHeader(),
            const Divider(height: 0),
            _buildTableBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('日期 ${getCurrentDate()}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('金额 $totalExpenseAmount',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTableBody() {
    return Column(
      children: expenseItems.map((item) {
        return ListTile(
          leading: Icon(item.icon),
          title: Text(item.expenseTitle),
          trailing: Text('\$${item.expenseAmount.toStringAsFixed(2)}'),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListView(
            children: [
              card(context),
            ],
          ),
          const Positioned(
            bottom: 16.0,
            right: 16.0,
            child: InputSheet(),
          ),
        ],
      ),
    );
  }
}

class ExpenseItem {
  final IconData icon;
  final String expenseTitle;
  final double expenseAmount;

  ExpenseItem({
    required this.icon,
    required this.expenseTitle,
    required this.expenseAmount,
  });
}
