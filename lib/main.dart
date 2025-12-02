import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'theme.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'services/notify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notify.instance.init();

  // Initialize favorites provider
  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider.value(value: favoritesProvider),
      ],
      child: const BitefulApp(),
    ),
  );
}

class BitefulApp extends StatelessWidget {
  const BitefulApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = buildBitefulTheme(
      amiko: GoogleFonts.amiko(),
      mogra: GoogleFonts.mogra(),
      inter: GoogleFonts.inter(),
    );

    return MaterialApp.router(
      title: 'Biteful',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: buildRouter(),
    );
  }
}
