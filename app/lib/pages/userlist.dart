import 'package:app/pages/addData.dart';
import 'package:app/pages/detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  // Método para obtener los datos desde la API
  Future<List> getData() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.39/studentnotes/getdata.php'),
    );
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de Usuarios"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navega a la pantalla de añadir datos
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const AddData(),
            ),
          );
        },
      ),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return ItemList(list: snapshot.data!);
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  const ItemList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Detail(
                  list: list,
                  index: i,
                ),
              ),
            ),
            child: Card(
              child: ListTile(
                title: Text(
                  list[i]['user'],
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Colors.orangeAccent,
                  ),
                ),
                leading: const Icon(
                  Icons.person_pin,
                  size: 77.0,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
