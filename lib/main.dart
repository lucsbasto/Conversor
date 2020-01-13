import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const api = "https://api.hgbrasil.com/finance?format=json&key=8d11d540";

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  void _realChanged(String text) {
    if (text.isEmpty) {
      dolarController.text = "";
      euroController.text = "";
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      realController.text = "";
      euroController.text = "";
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      dolarController.text = "";
      realController.text = "";
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Color(0xFF303030),
        title: Text(
          "Conversor Top",
          style: TextStyle(color: Color(0XFFF76E1E)),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                "Carregando Dados !",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erro ao carregar as moeda bro ;)"),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150, color: Color(0XFFF76E1E)),
                      Divider(),
                      buildTextField(
                          "Real (BRL)", "R\$  ", realController, _realChanged),
                      Divider(),
                      buildTextField("Dolar (USD)", "\$   ", dolarController,
                          _dolarChanged),
                      Divider(),
                      buildTextField(
                          "Euro (EUR)", "€  ", euroController, _euroChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController controller, Function f) {
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0XFFF76E1E)),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    controller: controller,
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(api);
  return json.decode(response.body);
}
