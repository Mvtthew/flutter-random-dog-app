import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/models/Dog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Dog> _randomDog;

  void _getDog() {
    setState(() {
      _randomDog = getRandomDog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.favorite_border),
          title: Text("Random happy dog"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 4,
                child: FutureBuilder(
                    future: _randomDog,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(snapshot.data.message))),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Failed to fetch dog');
                      }
                      return Text('No dog');
                    })),
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton.icon(
                        onPressed: _getDog,
                        icon: Icon(Icons.favorite_border),
                        label: Text("Get random dog")),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
