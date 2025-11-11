import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _c, curve: Curves.easeOutBack),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _c.forward());
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) context.go('/'); // ✅ FIXED: was '/home'
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.6,
                colors: [
                  Color.lerp(kPrimary, Colors.white, 0.08 * _fade.value)!,
                  kPrimaryDark,
                ],
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Mogra',
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 3)),
                        ],
                      ),
                      children: [
                        TextSpan(text: 'B', style: TextStyle(fontSize: 84)),
                        TextSpan(text: 'iteful', style: TextStyle(fontSize: 64)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
