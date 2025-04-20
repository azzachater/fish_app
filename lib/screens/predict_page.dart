import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_picture_service.dart';

class PredictPage extends StatefulWidget {
  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  File? _imageFile;
  String? _prediction;
  bool _isLoading = false;

  final picker = ImagePicker();
  final apiService = ApiPictureService();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _prediction = null;
      });
    }
  }

  Future<void> _predict() async {
    if (_imageFile == null) return;

    setState(() => _isLoading = true);
    final result = await apiService.predictFishSpecies(_imageFile!);
    setState(() {
      _prediction = result ?? '❌ Erreur lors de la prédiction';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Colors.blue.shade600;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text('🐟', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              'Poisson Scanner',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight - 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(24),
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_imageFile!,
                                height: 240, fit: BoxFit.cover),
                          )
                        : Column(
                            children: [
                              Icon(Icons.image_outlined, size: 100, color: Colors.blue[200]),
                              SizedBox(height: 10),
                              Text('📸 Aucune image sélectionnée',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.photo_library),
                      label: Text('Choisir une image 📂'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _predict,
                      icon: Icon(Icons.analytics),
                      label: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text('Lancer la prédiction 🔍'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              if (_prediction != null)
                AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "🎯 Espèce prédite : $_prediction",
                    style: TextStyle(fontSize: 18, color: primaryBlue, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
