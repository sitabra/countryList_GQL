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
  // ignore: prefer_typing_uninitialized_variables
  var countries;

  List searchedItems = []; //to store searched list items
  List searchedItemsIndexPosition = []; //to store searched list items index
  Future<void> search(String query) async {
    searchedItemsIndexPosition.clear(); //to clear searched list items index
    List dummyList = []; // initialise a dummy list
    dummyList.addAll(countries); // to store all countries data on dummy list
    if(query.isNotEmpty){
      List dummyListData = []; // to store list searched data for runtime if query is not empty
      for (var searchedCountry in dummyList) {
        if(searchedCountry.name.toString().toLowerCase().contains(query.toLowerCase())) { // to search on the basis of name of the country
          setState(() {
            dummyListData.add(searchedCountry); // to store searched data on the dummy list data
          });
        }
      }
      setState(() {
        searchedItems.clear(); // to clear the searched data
        searchedItems.addAll(dummyListData); // to add the dummy list data on searched items
        searchedItemsIndexPosition.clear(); //to clear the searched items index position
        for(var i=0; i<searchedItems.length; i++){
          final index = dummyList.indexWhere((element) => // to check the index of element
          element.name == searchedItems[i].name); // to match the element index with searched item index
          searchedItemsIndexPosition.add(index); //to add the searched item index on searched item index position list
          debugPrint(index.toString());
        }
        if(searchedItemsIndexPosition.isEmpty){ // to check if the list is empty
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("NO COUNTRY WITH THIS NAME"),
          ));
        }else{

        }
      });
      searchedItems.clear(); // to clear the searched item list
      for(var i=0; i<searchedItemsIndexPosition.length; i++){
        searchedItems.add(countries[int.parse(searchedItemsIndexPosition[i].toString())]);
      }
      debugPrint(searchedItems.toString());
      return;
    }  else {
      setState(() {
        searchedItems.clear();
      });
    }

  }



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
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange)),
                    hintText: "Country Name",
                  ),
                  onChanged: (v){
                    search(v);
                  },
                ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<Country>>(
                future: getAllCountries(),
                builder: (context, snapshot) {
                  return snapshot.connectionState==ConnectionState.done?
                  pickCountriesWidget(context, snapshot):const Center(child:CircularProgressIndicator());
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
      countries = snapshot.data;
    if (snapshot.connectionState == ConnectionState.done) {
      return searchedItems.isEmpty?
      ListView.builder(
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
            }): ListView.builder(
          itemCount: searchedItems.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, index){
            Country project = searchedItems[index];
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
