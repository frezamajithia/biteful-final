import 'package:go_router/go_router.dart';
import 'pages/splash_page.dart';
import 'pages/shell_home.dart';
import 'pages/home_page.dart';
import 'pages/restaurant_page.dart';
import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
import 'pages/order_confirmed_page.dart';
import 'pages/orders_page.dart';
import 'pages/profile_page.dart';
import 'pages/track_page.dart';
import 'pages/notifications_page.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => const HomeShell(),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/restaurant/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RestaurantPage(id: id);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/order-confirmed/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OrderConfirmedPage(id: id);
        },
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/track/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return TrackPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
  );
}
