import 'package:flutter/material.dart';
import 'package:wallet/components/calculator.dart';

class InputSheet extends StatelessWidget {
  const InputSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showBottomSheet(context);
      },
      child: const Icon(Icons.add),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const TransactionBottomSheet(),
          ),
        );
      },
    );
  }
}

class TransactionBottomSheet extends StatefulWidget {
  const TransactionBottomSheet({super.key});

  @override
  State<TransactionBottomSheet> createState() => _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends State<TransactionBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          // 设置选中标签的颜色
          unselectedLabelColor: Theme.of(context).colorScheme.primary,
          // 设置未选中标签的颜色
          tabs: [
            _RallyTab(
              iconData: Icons.pie_chart,
              title: 'Expense',
              tabIndex: 0,
              tabController: _tabController,
              isVertical: false,
            ),
            _RallyTab(
              iconData: Icons.pie_chart,
              title: 'Income',
              tabIndex: 1,
              tabController: _tabController,
              isVertical: false,
            ),
          ],
          // This hides the tab indicator.
          indicatorColor: Colors.transparent,
        ),
        //使用TabBarView会导致在 SingleChildScrollView 中，TabBarView 的高度是无界的，
        // 这意味着它会尽可能地扩展到屏幕的大小，导致 TabBarView 的高度超过屏幕的大小。
        IndexedStack(
          index: tabIndex,
          children: [
            _buildExpenseView(),
            _buildIncomeView(),
          ],
        ),
        const SizedBox(height: 16.0),
        const MyCalculator(),
      ],
    );
  }

  Widget _buildExpenseView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryButton(Icons.shopping_cart, 'Shopping'),
        _buildCategoryButton(Icons.restaurant, 'Diet'),
        _buildCategoryButton(Icons.home, 'Residential'),
        _buildCategoryButton(Icons.commute, 'Commute'),
      ],
    );
  }

  Widget _buildIncomeView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryButton(Icons.monetization_on, 'Wage'),
        _buildCategoryButton(Icons.redeem, 'Bonus'),
        _buildCategoryButton(Icons.pie_chart, 'Investment'),
        _buildCategoryButton(Icons.hourglass_empty, 'Part-time'),
      ],
    );
  }

  Widget _buildCategoryButton(IconData icon, String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: OutlinedButton(
          onPressed: () {},
          style: _categoryButtonStyle,
          child: Column(
            children: [Icon(icon), Text(text)],
          ),
        ),
      ),
    );
  }

  final _categoryButtonStyle = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // 调整圆角半径
    ),
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
  );
}

const int tabCount = 2;

class _RallyTab extends StatefulWidget {
  _RallyTab({
    IconData? iconData,
    required String title,
    int? tabIndex,
    required TabController tabController,
    required this.isVertical,
  })  : titleText = Text(title),
        isExpanded = tabController.index == tabIndex,
        icon = Icon(iconData, semanticLabel: title);

  final Text titleText;
  final Icon icon;
  final bool isExpanded;
  final bool isVertical;

  @override
  _RallyTabState createState() => _RallyTabState();
}

class _RallyTabState extends State<_RallyTab>
    with SingleTickerProviderStateMixin {
  late Animation<double> _titleSizeAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _iconFadeAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _titleSizeAnimation = _controller.view;
    _titleFadeAnimation = _controller.drive(CurveTween(curve: Curves.easeOut));
    _iconFadeAnimation = _controller.drive(Tween<double>(begin: 0.6, end: 1));
    if (widget.isExpanded) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(_RallyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVertical) {
      return Column(
        children: [
          const SizedBox(height: 18),
          FadeTransition(
            opacity: _iconFadeAnimation,
            child: widget.icon,
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _titleFadeAnimation,
            child: SizeTransition(
              axis: Axis.vertical,
              axisAlignment: -1,
              sizeFactor: _titleSizeAnimation,
              child: Center(child: ExcludeSemantics(child: widget.titleText)),
            ),
          ),
          const SizedBox(height: 18),
        ],
      );
    }

    // Calculate the width of each unexpanded tab by counting the number of
    // units and dividing it into the screen width. Each unexpanded tab is 1
    // unit, and there is always 1 expanded tab which is 1 unit + any extra
    // space determined by the multiplier.
    final width = MediaQuery.of(context).size.width;
    const expandedTitleWidthMultiplier = 2;
    final unitWidth = width / (tabCount + expandedTitleWidthMultiplier);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          FadeTransition(
            opacity: _iconFadeAnimation,
            child: SizedBox(
              width: unitWidth,
              child: widget.icon,
            ),
          ),
          FadeTransition(
            opacity: _titleFadeAnimation,
            child: SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: -1,
              sizeFactor: _titleSizeAnimation,
              child: SizedBox(
                width: unitWidth * expandedTitleWidthMultiplier,
                child: Center(
                  child: ExcludeSemantics(child: widget.titleText),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
