import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/album_item.dart';
import '../widgets/album_card.dart';


const String baseUrl = 'https://6ae41bdb933120ae20f980dc.mockapi.io'; 

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<AlbumItem> _albums = [];
  final Set<String> _likedIds = {}; 
  
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _onlyFavorites = false;
  bool _showForm = false;

  
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAlbums(); 
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  
  Future<void> _fetchAlbums() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/albums'));
      if (response.statusCode != 200) {
        throw Exception('Не удалось загрузить данные (Статус: ${response.statusCode})');
      }

      final List<dynamic> decodedList = jsonDecode(response.body) as List;
      setState(() {
        _albums = decodedList.map((item) => AlbumItem.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  
  Future<void> _addAlbum() async {
    final titleText = _titleController.text.trim();
    if (titleText.isEmpty) return; 

    try {
      
      final newAlbum = AlbumItem(
        id: '', 
        title: titleText,
        artist: 'Unknown Artist',
        genre: 'Rock / Alternative',
        category: AlbumCategory.rock,
        categoryIcon: Icons.loop,
        backgroundColor: const Color(0xFF7F8C8D), 
        description: 'Добавлено через форму',
      );

      final response = await http.post(
        Uri.parse('$baseUrl/albums'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(newAlbum.toJson()),
      );

      if (!mounted) return;

      if (response.statusCode != 201) {
        throw Exception('Ошибка сохранения (Статус: ${response.statusCode})');
      }

      final createdAlbum = AlbumItem.fromJson(jsonDecode(response.body));

      setState(() {
        _albums.insert(0, createdAlbum); 
        _titleController.clear(); 
        _showForm = false; 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Альбом успешно добавлен на сервер!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось отправить: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _toggleLike(String id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final displayedAlbums = _onlyFavorites
        ? _albums.where((album) => _likedIds.contains(album.id)).toList()
        : _albums;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Музыкальный Каталог',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: [
          
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add, color: Colors.white),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
          
          IconButton(
            icon: Icon(
              _onlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _onlyFavorites = !_onlyFavorites),
          ),
        ],
      ),
      body: Column(
        children: [
          
          if (_showForm) _buildFormSection(),

          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'В избранном: ${_likedIds.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          
          Expanded(
            child: _buildMainContent(displayedAlbums),
          ),
        ],
      ),
    );
  }

  
  Widget _buildFormSection() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Название нового альбома',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _addAlbum,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Отправить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  
  Widget _buildMainContent(List<AlbumItem> displayedAlbums) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchAlbums,
                icon: const Icon(Icons.refresh),
                label: const Text('Обновить'),
              ),
            ],
          ),
        ),
      );
    }

    if (displayedAlbums.isEmpty) {
      return const Center(
        child: Text('Ничего не нашлось', style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: displayedAlbums.length,
      itemBuilder: (context, index) {
        final album = displayedAlbums[index];
        return AlbumCard(
          album: album,
          isLiked: _likedIds.contains(album.id),
          onLikeTap: () => _toggleLike(album.id),
        );
      },
    );
  }
}
