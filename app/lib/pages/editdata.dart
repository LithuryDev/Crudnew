import 'package:app/pages/userlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  final List list;
  final int index;

  const EditData({super.key, required this.list, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  late TextEditingController controllerUsername;
  late TextEditingController controllerPassword;
  final _formKey = GlobalKey<FormState>();

  void editData() async {
    var url = Uri.parse("http://192.168.1.39/studentnotes/editdata.php");
    await http.post(url, body: {
      "id": widget.list[widget.index]['id'],
      "user": controllerUsername.text,
      "password": controllerPassword.text,
    });
  }

  @override
  void initState() {
    controllerUsername =
        TextEditingController(text: widget.list[widget.index]['user']);
    controllerPassword =
        TextEditingController(text: widget.list[widget.index]['password']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EDITAR"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: TextFormField(
                    controller: controllerUsername,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingresa un nombre de usuario";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Usuario",
                      labelText: "Usuario",
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.black),
                  title: TextFormField(
                    controller: controllerPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingresa una Contraseña";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Contraseña",
                      labelText: "Contraseña",
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      editData();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const UserList(), // Asegúrate de que 'Home' esté importado
                        ),
                      );
                    }
                  },
                  child: const Text("Guardar"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
