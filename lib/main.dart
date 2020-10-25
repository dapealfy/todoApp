import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo1/detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List listTodo = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController todoController = TextEditingController();
  TextEditingController updateController = TextEditingController();

  void getData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      listTodo = json.decode(prefs.getString('listTodo'));
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  Future<AlertDialog> displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tambahkan Todo'),
            content: TextField(
              controller: todoController,
              decoration: InputDecoration(hintText: 'Masukkan task disini'),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  var data = {
                    'title': todoController.text,
                  };
                  Navigator.pop(context);
                  tambahDataTodo(data);
                },
                child: Text('Tambah'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Batal'),
              ),
            ],
          );
        });
  }

  void tambahDataTodo(data) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      listTodo.add(data);
      prefs.setString('listTodo', json.encode(listTodo));
    });
    todoController.clear();
  }

  void hapusData(data) {
    setState(() {
      listTodo.remove(data);
    });
  }

  Future<AlertDialog> displayDialogUpdate(BuildContext context, index) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Todo'),
            content: TextField(
              controller: updateController,
              decoration: InputDecoration(hintText: 'Masukkan task disini'),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  updateDataTodo(index, updateController.text);
                },
                child: Text('Ubah'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Batal'),
              ),
            ],
          );
        });
  }

  void updateDataTodo(index, title) {
    setState(() {
      listTodo[index]['title'] = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Application'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listTodo.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                  title: listTodo[index]['title'],
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 5,
                          )
                        ]),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            listTodo[index]['title'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.orange,
                                onPressed: () {
                                  updateController.text =
                                      listTodo[index]['title'];
                                  displayDialogUpdate(context, index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  hapusData(listTodo[index]);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                // return ListTile(
                //   title: Text(listTodo[index]['title']),
                //   trailing: IconButton(
                //     onPressed: () {
                //       hapusData(listTodo[index]);
                //     },
                //     icon: Icon(Icons.delete),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
