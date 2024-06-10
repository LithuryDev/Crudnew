import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void addData() async {
    var url = Uri.parse("http://10.0.2.2/tienda/adddata.php");

    await http.post(url, body: {
      "username": controllerUsername.text,
      "password": controllerPassword.text,
      "nivel": _mySelection
    });
  }

  String? _mySelection;
  final List<Map<String, dynamic>> _myJson = [
    {"id": 0, "name": "ventas"},
    {"id": 1, "name": "admin"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Usuarios"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
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
                  Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        child: const Icon(Icons.list),
                      ),
                      const VerticalDivider(
                        width: 40.0,
                      ),
                      Container(
                        height: 50.0,
                        width: 100.0,
                        child: DropdownButtonFormField<String>(
                          isDense: true,
                          hint: const Text("Nivel"),
                          iconSize: 40.0,
                          elevation: 10,
                          value: _mySelection,
                          onChanged: (String? newValue) {
                            setState(() {
                              _mySelection = newValue;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Por favor selecciona un nivel'
                              : null,
                          items: _myJson.map((Map<String, dynamic> map) {
                            return DropdownMenuItem<String>(
                              value: map["name"],
                              child: Text(map["name"]),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(30.0),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addData();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Agregar"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/adminPage');
                    },
                    child: const Text("Salir"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
