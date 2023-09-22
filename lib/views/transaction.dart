import 'package:flutter/material.dart';
import 'package:wallet/components/input_sheet.dart';
import 'package:wallet/components/transaction_data.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<DailyExpense> dailyExpenseList = [
    DailyExpense(),
    DailyExpense(),
    DailyExpense(),
  ];

  Widget _buildTableHeader(DailyExpense daily) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(daily.formattedDate,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('\$ ${daily.totalExpenseAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTableBody(DailyExpense daily) {
    return Column(
      children: daily.expenseItems.map((item) {
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
    return Stack(
      children: [
        ListView(
          children: [
            ...dailyExpenseList.map((daily) {
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: daily.isExpanded,
                  title: _buildTableHeader(daily),
                  children: [_buildTableBody(daily)],
                ),
              );
            }).toList(),
          ],
        ),
        const Positioned(bottom: 16, right: 16, child: InputSheet()),
      ],
    );
  }
}
