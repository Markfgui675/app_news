import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map<String, dynamic>> pesquisar() async {

    var url = Uri.parse(
        'https://newsdata.io/api/1/news?apikey=pub_21979661ed19b0cd99f5cca537c4ef5fbca95&q=pizza'
    );
    var response = await http.get(url);

    print('Data atual: ${DateTime.now()}');
    print(response.statusCode);
    if(response.statusCode == 200){
      print(json.decode(response.body));
      return json.decode(response.body);
    }
    else {
      throw Exception('Erro ao carregar dados do servidor.');
    }

  }


  @override
  void initState() {
    super.initState();
    //pesquisar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notícias'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: pesquisar(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text('Erro ao carregar notícias'),
            );
          }

          if(snapshot.hasData){

            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  return ListTile(

                    title: Text(snapshot.data!['results'][index]['title']),

                  );
                }
            );

          }

          return Center(
            child: CircularProgressIndicator()
          );
        },
      ),
    );
  }
}

