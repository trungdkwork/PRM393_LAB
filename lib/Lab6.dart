import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// ==========================================
// BƯỚC 3: XÂY DỰNG BASE SCAFFOLD
// ==========================================
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 6 - Responsive Movie Screen',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50], // Nền sáng
      ),
      home: const GenreScreen(),
    );
  }
}

// ==========================================
// BƯỚC 2: ĐỊNH NGHĨA MODEL & DỮ LIỆU MẪU
// ==========================================
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Dữ liệu mẫu (Static sample data)
final List<Movie> allMovies = [
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?auto=format&fit=crop&q=80&w=300', // Placeholder
    rating: 9.0,
  ),
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Sci-Fi', 'Action'],
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&q=80&w=300',
    rating: 8.8,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?auto=format&fit=crop&q=80&w=300',
    rating: 8.6,
  ),
  Movie(
    title: 'Deadpool',
    year: 2016,
    genres: ['Action', 'Comedy'],
    posterUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?auto=format&fit=crop&q=80&w=300',
    rating: 8.0,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?auto=format&fit=crop&q=80&w=300',
    rating: 7.7,
  ),
  Movie(
    title: 'Mad Max: Fury Road',
    year: 2015,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&q=80&w=300',
    rating: 8.1,
  ),
];

// Danh sách tất cả các thể loại có thể chọn
final List<String> availableGenres = [
  'Action', 'Comedy', 'Drama', 'Sci-Fi', 'Horror', 'Romance'
];

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // --- TRẠNG THÁI (STATE) ---
  String searchQuery = ''; // BƯỚC 4
  Set<String> selectedGenres = {}; // BƯỚC 5
  String selectedSort = 'A-Z'; // BƯỚC 6

  // Tùy chọn sắp xếp
  final List<String> sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

  // BONUS: Nút xóa tất cả các bộ lọc
  void clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      selectedSort = 'A-Z';
    });
  }

  // ==========================================
  // BƯỚC 7: LOGIC LỌC VÀ SẮP XẾP DỮ LIỆU
  // ==========================================
  List<Movie> get visibleMovies {
    // 1. Lọc dữ liệu
    List<Movie> filtered = allMovies.where((movie) {
      // Lọc theo từ khóa tìm kiếm (Không phân biệt hoa thường)
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());

      // Lọc theo thể loại: Nếu không chọn thể loại nào -> coi như khớp.
      // Nếu có chọn -> phim phải chứa ít nhất 1 thể loại được chọn.
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((g) => selectedGenres.contains(g));

      return matchesSearch && matchesGenre;
    }).toList();

    // 2. Sắp xếp dữ liệu
    filtered.sort((a, b) {
      switch (selectedSort) {
        case 'A-Z':
          return a.title.compareTo(b.title);
        case 'Z-A':
          return b.title.compareTo(a.title);
        case 'Year':
          return b.year.compareTo(a.year); // Sắp xếp năm mới nhất lên đầu
        case 'Rating':
          return b.rating.compareTo(a.rating); // Sắp xếp điểm cao lên đầu
        default:
          return 0;
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    // BƯỚC 3: Dùng SafeArea để tránh tai thỏ
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TIÊU ĐỀ & NÚT CLEAR ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Find a Movie',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  // BONUS: Nút xóa bộ lọc hiển thị khi có bộ lọc được áp dụng
                  if (searchQuery.isNotEmpty || selectedGenres.isNotEmpty || selectedSort != 'A-Z')
                    TextButton.icon(
                      onPressed: clearFilters,
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear filters'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // BƯỚC 4: THANH TÌM KIẾM (SEARCH BAR)
              // ==========================================
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by title...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // ==========================================
              // BƯỚC 5: GENRE CHIPS BẰNG WRAP WIDGET
              // ==========================================
              Row(
                children: [
                  const Text('Genres:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  // BONUS: Hiển thị số lượng thể loại đang chọn
                  if (selectedGenres.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${selectedGenres.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0, // Khoảng cách giữa các dòng khi chip xuống dòng
                children: availableGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                    selectedColor: Colors.deepPurple.shade100,
                    checkmarkColor: Colors.deepPurple,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ==========================================
              // BƯỚC 6: SORT DROPDOWN BAR
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${visibleMovies.length} movies found',
                      style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      const Icon(Icons.sort, size: 20),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: selectedSort,
                        underline: const SizedBox(), // Ẩn gạch chân mặc định
                        items: sortOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (sString? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedSort = newValue;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),

              // ==========================================
              // BƯỚC 8: RESPONSIVE MOVIE LIST
              // ==========================================
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final movies = visibleMovies;

                    if (movies.isEmpty) {
                      return const Center(child: Text('No movies match your filters.'));
                    }

                    // ĐIỀU KIỆN RESPONSIVE: Nếu màn hình nhỏ hơn 800px -> Dùng ListView
                    if (constraints.maxWidth < 800) {
                      return ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return _buildMovieCard(movies[index], isGrid: false);
                        },
                      );
                    }
                    // Nếu màn hình rộng (Tablet/Web) -> Dùng GridView 2 cột
                    else {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 cột
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 2.5, // Điều chỉnh tỷ lệ khung hình cho Card trong Grid
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return _buildMovieCard(movies[index], isGrid: true);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm phụ trợ để vẽ từng khung phim (Dùng chung cho cả ListView và GridView)
  Widget _buildMovieCard(Movie movie, {required bool isGrid}) {
    return Card(
      margin: EdgeInsets.only(bottom: isGrid ? 0 : 16.0), // GridView tự có spacing nên set margin 0
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dùng LayoutBuilder bên trong Card để tùy chỉnh kích thước poster
          LayoutBuilder(
              builder: (context, cardConstraints) {
                // Trên Grid (màn hình lớn), cho ảnh to hơn một chút
                final double posterWidth = isGrid ? 120 : 100;
                return Image.network(
                  movie.posterUrl,
                  width: posterWidth,
                  height: double.infinity, // Kéo giãn chiều cao bằng chiều cao thẻ
                  fit: BoxFit.cover,
                  // Placeholder trong lúc load ảnh
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: posterWidth,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                );
              }
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('${movie.year}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 8),
                  // Thể loại của bộ phim
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: movie.genres.map((g) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(g, style: const TextStyle(fontSize: 10, color: Colors.black87)),
                    )).toList(),
                  ),
                  const Spacer(),
                  // BONUS: Hiển thị Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(movie.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}