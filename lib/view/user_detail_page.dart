import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserDetailPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes informations personnelles'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile', arguments: userData);
            },
            icon: const Icon(Icons.edit),
            label: const Text('Modifier'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo de profil
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Informations personnelles
            _buildSectionTitle('Informations personnelles'),
            const SizedBox(height: 16),

            _buildDetailCard([
              _buildDetailRow('Prénom', userData['firstName'] ?? 'Non défini'),
              _buildDetailRow('Nom', userData['lastName'] ?? 'Non défini'),
              _buildDetailRow('Email', userData['email'] ?? 'Non défini'),
              _buildDetailRow('Type de compte',
                  userData['user_type'] == 'visiteur' ? 'Visiteur' : 'Exposant'),
            ]),

            // Informations entreprise (si exposant)
            if (userData['company'] != null) ...[
              const SizedBox(height: 30),
              _buildSectionTitle('Informations entreprise'),
              const SizedBox(height: 16),

              _buildDetailCard([
                _buildDetailRow('Nom de l\'entreprise',
                    userData['company']['company_name'] ?? 'Non défini'),
                _buildDetailRow('SIREN',
                    userData['company']['siren_number'] ?? 'Non défini'),
              ]),
            ],

            // Statistiques (si nécessaire)
            const SizedBox(height: 30),
            _buildSectionTitle('Statistiques'),
            const SizedBox(height: 16),

            _buildDetailCard([
              _buildDetailRow('Membre depuis', _formatDate(userData['created_at'])),
              _buildDetailRow('Dernière connexion', _formatDate(userData['updated_at'])),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Non disponible';

    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Non disponible';
    }
  }
}
