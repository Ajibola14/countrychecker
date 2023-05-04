import 'package:flutter/material.dart';
import 'package:udemy/countrydetails.dart';

class CountryContainer extends StatelessWidget {
  const CountryContainer({
    super.key,
    required this.name,
    required this.flag,
    required this.population,
  });
  final String name;
  final String flag;
  final int population;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return CountryDetails();
          },
        ));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 2.0),],
            borderRadius: BorderRadius.circular(10),
            border: Border.all()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              flag,
              height: 110,
            ),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            Text(
              population.toString(),
              style: TextStyle(color: Colors.black54),
            ),
            Text("countrylanguage"),
          ],
        ),
      ),
    );
  }
}
