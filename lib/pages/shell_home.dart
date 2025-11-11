import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';
import 'home_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _pages = const [
    HomePage(),
    OrdersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final titles = ['Biteful', 'Orders', 'Profile'];
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: _index == 0
            ? RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Mogra',
                    color: Colors.white,
                    letterSpacing: 1.2,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(text: 'B', style: TextStyle(fontSize: 38)),
                    TextSpan(text: 'iteful', style: TextStyle(fontSize: 30)),
                  ],
                ),
              )
            : Text(titles[_index]),
        actions: _index == 0
            ? [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () => context.push('/cart'),
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: 8, // ✅ FIXED: better positioning
                        top: 8,  // ✅ FIXED: better positioning
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: kWarn,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cart.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ]
            : null,
      ),
      body: IndexedStack(index: _index, children: _pages),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), // ✅ FIXED
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            backgroundColor: Colors.white,
            indicatorColor: kPrimary.withValues(alpha: 0.12), // ✅ FIXED
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: kPrimary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long_rounded, color: kPrimary),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: kPrimary),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
