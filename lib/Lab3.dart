import 'dart:async';

// EXERCISE 1: Product Model & Repository
class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  // Dùng broadcast để cho phép nhiều nơi cùng lắng nghe Stream này
  final StreamController<Product> _controller = StreamController<Product>.broadcast();

  // Trả về dữ liệu 1 lần
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian load
    return [
      Product(1, 'Laptop', 1200.0),
      Product(2, 'Smartphone', 800.0),
    ];
  }

  // Luồng dữ liệu thời gian thực
  Stream<Product> liveAdded() => _controller.stream;

  // Thêm sản phẩm mới vào luồng
  void addProduct(Product product) {
    _controller.add(product);
  }
}

// EXERCISE 2: User Repository with JSON

class User {
  String name;
  String email;

  User(this.name, this.email);

  // Constructor đặc biệt để biến JSON thành Object
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  @override
  String toString() => 'User(name: $name, email: $email)';
}

Future<List<User>> fetchUsers() async {
  // Giả lập dữ liệu JSON tải từ trên mạng về (API)
  List<Map<String, dynamic>> mockJson = [
    {'name': 'Alice', 'email': 'alice@example.com'},
    {'name': 'Bob', 'email': 'bob@example.com'}
  ];

  await Future.delayed(Duration(milliseconds: 500));
  // Dùng .map() để lặp qua list JSON và ném vào bộ chuyển đổi fromJson
  return mockJson.map((json) => User.fromJson(json)).toList();
}

// EXERCISE 5: Factory Constructors & Cache
class Settings {
  // Biến tĩnh lưu trữ bản thể duy nhất
  static final Settings _instance = Settings._internal();

  // Hàm khởi tạo Factory luôn trả về bản thể có sẵn
  factory Settings() {
    return _instance;
  }

  // Hàm khởi tạo Private (bị giấu đi, bên ngoài không gọi được)
  Settings._internal();
}

// HÀM MAIN

void main() async {
  print('Exercise 3: ASYNC + MICROTASK DEBUGGING');
  // Chạy bài 3 đầu tiên để minh họa Event Loop rõ nhất
  Future(() => print('-> [Event Queue]: Future thực thi.'));
  scheduleMicrotask(() => print('-> [Microtask Queue]: Microtask thực thi (VIP - Chạy trước).'));
  print('-> [Sync]: Code đồng bộ luôn chạy đầu tiên.');

  // Lệnh Delay
  await Future.delayed(Duration(milliseconds: 100));


  print('\n Exercise 1: PRODUCT REPOSITORY');
  var repo = ProductRepository();

  // Mở máy thu thanh, bắt đầu lắng nghe Stream
  repo.liveAdded().listen((product) {
    print('   [Stream nhận tin]: Có sản phẩm mới -> $product');
  });

  // Chờ lấy toàn bộ dữ liệu 1 lần
  var allProducts = await repo.getAll();
  print('   [Future lấy danh sách]: $allProducts');

  // Thử phát sóng thêm 1 sản phẩm mới vào Stream
  repo.addProduct(Product(3, 'Tablet', 450.0));
  await Future.delayed(Duration(milliseconds: 100));


  print('\n Exercise 2: USER JSON PARSING');
  var parsedUsers = await fetchUsers();
  print('   Danh sách User đã ép kiểu:');
  parsedUsers.forEach((user) => print('   - $user'));


  print('\nExercise 4: STREAM TRANSFORMATION');
  // Tạo 1 Stream phát ra các số từ 1 đến 5
  Stream<int> numbersStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  await numbersStream
      .map((n) => n * n)         // Lọc 1: Bình phương các số (1, 4, 9, 16, 25)
      .where((n) => n % 2 == 0)  // Lọc 2: Chỉ giữ lại số chẵn (chia hết cho 2)
      .listen((n) {
    print('   [Số qua màng lọc]: $n'); // Kết quả kỳ vọng: 4 và 16
  }).asFuture();


  print('\nExercise 5: FACTORY CONSTRUCTOR');
  // Khởi tạo 2 biến Settings
  var settingsA = Settings();
  var settingsB = Settings();

  // Kiểm tra xem chúng có dùng chung 1 vùng bộ nhớ không
  bool isSame = identical(settingsA, settingsB);
  print('   Settings A và Settings B có giống nhau hoàn toàn? -> $isSame');
  print('   Giải thích: Factory pattern giúp không tạo ra bản sao mới, tiết kiệm bộ nhớ.');
}