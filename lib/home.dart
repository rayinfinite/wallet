import 'package:flutter/material.dart';
import 'package:wallet/views/transaction.dart';
import 'package:wallet/views/wallet.dart';

import 'views/charts.dart';
import 'views/component_screen.dart';
import 'components/constants.dart';
import 'views/lineChart.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.useLightMode,
    required this.color,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
    required this.loadData,
  });

  final bool useLightMode;
  final ColorSeed color;

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function(int value) handleColorSelect;
  final Future<void> Function() loadData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool showSmallLayout = false;
  int screenIndex = 0; //0-3

//屏幕Layout大小
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double width = MediaQuery.of(context).size.width;
    showSmallLayout = width <= mediumWidthBreakpoint;
  }

//第一页太宽了可以有两列
  Widget responsiveColumnLayout(Widget one, Widget two) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: one,
        ),
        if (!showSmallLayout)
          Flexible(
            flex: 1,
            child: two,
          )
      ],
    );
  }

//main
  Widget createScreenFor() {
    switch (screenIndex) {
      case 0:
        return const Transaction();
      case 1:
        return const Charts();
      case 2:
        return const Wallet();
      case 3:
        return Expanded(
          child: responsiveColumnLayout(
            FirstComponentList(
                showNavBottomBar: true,
                scaffoldKey: scaffoldKey,
                showSecondList: !showSmallLayout),
            SecondComponentList(
              scaffoldKey: scaffoldKey,
            ),
          ),
        );
      default:
        return Container();
    }
  }

//AppBar
  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: const Text('Wallet'),
      actions: showSmallLayout
          ? [
              _BrightnessButton(
                handleBrightnessChange: widget.handleBrightnessChange,
              ),
              _ColorSeedButton(
                handleColorSelect: widget.handleColorSelect,
                color: widget.color,
              ),
            ]
          : [Container()],
    );
  }

//大屏时的按钮
  Widget _trailingActions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _BrightnessButton(
            handleBrightnessChange: widget.handleBrightnessChange,
            showTooltipBelow: false,
          ),
          const SizedBox(
            height: 20,
          ),
          _ColorSeedButton(
            handleColorSelect: widget.handleColorSelect,
            color: widget.color,
          ),
        ],
      ),
    );
  }

//大屏时的NavigationRail
  Widget createNavigationRail() {
    return NavigationRail(
      selectedIndex: screenIndex,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: (index) {
        setState(() {
          screenIndex = index;
        });
      },
      //左侧导航栏的类和下面的不一样，需要转换
      destinations: appBarDestinations.map((destination) {
        return NavigationRailDestination(
          icon: destination.icon,
          label: Text(destination.label),
          selectedIcon: destination.selectedIcon,
        );
      }).toList(),
      trailing: Expanded(
        child: _trailingActions(),
      ),
    );
  }

//小屏时的NavigationBar
  Widget createNavigationBar() {
    void onSelectItem(index) {
      setState(() {
        screenIndex = index;
      });
    }

    return Focus(
      autofocus: true,
      child: NavigationBar(
        selectedIndex: screenIndex,
        onDestinationSelected: (index) {
          onSelectItem(index);
        },
        destinations: appBarDestinations,
      ),
    );
  }

//build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: createAppBar(),
      body: Row(
        children: <Widget>[
          Visibility(
            visible: !showSmallLayout, // 根据条件设置是否可见
            child: createNavigationRail(),
          ),
          Expanded(child: createScreenFor()),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: showSmallLayout, // 根据条件设置是否可见
        child: createNavigationBar(),
      ),
      endDrawer: const NavigationDrawerSection(),
    );
  }
}

//俩按钮 可以在AppBar中显示，也可以在NavigationRail中显示
class _BrightnessButton extends StatelessWidget {
  const _BrightnessButton({
    required this.handleBrightnessChange,
    this.showTooltipBelow = true,
  });

  final Function handleBrightnessChange;
  final bool showTooltipBelow;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Tooltip(
      // 在NavigationRail中，tooltip显示在顶部，在NavigationBar中，tooltip显示在底部
      preferBelow: showTooltipBelow,
      message: 'Toggle brightness',
      child: IconButton(
        icon: isBright
            ? const Icon(Icons.dark_mode_outlined)
            : const Icon(Icons.light_mode_outlined),
        onPressed: () => handleBrightnessChange(!isBright),
      ),
    );
  }
}

class _ColorSeedButton extends StatelessWidget {
  const _ColorSeedButton({
    required this.handleColorSelect,
    required this.color,
  });

  final void Function(int) handleColorSelect;
  final ColorSeed color;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.palette_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      tooltip: 'Select a seed color',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return List.generate(ColorSeed.values.length, (index) {
          ColorSeed currentColor = ColorSeed.values[index];

          return PopupMenuItem(
            value: index,
            enabled: currentColor != color,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    currentColor == color
                        ? Icons.color_lens
                        : Icons.color_lens_outlined,
                    color: currentColor.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(currentColor.label),
                ),
              ],
            ),
          );
        });
      },
      onSelected: handleColorSelect,
    );
  }
}

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.payments_outlined),
    label: 'Transactions',
    selectedIcon: Icon(Icons.payments),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.pie_chart_outline),
    label: 'Analytics',
    selectedIcon: Icon(Icons.pie_chart),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.shopping_bag_outlined),
    label: 'Wallet',
    selectedIcon: Icon(Icons.shopping_bag),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.settings_outlined),
    label: 'Settings',
    selectedIcon: Icon(Icons.settings),
  ),
];

enum ColorSeed {
  baseColor('Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);

  final String label;
  final Color color;
}
