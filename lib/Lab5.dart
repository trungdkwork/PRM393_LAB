import 'package:flutter/material.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 5 - Movie Detail App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomeScreen(), // Bắt đầu ở màn hình Home
    );
  }
}

// BƯỚC 2: ĐỊNH NGHĨA DATA MODEL & DỮ LIỆU MẪU

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

// Dữ liệu mẫu tĩnh (Không dùng API)
final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Dune: Part Two',
    // Sử dụng ảnh placeholder tĩnh
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=1000&auto=format&fit=crop',
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: ['Official Trailer #1', 'IMAX Sneak Peek'],
  ),
  Movie(
    id: 2,
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=1000&auto=format&fit=crop',
    overview: 'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission to save his timeline.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: ['Red Band Trailer', 'Behind the Scenes'],
  ),
];

// BƯỚC 3: XÂY DỰNG MÀN HÌNH CHÍNH (HOME SCREEN)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      // ListView.builder để tạo danh sách phim cuộn được
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias, // Bo góc cho ảnh bên trong
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              // ĐIỀU HƯỚNG: Bắt sự kiện bấm vào phim để chuyển trang
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // TRUYỀN DỮ LIỆU: Truyền đối tượng 'movie' sang màn hình Detail
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: Row(
                children: [
                  // Ảnh bìa dùng Hero để tạo hiệu ứng bay sang màn hình sau
                  Hero(
                    tag: 'poster_${movie.id}',
                    child: Image.network(
                      movie.posterUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Thông tin tóm tắt
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('⭐ ${movie.rating} • ${movie.genres.join(", ")}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// BƯỚC 4: XÂY DỰNG MÀN HÌNH CHI TIẾT (MOVIE DETAIL SCREEN)

class MovieDetailScreen extends StatefulWidget {
  final Movie movie; // Nhận đối tượng phim từ màn hình trước

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isFavorite = false; // Tính năng nâng cao: State cho nút Yêu thích

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // Dùng SingleChildScrollView để toàn bộ màn hình cuộn được
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Banner với Stack (Ảnh nền + Gradient + Tiêu đề)
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Hero(
                  tag: 'poster_${movie.id}',
                  child: Image.network(
                    movie.posterUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                // Lớp gradient đen mờ dần lên trên cho dễ đọc chữ
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    ),
                  ),
                ),
                // Tiêu đề nổi trên ảnh
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    movie.title,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Thể loại hiển thị bằng Wrap + Chip
                  Wrap(
                    spacing: 8.0,
                    children: movie.genres.map((genre) => Chip(
                      label: Text(genre, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.grey[200],
                    )).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 3. Overview Text
                  Text(
                    movie.overview,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // 4. Các nút Action (Favorite, Rate, Share)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Nút bấm có trạng thái (Tùy chọn nâng cao)
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                            color: isFavorite ? Colors.red : Colors.grey[700],
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                          ),
                          const Text('Favorite', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
                          const Text('Rate', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                          const Text('Share', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // 5. Danh sách Trailers
                  const Text('Trailers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  // Chèn ListView vào trong SingleChildScrollView cần cấu hình shrinkWrap và NeverScrollableScrollPhysics
                  ListView.builder(
                    shrinkWrap: true, // Ép ListView thu gọn lại vừa với nội dung
                    physics: const NeverScrollableScrollPhysics(), // Tắt tính năng cuộn riêng của ListView để cuộn theo màn hình tổng
                    itemCount: movie.trailers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.play_circle_fill, size: 36, color: Colors.deepPurple),
                        title: Text(movie.trailers[index], style: const TextStyle(fontWeight: FontWeight.w500)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}