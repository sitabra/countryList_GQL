import 'package:flutter/material.dart';

import '../api/api.dart';
import '../model/country_model.dart';
class DetailsScreen extends StatefulWidget {
  final String code;
  final String countryName;
  const DetailsScreen({Key? key, required this.code, required this.countryName}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title:  Text(widget.countryName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Expanded(
              child: FutureBuilder<Country>(
                future: getCountry(widget.code),
                builder: (context, snapshot) {
                  return countryDetailsWidget(context, snapshot);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget countryDetailsWidget(BuildContext context, AsyncSnapshot snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  if (snapshot.hasError) {
    return const Center(
      child: Text("Unable to fetch country data"),
    );
  }
  Country country = snapshot.data;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          "Country Info",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 10),
      Card(
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Name"),
                  Text("Capital"),
                  Text("Country code"),
                  Text("Native"),
                  Text("Currency"),
                  Text("Phone Code"),
                  Text("Emoji"),
                ],
              ),
              const Spacer(flex: 3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(": ${country.name}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(": ${country.capital}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(": ${country.code}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(": ${country.native}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(": ${country.currency}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(": ${country.phone!}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(": ${country.emoji}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      Center(
        child: Column(
          children: [
            const Text("Languages :"),
            ListView.builder(
                  shrinkWrap: true,
                  itemCount: country.languages!.length,
                  itemBuilder: (BuildContext context, index){
                    Languages language = country.languages![index];
                    return Card(child: Text(language.name.toString()));
                  }),
          ],
        ),
      ),
    ],
  );
}