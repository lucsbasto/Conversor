import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const api = "https://api.hgbrasil.com/finance?format=json&key=8d11d540";

void main() async {
  print(await getData());
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Color(0xFF303030),
        title: Text(
          "Conversor",
          style: TextStyle(
            color: Color(0XFFF76E1E),
          ),
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
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Real (BRL)",
                            labelStyle: TextStyle(color: Color(0XFFF76E1E)),
                            border: OutlineInputBorder(),
                            prefixText: "R\$  "),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Dolar (USD)",
                          labelStyle: TextStyle(color: Color(0XFFF76E1E)),
                          border: OutlineInputBorder(),
                          prefixText: "\$   ",
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Euro (EUR)",
                            labelStyle: TextStyle(color: Color(0XFFF76E1E)),
                            border: OutlineInputBorder(),
                            prefixText: "€  "),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                      ),
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

Future<Map> getData() async {
  http.Response response = await http.get(api);
  return json.decode(response.body);
}
