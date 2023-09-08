import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final List<IconData> items;
  final String currentPage;
  final dynamic Function(String selectedPage, bool addPage) onTap;
  const NavBar({
    super.key,
    required this.items,
    required this.currentPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        NavItem(icon: items.elementAtOrNull(0) as IconData, currentPage: currentPage, onTap: onTap,),
        NavItem(icon: items.elementAtOrNull(1) as IconData, currentPage: currentPage, boxColor: Colors.blue, textColor: Colors.white, onTap: onTap,),
        NavItem(icon: items.elementAtOrNull(2) as IconData, currentPage: currentPage, onTap: onTap,),
      ],
    );
  }
}

class NavItem extends StatefulWidget {
  final IconData icon;
  final String currentPage;
  final Color? boxColor;
  final Color? textColor;
  final dynamic Function(String selectedPage, bool addPage) onTap;
  const NavItem({
    super.key,
    required this.icon,
    required this.currentPage,
    this.boxColor,
    this.textColor,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  @override
  Widget build(BuildContext context) {
    String selectedPage = widget.currentPage;
    bool addPage = false;
    return GestureDetector(
      onTap: () {
        setState(() {
          if(widget.icon == Icons.home) selectedPage = 'home';
          if(widget.icon == Icons.shopping_cart) selectedPage = 'cart';
          if(widget.icon == Icons.add) addPage = true;
          widget.onTap(selectedPage, addPage);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: widget.boxColor ?? Colors.transparent,
            shape: BoxShape.circle
          ),
          child: Icon(
            widget.icon,
            color: widget.textColor ?? Colors.black,
          ),
        ),
      ),
    );
  }
}