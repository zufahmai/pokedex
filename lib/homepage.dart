import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokedex/pokemon.dart';
import 'package:pokedex/pokemondetail.dart';
import 'package:sticky_headers/sticky_headers.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  var url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  PokeHub pokeHub;
  List<String> listHeader = [];
  List<String> listTitle = [];
  List<String> listImage = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPokemonData();
  }

  fetchPokemonData() async {
    var response = await http.get(url);
    var decodedJsonData = jsonDecode(response.body);
    pokeHub = PokeHub.fromJson(decodedJsonData);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("What's that Pokemon"),
        backgroundColor: Colors.deepOrange,
      ),
      body: pokeHub == null
          ? Center(
        child: CircularProgressIndicator(),
      ) : gridHeader()
    );
  }

  Widget gridHeader() {
      var header;
      List<Pokemon> pokeList = pokeHub.pokemon;
      pokeList.sort((a, b) {
          return a.typeString.compareTo(b.typeString);
      });
      for(Pokemon p in pokeList) {
          header = new StringBuffer();
          if(!listHeader.contains(p.typeString)) {
             listHeader.add(p.typeString);
          }
      }

      return new ListView.builder(itemCount: listHeader.length, itemBuilder: (context, index){
        var selectedHeaderType = listHeader[index];
        var currentData = pokeList.where((pokemon) => pokemon.typeString == selectedHeaderType);
        return new StickyHeader(

            header: new Container(
              height: 38.0,
              color: Colors.green,
              padding: new EdgeInsets.symmetric(horizontal: 12.0),
              alignment: Alignment.centerLeft,
              child: new Text(listHeader[index],
              style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
          ),
        ),
          content: Container(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: currentData
                  .map((poke) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PokeDetail(
                              pokemon: poke,
                            )));
                  },
                  child: Hero(
                    tag: poke.img,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.2,
                            width:
                            MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkImage(poke.img))),
                          ),
                          Text(
                            poke.name,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
        );

      },
        shrinkWrap: true,
      );
  }
}