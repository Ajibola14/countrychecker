import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:udemy/model/country.dart';

import 'country_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Country> _foundCountries = [];
  List<Country> _results = [];
  final TextEditingController _controller = TextEditingController();
  late Future Countries;
  @override
  void initState() {
    super.initState();
    Countries = fetchcountry();
    fetchcountry().then((value) {
      setState(() {
        _foundCountries = value;
      });
    });
  }

  _runFilter(String value) {
    List<Country> results = [];
    if (value.isEmpty) {
      results = _foundCountries;
    } else {
      results = _foundCountries
          .where((country) =>
              country.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Country"),
      ),
      body: FutureBuilder(
        future: Countries,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$error"),
                  ElevatedButton(
                      onPressed: () {
                        fetchcountry();
                      },
                      child: Icon(Icons.refresh_sharp))
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black)),
                      child: TextField(
                        onChanged: (value) {
                          return _runFilter(value);
                        },
                        controller: _controller,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            iconColor: Colors.black,
                            icon: Icon(Icons.search_outlined),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: "Search"),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: _results.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.5, crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      final country = _results[index];
                      final name = country.name;
                      final flag = country.imagepath;
                      final population = country.population;
                      return CountryContainer(
                        flag: flag,
                        name: name,
                        population: population,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Country>> fetchcountry() async {
    print("st");
    const url = "https://restcountries.com/v3.1/all";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body) as List;
    final transformed = json
        .map((e) => Country(e['flags']['png'], e['name']['common'],
            e['name']['official'], e['population']))
        .toList();
    _results = transformed;
    return transformed;
  }
}
