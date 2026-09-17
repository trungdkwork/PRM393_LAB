  // Exercise 4: Intro to OOP
class Game {
  String gamename;
  // Hàm khởi tạo
  Game(this.gamename);
  // Named constructor
  Game.namedConstructor(this.gamename);
  // Phương thức
  void xemstream() {
    print('Đang xem stream game $gamename.');
  }
}

// Tạo subclass kế thừa và ghi đè (override) phương thức
class MMORPG extends Game {
  MMORPG(String gametype) : super(gametype);

  @override
  void play() {
    print('Đang chơi game $gamename.');
  }
}

  // Exercise 3: Control Flow & Functions
  // Hàm thông thường (Normal syntax)
void greet(String TrungDK) {
  print('Xin chào, $TrungDK!');
}

// Hàm mũi tên (Arrow syntax)
int square(int x) => x * x;


  // Exercise 5:Async, Future, Null Safety & Streams
// Work with Dart’s asynchronous features.
Future<void> simulateLoading() async {
  print('Đang tải dữ liệu...');
  await Future.delayed(Duration(seconds: 2)); // Giả lập chờ 2 giây
  print('Tải dữ liệu hoàn tất!');
}

// Tạo một Stream đơn giản trả về các số nguyên
Stream<int> numberStream() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

Future<void> main() async {
  // Exercise 1: Basic Syntax & Data Types
  // 1. Khai báo biến
  int age = 27;
  double score = 9;
  String name = 'TrungDK';
  bool isStudent = true;

  // 2. Print và string interpolation
  print('Tên tôi là $name, tôi $age tuổi.');
  print('Điểm số: $score. Đang là sinh viên? $isStudent.');

  //Exercise 2
  // Tạo List và sử dụng toán tử
  List<int> numbers = [10, 20, 30, 40];
  int sum = numbers[0] + numbers[1];
  bool isEqual = (numbers[2] == numbers[3]);

  print('Các số đã tạo: $numbers');
  print('Tổng 2 số đầu: $sum');
  print('So sánh 2 số có bằng nhau không? $isEqual');

  // Tạo Set và sử dụng add(), remove()
  Set<String> uniqueColors = {'Đỏ', 'Xanh lá', 'Xanh dương'};
  uniqueColors.add('Vàng');
  uniqueColors.remove('Đỏ');
  print('Set sau khi thêm/xóa: $uniqueColors');

  // Tạo Map và sử dụng indexing, truy cập map
  Map<String, dynamic> studentInfo = {
    'id': 'HE130424',
    'major': 'Software Engineering'
  };
  studentInfo['grade'] = 'A'; // Thêm dữ liệu
  studentInfo.remove('id'); // Xóa dữ liệu
  print('Map sau khi chỉnh sửa: $studentInfo\n');

  // Exercise 3
  // Khối lệnh if/else
  int examScore = 8;
  if (examScore >= 4) {
    print('Kết quả: Pass');
  } else {
    print('Kết quả: Fail');
  }

  // Khối lệnh switch case
  int day = 3;
  switch (day) {
    case 1:
      print('Hôm nay là Thứ 2');
      break;
    case 2:
      print('Hôm nay là Thứ 3');
      break;
    case 3:
      print('Hôm nay là Thứ 4');
      break;
    default:
      print('Ngày khác trong tuần');
  }

  // Lặp qua collection bằng for, for-in, forEach
  List<String> fruits = ['Táo', 'Chuối', 'Cam'];

  print('- for:');
  for (int i = 0; i < fruits.length; i++) {
    print(fruits[i]);
  }

  print('- for-in:');
  for (String fruit in fruits) {
    print(fruit);
  }

  print('- forEach:');
  fruits.forEach((fruit) => print(fruit));

  // Gọi hàm
  greet('TrungDK');
  print('Bình phương của 5 là: ${square(5)}\n');


  // Exercise 4
  // Khởi tạo đối tượng từ class Game
  Game normalGame = Game('Liên Minh Huyền Thoại');
  normalGame.xemstream();

  Game nameGame = Game.namedConstructor('Valorant');
  nameGame.xemstream();

  // Khởi tạo đối tượng từ class gameType
  MMORPG gameType = MMORPG('Liên Minh Huyền Thoại');
  gameType.play(); // Sẽ in ra hàm đã được ghi đè
  print('');


  // Exercise 5:;
  // Thực hành toán tử Null-safety (?, ??, !)
  String? nullableString; // Biến có thể null
  String defaultString = nullableString ?? 'Giá trị mặc định do biến bị null';
  print('Null-safety: $defaultString');

  // Chạy hàm Async mô phỏng tải dữ liệu
  await simulateLoading();

  // Lắng nghe Stream
  print('Đang lắng nghe giá trị Stream...');
  await for (int value in numberStream()) {
    print('Stream phát ra giá trị: $value');
  }
}