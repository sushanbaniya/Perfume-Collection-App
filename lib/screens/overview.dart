import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perfume_app/widgets/drawer.dart';
import '../models/perfume.dart';

class Overview extends StatefulWidget {
  static const routeName = '/overview';
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  var _isInit = true;
  var _isLoading = false;
  List<Perfume> webPerfumes = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      const url =
          'https://perfume11117-default-rtdb.firebaseio.com/perfumes.json';
      final response = await http.get(Uri.parse(url));
      final List<Perfume> loadedPerfumes = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((perfumeId, perfumeData) {
        // print(perfumeId);
        loadedPerfumes.add(
          Perfume(
            id: perfumeId,
            name: perfumeData['name'],
            description: perfumeData['description'],
            imageUrl: perfumeData['imageUrl'],
            price: perfumeData['price'].toString(),
            // date: perfumeData['date'] as DateTime,
          ),
        );
        setState(() {
          webPerfumes = loadedPerfumes;
        });
      });
      // print(json.decode(response.body)['name']);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> delete(String id) async {
    final url =
        'https://perfume11117-default-rtdb.firebaseio.com/perfumes/$id.json';
    try {
      await http.delete(Uri.parse(url));
       setState(() {
      webPerfumes.removeWhere((listItem) => listItem.id == id);
    });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Deletion Failed'),
          actions: [
            ElevatedButton(child: Text('OKAY'), onPressed: () {
              Navigator.of(context).pop();
            })
          ]
        ),
      );
    }
   
  }

  Future<void> update(String id) async {
    final url =
        'https://perfume11117-default-rtdb.firebaseio.com/perfumes/$id.json';
    setState(() {
      _isLoading = true;
    });
    await http.patch(Uri.parse(url),
        body: json.encode({
          'price': 99999,
        }));
    setState(() {
      _isLoading = false;
    });
    final perfumeIndex =
        webPerfumes.indexWhere((listItem) => listItem.id == id);

    setState(() {
      webPerfumes[perfumeIndex].price = 99999.toString();
    });
  }
  // @override
  // void initState() {
  // const url = 'https://perfume11117-default-rtdb.firebaseio.com/perfumes.json';
  // final response = http.get(Uri.parse(url));

  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('OVERVIEW SCREEN'),
          centerTitle: true,
        ),
        drawer: MyDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  const url =
                      'https://perfume11117-default-rtdb.firebaseio.com/perfumes.json';
                  final response = await http.get(Uri.parse(url));
                  final List<Perfume> loadedPerfumes = [];
                  final extractedData =
                      json.decode(response.body) as Map<String, dynamic>;
                  extractedData.forEach((perfumeId, perfumeData) {
                    // print(perfumeId);
                    loadedPerfumes.add(
                      Perfume(
                        id: perfumeId,
                        name: perfumeData['name'],
                        description: perfumeData['description'],
                        imageUrl: perfumeData['imageUrl'],
                        price: perfumeData['price'].toString(),
                        // date: perfumeData['date'] as DateTime,
                      ),
                    );
                    setState(() {
                      webPerfumes = loadedPerfumes;
                    });
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...(webPerfumes.map((webPerfume) {
                        return Column(
                          children: [
                            SizedBox(height: 18),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(border:Border.all(color: Colors.black, width: 2), 
                                color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                borderRadius: BorderRadius.circular(18),
                                ),
                                height: 390,
                                width:  200,
                                child: Column(
                                  children: [
                                    Text(webPerfume.name.toUpperCase(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)),
                                    SizedBox(height: 18),
                                    Container(
                                      height: 150,
                                      width: 100,
                                      child: Image.network(webPerfume.imageUrl,
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(height: 18),
                                    
                                    Center(child: Text(webPerfume.description.toUpperCase(), style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, ), textAlign: TextAlign.center,)),
                                    SizedBox(height: 18),

                                    Text('Rs. ${webPerfume.price}'),
                                    SizedBox(height: 18),

                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            delete(webPerfume.id);
                                          },
                                          iconSize: 50,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.update),
                                          onPressed: () {
                                            update(webPerfume.id);
                                          },
                                          iconSize: 50,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 18),
                          ],
                        );
                      }).toList())
                    ],
                  ),
                ),
              ));
  }
}
