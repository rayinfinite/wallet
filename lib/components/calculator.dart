import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Calculator'),
        ),
        body: Center(
            child: Container(
          constraints: const BoxConstraints(
            maxWidth: 340.0,
            maxHeight: 400,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // 边框颜色
              width: 2.0, // 边框宽度
            ),
          ),
          child: const MyCalculator(),
        )),
      ),
    );
  }
}

class MyCalculator extends StatefulWidget {
  const MyCalculator({super.key});

  @override
  MyCalculatorState createState() => MyCalculatorState();
}

class MyCalculatorState extends State<MyCalculator> {
  String first = '';
  String second = '';
  String expression = '';
  String operator = '';
  DateTime? selectedDate;
  static const String operators = "+-*/";

  void _onPressed(String button) {
    setState(() {
      expression += button;
      if (button == 'C') {
        expression = '';
        second = '';
        first = '';
        operator = '';
      } else if (button == '=') {
        second = calculate();
        first = '';
        operator = '';
        expression = expression.substring(0, expression.length - 1);
      } else if (operators.contains(button)) {
        first = calculate();
        operator = button;
        second = '';
      } else {
        second += button;
      }
    });
  }

  String calculate() {
    switch (operator) {
      case '+':
        return (double.parse(first) + double.parse(second)).toString();
      case '-':
        return (double.parse(first) - double.parse(second)).toString();
      case '*':
        double number = double.parse(first) * double.parse(second);
        number = (number * 100).ceilToDouble() / 100;
        return number.toString();
      case '/':
        if (double.parse(second) == 0) {
          return 'Error';
        }
        double number = double.parse(first) / double.parse(second);
        number = (number * 100).ceilToDouble() / 100;
        return number.toString();
      case '':
        return second;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 显示表达式
        Text(
          expression,
          style: const TextStyle(fontSize: 24, color: Colors.blue),
        ),
        // 显示结果
        Text(
          first + operator + second,
          style: const TextStyle(fontSize: 24, color: Colors.red),
        ),
        // 按钮
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  minWidth:300,
                  child: Text(first + operator + second),
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.credit_card),
                ),
                MaterialButton(
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 10),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    setState(() {
                      selectedDate = date;
                      if (selectedDate != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                        ));
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.calendar_month),
                ),
                MaterialButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.add),
                ),
                _button('='),
              ],
            ),
            Row(
              children: [
                _button('/'),
                _button('1'),
                _button('2'),
                _button('3'),
              ],
            ),
            Row(
              children: [
                _button('*'),
                _button('4'),
                _button('5'),
                _button('6'),
              ],
            ),
            Row(
              children: [
                _button('-'),
                _button('7'),
                _button('8'),
                _button('9'),
              ],
            ),
            Row(
              children: [
                _button('+'),
                _button('.'),
                _button('0'),
                _button('C'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _button(String text) {
    return MaterialButton(
      onPressed: () => _onPressed(text),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text),
    );
  }
}
