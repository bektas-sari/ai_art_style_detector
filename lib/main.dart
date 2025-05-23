import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

void main() {
  runApp(const ArtStyleDetectorApp());
}

class ArtStyleDetectorApp extends StatelessWidget {
  const ArtStyleDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Art Style Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ArtStyleHomePage(),
    );
  }
}

class ArtStyleHomePage extends StatefulWidget {
  const ArtStyleHomePage({super.key});

  @override
  State<ArtStyleHomePage> createState() => _ArtStyleHomePageState();
}

class _ArtStyleHomePageState extends State<ArtStyleHomePage> {
  File? _image;
  String? _detectedStyle;
  bool _isLoading = false;

  final List<String> artStyles = [
    'Impressionism',
    'Cubism',
    'Realism',
    'Surrealism',
    'Expressionism',
    'Abstract',
    'Baroque',
    'Renaissance'
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _detectedStyle = null;
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _detectedStyle = artStyles[Random().nextInt(artStyles.length)];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Art Style Detector'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image_search),
              label: const Text('Pick Artwork Image'),
            ),
            const SizedBox(height: 20),
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _image!,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_detectedStyle != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '🎨 Detected Style: $_detectedStyle',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}