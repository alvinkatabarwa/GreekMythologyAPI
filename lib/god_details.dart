import 'package:flutter/material.dart';
import 'colors.dart';

class GodDetailPage extends StatelessWidget {
  final Map<String, dynamic> godData;

  const GodDetailPage({super.key, required this.godData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(godData['name']),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              godData['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRelationshipSection('Parents', [
              if (godData['relationships']['mother'] != null)
                'Mother: ${godData['relationships']['mother']}',
              if (godData['relationships']['father'] != null)
                'Father: ${godData['relationships']['father']}',
            ]),
            _buildRelationshipSection('Spouse(s)', 
              godData['relationships']['spouse'].map<String>((s) => s.toString()).toList(),
            ),
            _buildRelationshipSection('Children', 
              godData['relationships']['children'].map<String>((c) => c.toString()).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(
            item,
            style: const TextStyle(fontSize: 16),
          ),
        )).toList(),
      ],
    );
  }
}
