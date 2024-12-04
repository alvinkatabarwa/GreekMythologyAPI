import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'colors.dart';

class GreekGodListPage extends StatefulWidget {
  const GreekGodListPage({super.key});

  @override
  _GreekGodListPageState createState() => _GreekGodListPageState();
}

class _GreekGodListPageState extends State<GreekGodListPage> {
  List<Map<String, dynamic>> _greekGods = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchGreekGods();
  }

  Future<void> _fetchGreekGods() async {
    try {
      // Using the getAll endpoint with English language
      final response = await http.get(
        Uri.parse('https://anfi.tk/greekApi/person/getAll?lang=en'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedGods = [];

        for (var person in data) {
          if (person['status'] == 'OK') {
            Map<String, dynamic> godEntry = {
              'name': person['name'].toString().capitalize(),
              'id': person['personID'],
              'relationships': {
                'mother': person['mother']?['name'],
                'father': person['father']?['name'],
                'spouse': person['wife']?.map((w) => w['name']).toList() ?? 
                        person['husband']?.map((h) => h['name']).toList() ?? [],
                'children': [
                  ...(person['son']?.map((s) => s['name']).toList() ?? []),
                  ...(person['daughter']?.map((d) => d['name']).toList() ?? []),
                ],
              }
            };
            fetchedGods.add(godEntry);
          }
        }

        setState(() {
          _greekGods = fetchedGods;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Greek Mythology'),
        elevation: 5.0,
        backgroundColor: PRIMARY_COLOR,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'random') {
                _fetchRandomPerson();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'random',
                child: Text('Random Person'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  itemCount: _greekGods.length,
                  itemBuilder: (context, index) {
                    var god = _greekGods[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        title: Text(
                          god['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (god['relationships']['mother'] != null)
                              Text('Mother: ${god['relationships']['mother']}'),
                            if (god['relationships']['father'] != null)
                              Text('Father: ${god['relationships']['father']}'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/godDetail',
                            arguments: god,
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _fetchRandomPerson() async {
    try {
      final response = await http.get(
        Uri.parse('https://anfi.tk/greekApi/person/random?lang=en'),
      );

      if (response.statusCode == 200) {
        final person = json.decode(response.body);
        if (person['status'] == 'OK') {
          Map<String, dynamic> randomPerson = {
            'name': person['name'].toString().capitalize(),
            'id': person['personID'],
            'relationships': {
              'mother': person['mother']?['name'],
              'father': person['father']?['name'],
              'spouse': person['wife']?.map((w) => w['name']).toList() ?? 
                      person['husband']?.map((h) => h['name']).toList() ?? [],
              'children': [
                ...(person['son']?.map((s) => s['name']).toList() ?? []),
                ...(person['daughter']?.map((d) => d['name']).toList() ?? []),
              ],
            }
          };
          
          Navigator.pushNamed(
            context,
            '/godDetail',
            arguments: randomPerson,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching random person: $e')),
      );
    }
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
