class RestaurantLite {
  final String id;
  final String name;
  final String heroImage;
  final String eta;
  final String fee;
  final double rating;
  final int ratingCount;
  final String distance;
  final List<MenuItem> appetizers;
  final String category; 

  RestaurantLite({
    required this.id,
    required this.name,
    required this.heroImage,
    required this.eta,
    required this.fee,
    required this.rating,
    required this.ratingCount,
    required this.distance,
    required this.appetizers,
    required this.category, 
  });
}

class MenuItem {
  final String title;
  final String desc;
  final double price;
  MenuItem({required this.title, required this.desc, required this.price});
}

final restaurants = <RestaurantLite>[
  RestaurantLite(
    id: 'bk',
    name: 'Burger King',
    heroImage: 'assets/images/hero_bk.jpg',
    eta: '20–30 min',
    fee: '\$0.99 delivery',
    rating: 4.5,
    ratingCount: 1240,
    distance: '1.2 km',
    appetizers: [
      MenuItem(title: 'Whopper', desc: 'Flame-grilled classic', price: 6.99),
      MenuItem(title: 'Fries', desc: 'Crispy golden fries', price: 2.49),
      MenuItem(title: 'Onion Rings', desc: 'Crispy rings', price: 3.99),
    ],
    category: 'Fast Food',
  ),
  RestaurantLite(
    id: 'sushi247',
    name: 'Sushi 24/7',
    heroImage: 'assets/images/hero_sushi.jpg',
    eta: '30–40 min',
    fee: '\$1.49 delivery',
    rating: 4.8,
    ratingCount: 860,
    distance: '2.4 km',
    appetizers: [
      MenuItem(title: 'Salmon Roll', desc: 'Fresh salmon rice roll', price: 8.50),
      MenuItem(title: 'Tuna Nigiri', desc: 'Nigiri with tuna', price: 9.99),
      MenuItem(title: 'Miso Soup', desc: 'Classic miso broth', price: 3.00),
    ],
    category: 'Japanese',
  ),
  RestaurantLite(
    id: 'pizza_palace',
    name: 'Pizza Palace',
    heroImage: 'assets/images/hero_bk.jpg',
    eta: '25–35 min',
    fee: '\$0.99 delivery',
    rating: 4.6,
    ratingCount: 540,
    distance: '1.5 km',
    appetizers: [
      MenuItem(title: 'Margherita', desc: 'Tomato, mozzarella, basil', price: 10.99),
      MenuItem(title: 'Pepperoni', desc: 'Crispy pepperoni slices', price: 12.49),
      MenuItem(title: 'Garlic Bread', desc: 'Buttery garlic loaf', price: 4.50),
    ],
    category: 'Pizza',
  ),
  RestaurantLite(
    id: 'noodle_house',
    name: 'Noodle House',
    heroImage: 'assets/images/hero_sushi.jpg',
    eta: '20–30 min',
    fee: '\$1.29 delivery',
    rating: 4.7,
    ratingCount: 980,
    distance: '0.9 km',
    appetizers: [
      MenuItem(title: 'Chicken Ramen', desc: 'Savory shoyu broth', price: 11.50),
      MenuItem(title: 'Gyoza', desc: 'Pan-fried dumplings', price: 5.99),
      MenuItem(title: 'Seaweed Salad', desc: 'Umami, sesame dressing', price: 4.25),
    ],
    category: 'Chinese',
  ),
  RestaurantLite(
    id: 'taco_town',
    name: 'Taco Town',
    heroImage: 'assets/images/hero_bk.jpg',
    eta: '15–25 min',
    fee: '\$0.79 delivery',
    rating: 4.4,
    ratingCount: 720,
    distance: '2.0 km',
    appetizers: [
      MenuItem(title: 'Beef Taco', desc: 'Seasoned beef, pico de gallo', price: 3.50),
      MenuItem(title: 'Chicken Quesadilla', desc: 'Melted cheese, salsa', price: 6.75),
      MenuItem(title: 'Churros', desc: 'Cinnamon sugar sticks', price: 3.25),
    ],
    category: 'Mexican',
  ),
  RestaurantLite(
    id: 'green_bowl',
    name: 'Green Bowl',
    heroImage: 'assets/images/hero_sushi.jpg',
    eta: '18–28 min',
    fee: '\$0.99 delivery',
    rating: 4.9,
    ratingCount: 310,
    distance: '1.0 km',
    appetizers: [
      MenuItem(title: 'Quinoa Salad', desc: 'Citrus vinaigrette', price: 7.99),
      MenuItem(title: 'Avocado Toast', desc: 'Sourdough, chili flakes', price: 6.50),
      MenuItem(title: 'Berry Yogurt', desc: 'Granola crunch', price: 4.99),
    ],
    category: 'Healthy',
  ),
];
