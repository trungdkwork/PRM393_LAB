import 'package:flutter/material.dart';

void main() {
  runApp(const Lab4App());
}

// ==========================================
// BÀI 4: KHUNG ỨNG DỤNG (APP STRUCTURE) & THEME
// ==========================================
class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  // Biến quản lý trạng thái Sáng/Tối
  ThemeMode _themeMode = ThemeMode.light;

  // Hàm chuyển đổi theme
  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 - Flutter UI',
      // Cấu hình Theme Sáng / Tối
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.deepPurple),
      themeMode: _themeMode,
      // Gọi màn hình chính và truyền hàm toggleTheme vào
      home: MainHomeScreen(toggleTheme: toggleTheme, isDark: _themeMode == ThemeMode.dark),
    );
  }
}

// Màn hình chính chứa Scaffold, AppBar, FAB và Điều hướng
class MainHomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDark;

  const MainHomeScreen({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0; // Đang ở Tab nào?

  // Danh sách các màn hình bài tập
  final List<Widget> _screens = [
    const Ex1CoreWidgets(),
    const Ex2InputWidgets(),
    const Ex3LayoutAndListView(),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold: Khung xương chuẩn của màn hình
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 - UI Fundamentals'),
        actions: [
          Row(
            children: [
              const Text('Dark Mode', style: TextStyle(fontSize: 12)),
              Switch(
                value: widget.isDark,
                onChanged: (val) => widget.toggleTheme(val), // Gọi hàm bật/tắt Theme
              ),
            ],
          )
        ],
      ),
      // BÀI 5: Sửa lỗi State - Dùng _screens[_currentIndex] để tự động đổi màn hình khi ấn Tab
      body: _screens[_currentIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nút FAB đã được bấm!')),
          );
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cập nhật Tab đang chọn
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Bài 1 (Core)'),
          BottomNavigationBarItem(icon: Icon(Icons.input), label: 'Bài 2 (Input)'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Bài 3 (Layout)'),
        ],
      ),
    );
  }
}

// ==========================================
// BÀI 1: CORE WIDGETS
// ==========================================
class Ex1CoreWidgets extends StatelessWidget {
  const Ex1CoreWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    // BÀI 5: Bọc SingleChildScrollView để fix lỗi tràn màn hình (Overflow)
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome to Flutter UI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          const Center(child: Icon(Icons.movie, size: 64, color: Colors.blue)),
          const SizedBox(height: 20),

          Image.network(
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),

          const Card(
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.star),
              title: Text('Movie Item'),
              subtitle: Text('This is a sample ListTile inside a Card.'),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// BÀI 2: INPUT WIDGETS
// ==========================================
class Ex2InputWidgets extends StatefulWidget {
  const Ex2InputWidgets({super.key});

  @override
  State<Ex2InputWidgets> createState() => _Ex2InputWidgetsState();
}

class _Ex2InputWidgetsState extends State<Ex2InputWidgets> {
  double _rating = 50.0;
  bool _isActive = false;
  String _genre = 'None';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rating (Slider)', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _rating,
            min: 0,
            max: 100,
            // BÀI 5: Dùng setState() để UI cập nhật ngay khi kéo thanh trượt
            onChanged: (val) => setState(() => _rating = val),
          ),
          Text('Current value: ${_rating.toInt()}'),
          const Divider(height: 30),

          const Text('Active (Switch)', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Is movie active?'),
              Switch(
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
            ],
          ),
          const Divider(height: 30),

          const Text('Genre (RadioListTile)', style: TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: const Text('Action'),
            value: 'Action',
            groupValue: _genre,
            onChanged: (val) => setState(() => _genre = val!),
          ),
          RadioListTile<String>(
            title: const Text('Comedy'),
            value: 'Comedy',
            groupValue: _genre,
            onChanged: (val) => setState(() => _genre = val!),
          ),
          Text('Selected genre: $_genre'),
          const Divider(height: 30),

          Center(
            child: ElevatedButton(
              onPressed: () async {
                // BÀI 5: Fix lỗi DatePicker Context bằng cách gọi bên trong Widget tree hợp lệ
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() { _selectedDate = picked; });
                }
              },
              child: const Text('Open Date Picker'),
            ),
          ),
          if (_selectedDate != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Selected Date: ${_selectedDate.toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================
// BÀI 3: LAYOUT BASICS & BÀI 5: FIX LISTVIEW ERROR
// ==========================================
class Ex3LayoutAndListView extends StatelessWidget {
  const Ex3LayoutAndListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> movies = ['Avatar', 'Inception', 'Interstellar', 'Joker', 'The Matrix', 'Spider-Man'];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Now Playing', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),

        // BÀI 5: Dùng Expanded để sửa lỗi Crash màn hình đỏ (Unbounded height) của ListView khi đặt trong Column
        Expanded(
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(movies[index][0], style: const TextStyle(color: Colors.indigo)),
                  ),
                  title: Text(movies[index]),
                  subtitle: const Text('Sample description'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}