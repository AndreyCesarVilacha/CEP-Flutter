import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerCep = TextEditingController();

  //Caso o resultado seja do tipo null ele vai mostar uma string vazia
  String _resultado = null ?? "";

  _recuperarCep() async {
    
    String cepDigitado = _controllerCep.text;
    String url = "https://viacep.com.br/ws/${cepDigitado}/json/";

    http.Response response;
    //A palavra "wait" é usada para aguardar a resposta da requisição
    //Você não pode passar strings para requisições http no flutter precisa ser to tipo uri
    //Mas pode converter uma string para uri
    response = await http.get(Uri.parse(url));

    //Mostrando o codigo de estado da requisição
    //print("Resposta: " + response.statusCode.toString());
    //Mostrando o corpo do json em formato de string
    //print("Resposta: " + response.body);

    Map<String, dynamic> retorno = json.decode(response.body);
    //String logradouro = retorno["logradouro"];

    setState(() {
      _resultado =
          "Logradouro: ${retorno["logradouro"]} \n \n Bairro: ${retorno["bairro"]} \n \n complemento: ${retorno["complemento"]} \n \n localidade: ${retorno["localidade"]}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço Web"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: "Digite o cep, ex: 05428200 "),
              style: TextStyle(
                fontSize: 20,
              ),
              controller: _controllerCep,
            ),
            ElevatedButton(
              onPressed: _recuperarCep,
              child: Text("Clique aqui"),
            ),
            Text(_resultado.toString())
          ],
        ),
      ),
    );
  }
}
