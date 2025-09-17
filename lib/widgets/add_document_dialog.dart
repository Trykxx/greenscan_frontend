import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/storage_service.dart';

class AddDocumentDialog extends StatefulWidget {
  final int userId;
  final VoidCallback onDocumentAdded;

  const AddDocumentDialog({
    Key? key,
    required this.userId,
    required this.onDocumentAdded,
  }) : super(key: key);

  @override
  State<AddDocumentDialog> createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  PlatformFile? _selectedFile;

  // 📁 Sélectionner un fichier PDF
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
          // Auto-remplir le nom si vide
          if (_nameController.text.trim().isEmpty) {
            _nameController.text = _selectedFile!.name.replaceAll('.pdf', '');
          }
        });

        // 🔍 DEBUG - Vérifier les infos du fichier
        print('📁 Fichier sélectionné: ${_selectedFile!.name}');
        print('📏 Taille: ${_selectedFile!.size} bytes');
        print('📄 Extension: ${_selectedFile!.extension}');
        print('🗂️ Path: ${_selectedFile!.path}');
        print('💾 Bytes disponibles: ${_selectedFile!.bytes != null}');
        if (_selectedFile!.bytes != null) {
          print('💾 Taille bytes: ${_selectedFile!.bytes!.length}');
        }
      }
    } catch (e) {
      print('❌ Erreur sélection fichier: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addDocument() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un nom')),
      );
      return;
    }

    // 🔍 DEBUG - Vérifier l'état du fichier avant envoi
    print('🔍 État du fichier avant envoi:');
    print('   - _selectedFile: $_selectedFile');
    print('   - _selectedFile != null: ${_selectedFile != null}');
    if (_selectedFile != null) {
      print('   - Nom: ${_selectedFile!.name}');
      print('   - Taille: ${_selectedFile!.size}');
      print('   - Bytes null: ${_selectedFile!.bytes == null}');
      if (_selectedFile!.bytes != null) {
        print('   - Taille bytes: ${_selectedFile!.bytes!.length}');
      }
    }

    setState(() => _isLoading = true);

    // 🚀 Appel StorageService avec DEBUG
    bool success = await StorageService.addDocument(
      userId: widget.userId,
      documentName: _nameController.text.trim(),
      file: _selectedFile, // ← Passer le fichier sélectionné
    );

    setState(() => _isLoading = false);

    if (success) {
      widget.onDocumentAdded();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document ajouté avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'ajout du document'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un document'),
      contentPadding: const EdgeInsets.all(20),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 Nom du document
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du document',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),

            const SizedBox(height: 16),

            // 📁 Sélection de fichier
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: _pickFile,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_selectedFile == null) ...[
                        const Icon(
                          Icons.upload_file,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cliquez pour sélectionner un fichier PDF',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedFile!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_selectedFile!.size / 1024 / 1024).toStringAsFixed(2)} MB',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Seuls les fichiers PDF sont acceptés (max 10MB)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _addDocument,
          icon: _isLoading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Icon(Icons.add),
          label: Text(_isLoading ? 'Ajout...' : 'Ajouter'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF228b22),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
