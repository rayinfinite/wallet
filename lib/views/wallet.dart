import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../components/linearPercentIndicator.dart';
import '../components/wave_progress.dart';

class Wallet extends StatelessWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          styleText("Accounts", ""),
          const SizedBox(height: 20),
          Row(
            children: [
              accountCard("Cash", 35.170, context),
              const SizedBox(width: 20),
              accountCard("Credit Debt", -4320, context),
            ],
          ),
          const SizedBox(height: 20),
          styleText("Spending    ", "July 2018"),
          const SizedBox(height: 20),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: Row(children: [
              SizedBox(
                height: 200,
                width: 200,
                child: pieChart(),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //TODO: fix overflow
                donutCard(Colors.indigo, "Home"),
                donutCard(Colors.yellow, "Food & Drink"),
                donutCard(Colors.greenAccent, "Hotel & Restaurant"),
                donutCard(Colors.pinkAccent, "Travelling"),
                donutCard(Colors.blueAccent, "Shopping"),
              ])
            ]),
          ),
          const SizedBox(height: 20),
          styleText("Budget      ", "   July"),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: LinearPercentIndicator(
              width: media.width - 50,
              lineHeight: 20.0,
              percent: 0.68,
              backgroundColor: Colors.grey.shade300,
              progressColor: Color(0xFF1b52ff),
              animation: true,
              animateFromLastPercent: true,
              alignment: MainAxisAlignment.spaceEvenly,
              animationDuration: 1000,
              linearStrokeCap: LinearStrokeCap.roundAll,
              center: Text(
                "68.0%",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          styleText("Cash flow", ""),
          const SizedBox(height: 20),
          waveCard(
            context,
            "Earned",
            200,
            1,
            Color(0xFF716cff),
          ),
          waveCard(
            context,
            "Spent",
            3210,
            -1,
            Color(0xFFff596b),
          ),
        ],
      ),
    );
  }

  Widget waveCard(BuildContext context, String name, double amount, int type,
      Color bgColor) {
    Color fillColor = Colors.grey.shade100,
    return Container(
      margin: EdgeInsets.only(
        top: 15,
        right: 20,
      ),
      padding: EdgeInsets.only(left: 15),
      height: screenAwareSize(80, context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            spreadRadius: 10,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              WaveProgress(
                screenAwareSize(45, context),
                fillColor,
                bgColor,
                67,
              ),
              Text(
                "80%",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${type > 0 ? "" : "-"} \$ ${amount.toString()}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget accountCard(String account, double amount, BuildContext context) {
    final media = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      width: media.width / 2 - 30,
      height: media.height / 6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(.4),
                blurRadius: 16,
                spreadRadius: 0.2,
                offset: const Offset(0, 8)),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(account,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
          Text(amount >= 0 ? "\$ $amount" : "- \$ ${-amount}",
              style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget styleText(String text, String text2) {
    return Row(
      children: [
        Text(text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(text2,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16))
      ],
    );
  }

  Widget donutCard(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 20, height: 30),
        Text(
          text,
          style: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        )
      ],
    );
  }

  Widget pieChart() {
    bool rebuild = false;
    const basicData = [
      {'genre': 'Sports', 'sold': 275},
      {'genre': 'Strategy', 'sold': 115},
      {'genre': 'Action', 'sold': 120},
      {'genre': 'Shooter', 'sold': 350},
      {'genre': 'Other', 'sold': 150},
    ];
    return Chart(
      rebuild: rebuild,
      data: basicData,
      variables: {
        'genre': Variable(
          accessor: (Map map) => map['genre'] as String,
        ),
        'sold': Variable(
          accessor: (Map map) => map['sold'] as num,
        ),
      },
      transforms: [
        Proportion(
          variable: 'sold',
          as: 'percent',
        )
      ],
      marks: [
        IntervalMark(
          position: Varset('percent') / Varset('genre'),
          label: LabelEncode(
              encoder: (tuple) => Label(
                    tuple['sold'].toString(),
                    LabelStyle(textStyle: Defaults.runeStyle),
                  )),
          color: ColorEncode(variable: 'genre', values: Defaults.colors10),
          modifiers: [StackModifier()],
          transition: Transition(duration: const Duration(seconds: 1)),
          entrance: {MarkEntrance.y},
        )
      ],
      coord: PolarCoord(transposed: true, dimCount: 1),
    );
  }
}
