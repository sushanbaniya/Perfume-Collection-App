import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './models/perfume.dart';
import './screens/overview.dart';
import './widgets/drawer.dart';
import './screens/about.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(), routes: {
      Overview.routeName: (context) => Overview(),
      About.routeName: (context) => About(),
    });
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _name = '';
  var _description = '';
  var _imageUrl = '';
  var _price = null;
  List<Perfume> _perfumes = [];
  final _form = GlobalKey<FormState>();

  Future<void> _saveForm() async {
    _form.currentState!.save();
    const url =
        'https://perfume11117-default-rtdb.firebaseio.com/perfumes.json';
    final dateNow = DateTime.now();
    // try {
    await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'name': _name,
          'description': _description,
          'imageUrl': _imageUrl,
          'price': _price,
          'date': dateNow.toIso8601String(),
        },
      ),
    );
    setState(
      () {
        _perfumes.add(
          Perfume(
            id: dateNow.toString(),
            name: _name,
            description: _description,
            imageUrl: _imageUrl,
            price: _price,
            // date: dateNow,
          ),
        );
      },
    );
    // } catch (error) {
    //     await showDialog(
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //         title: Text('An error occured'),
    //         content: Text(error.toString()),
    //         actions: <Widget>[
    //           TextButton(
    //             child: Text('Okay'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       ),
    //     );
    //   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfume App'),
      ),
      drawer: MyDrawer(),
      body: Center(child: Text('ADD ITEMS BY CLICKING ON +'),),
      // body: SingleChildScrollView(
      //   child: Column(children: [
      //     ...(_perfumes.map((perfume) {
      //       return Center(
      //         child: Container(
      //           decoration: BoxDecoration(
      //             border: Border.all(color: Colors.black, width: 2),
      //             color: Colors
      //                 .primaries[Random().nextInt(Colors.primaries.length)],
      //             borderRadius: BorderRadius.circular(18),
      //           ),
      //           height: 380,
      //           width: 200,
      //           child: Column(
      //             children: [
      //               Text(_name.toUpperCase(),
      //                   style: TextStyle(
      //                     fontSize: 30,
      //                     fontWeight: FontWeight.bold,
      //                   )),
      //               SizedBox(height: 18),
      //               Container(
      //                 height: 150,
      //                 width: 100,
      //                 child: Image.network(_imageUrl, fit: BoxFit.cover),
      //               ),
      //               SizedBox(height: 18),

      //               Text(_description.toUpperCase(),
      //                   style: TextStyle(
      //                     fontSize: 18,
      //                     fontStyle: FontStyle.italic,
      //                   )),
      //               SizedBox(height: 18),

      //               Text('Rs. ${_price}'),
      //               SizedBox(height: 18),

      //               // Row(mainAxisAlignment: MainAxisAlignment.center,
      //               //   children: [
      //               //     IconButton(
      //               //       icon: Icon(Icons.delete),
      //               //       onPressed: () {
      //               //         delete(webPerfume.id);
      //               //       },
      //               //       iconSize: 50,
      //               //     ),
      //               //     IconButton(
      //               //       icon: Icon(Icons.update),
      //               //       onPressed: () {
      //               //         update(webPerfume.id);
      //               //       },
      //               //       iconSize: 50,
      //               //     ),
      //               //   ],
      //               // ),
      //             ],
      //           ),
      //         ),
      //       );
      //     }).toList()),
      //   ]),
      // ),
      floatingActionButton: FloatingActionButton(
        // mini: false, materialTapTargetSize: MaterialTapTargetSize.padded,
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: Form(
                      key: _form,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Name of Perfume',
                                  ),
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  onSaved: (newValue) {
                                    setState(() {
                                    _name = newValue.toString();
                                      
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Description of Perfume'),
                                  maxLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  onSaved: (newValue) {
                                    setState(() {
                                    _description = newValue.toString();
                                      
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                        
                                  decoration: InputDecoration(
                                    labelText: 'Image URL',
                                  ),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  onSaved: (newValue) {
                                    setState(() {
                                    _imageUrl = newValue.toString();
                                      
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Price',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  onSaved: (newValue) {
                                    setState(() {
                                    _price = newValue.toString();
                                      
                                    });
                                  }),
                            ),
                            TextButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  _saveForm();
                                  Navigator.of(context).pop();
                                })
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
