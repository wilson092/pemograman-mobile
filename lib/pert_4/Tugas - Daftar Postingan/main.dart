import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

/* ============================================================
 * MODEL
 * ============================================================ */

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['postId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }
}

/* ============================================================
 * LAYER DATA (dipisah dari UI)
 * ============================================================ */

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class PostRepository {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  PostRepository({http.Client? client}) : _client = client ?? http.Client();

  /// GET /posts
  Future<List<Post>> fetchPosts() async {
    final data = await _getList('$_baseUrl/posts');
    return data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET /posts/{id}/comments
  Future<List<Comment>> fetchComments(int postId) async {
    final data = await _getList('$_baseUrl/posts/$postId/comments');
    return data
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<dynamic>> _getList(String url) async {
    try {
      final response = await _client.get(Uri.parse(url)).timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
            'Server mengembalikan kode ${response.statusCode}.');
      }
      return jsonDecode(response.body) as List<dynamic>;
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw const ApiException('Permintaan melebihi batas waktu.');
    } on http.ClientException {
      throw const ApiException('Gagal terhubung ke server.');
    } on FormatException {
      throw const ApiException('Format data dari server tidak valid.');
    } on TypeError {
      throw const ApiException('Struktur data dari server tidak sesuai.');
    }
  }
}

/* ============================================================
 * UI
 * ============================================================ */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Postingan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const PostListPage(),
    );
  }
}

/// Widget bersama untuk status galat + tombol coba lagi.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 56, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Terjadi kesalahan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Halaman utama: daftar postingan ---------------- */

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final PostRepository _repository = PostRepository();
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = _repository.fetchPosts();
  }

  void _retry() {
    setState(() {
      _futurePosts = _repository.fetchPosts();
    });
  }

  String _excerpt(String text, {int max = 80}) {
    final clean = text.replaceAll('\n', ' ');
    return clean.length <= max ? clean : '${clean.substring(0, max)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Postingan')),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _retry,
            );
          }

          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(child: Text('Belum ada postingan.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _retry();
              await _futurePosts;
            },
            child: ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${post.id}')),
                  title: Text(
                    post.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_excerpt(post.body)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostDetailPage(post: post),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/* ---------------- Halaman detail: isi lengkap + komentar ---------------- */

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final PostRepository _repository = PostRepository();
  late Future<List<Comment>> _futureComments;

  @override
  void initState() {
    super.initState();
    _futureComments = _repository.fetchComments(widget.post.id);
  }

  void _retry() {
    setState(() {
      _futureComments = _repository.fetchComments(widget.post.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Postingan #${post.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Isi lengkap postingan (data dari halaman sebelumnya)
          Text(post.title, style: textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(post.body, style: textTheme.bodyLarge),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          Text('Komentar', style: textTheme.titleLarge),
          const SizedBox(height: 8),

          // Future kedua: komentar dari endpoint terpisah
          FutureBuilder<List<Comment>>(
            future: _futureComments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: _retry,
                  ),
                );
              }

              final comments = snapshot.data ?? [];
              if (comments.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Belum ada komentar.'),
                );
              }

              return Column(
                children: comments
                    .map((c) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c.email,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(c.body),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}