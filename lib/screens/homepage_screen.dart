import 'package:countries_list_with_graphql/screens/details_screen.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../model/country_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text("Country Directory"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                child:const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange)),
                    hintText: "Country Name",
                  ),
                ),),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<Country>>(
                future: getAllCountries(),
                builder: (context, snapshot) {
                  return snapshot.connectionState==ConnectionState.done?pickCountriesWidget(context, snapshot):const Center(child:CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget pickCountriesWidget(BuildContext context,
      AsyncSnapshot<List<Country>> snapshot) {

    if (snapshot.connectionState == ConnectionState.done) {
      return ListView.builder(
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, index){
              Country project = snapshot.data![index];
              snapshot.data!.sort((a, b) => a.name!.compareTo(b.name!));
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  DetailsScreen(code: project.code!,
                          countryName: project.name!,)));
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        border: Border.all(
                            color: Colors.pink.shade800, // Set border color
                            width: 1.0),   // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius
                        boxShadow: const [
                          BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFFFFFF),
                            child: Text(project.emoji.toString()),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(project.name.toString(),
                                style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              Text(project.capital.toString(),
                                style: const TextStyle(fontStyle: FontStyle.italic),),
                            ],
                          ),
                          Text(project.code.toString(),
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
