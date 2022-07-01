import 'package:countries_list_with_graphql/screens/details_screen.dart';
import 'package:flutter/foundation.dart';
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
  String? selectedLanguage;
  // ignore: prefer_typing_uninitialized_variables
  var allLanguages;

  List searchedItems = []; //to store searched list items
  List searchedItemsIndexPosition = [];//to store searched list items index

  Future<void> search(String query) async {
    searchedItemsIndexPosition.clear(); //to clear searched list items index
    List dummyList = []; // initialise a dummy list
    dummyList.addAll(countries); // to store all countries data on dummy list
    if (query.isNotEmpty) {
      List dummyListData =
          []; // to store list searched data for runtime if query is not empty
      for (var searchedCountry in dummyList) {
        if (searchedCountry.code
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          // to search on the basis of name of the country
          setState(() {
            dummyListData.add(
                searchedCountry); // to store searched data on the dummy list data
          });
        }
      }
      setState(() {
        searchedItems.clear(); // to clear the searched data
        searchedItems.addAll(
            dummyListData); // to add the dummy list data on searched items
        searchedItemsIndexPosition
            .clear(); //to clear the searched items index position
        for (var i = 0; i < searchedItems.length; i++) {
          final index = dummyList.indexWhere(
              (element) => // to check the index of element
                  element.code ==
                  searchedItems[i]
                      .code); // to match the element index with searched item index
          searchedItemsIndexPosition.add(
              index); //to add the searched item index on searched item index position list
          debugPrint(index.toString());
        }
        if (searchedItemsIndexPosition.isEmpty) {
          // to check if the list is empty
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("NO COUNTRY WITH THIS NAME"),
          ));
        } else {}
      });
      searchedItems.clear(); // to clear the searched item list
      for (var i = 0; i < searchedItemsIndexPosition.length; i++) {
        searchedItems.add(
            countries[int.parse(searchedItemsIndexPosition[i].toString())]);
      }
      debugPrint(searchedItems.toString());
      return;
    } else {
      setState(() {
        searchedItems.clear();
      });
    }
  }

  Future<List<Country>> future = getAllCountries();

  Future<List<Languages>> futureLang = getAllLanguages();

  Future<void> filter(String query) async {
    searchedItemsIndexPosition.clear();
    List dummySearchList = [];
    dummySearchList.addAll(countries);
    if (query.isNotEmpty) {
      List dummyListData = [];
      for (var item in dummySearchList) {
        debugPrint(item.languages.toString());
        for (var i = 0; i < item.languages.length; i++) {
          Languages lang = item.languages![i];
          if (lang.name.toString().toLowerCase() == query.toLowerCase()) {
            setState(() {
              dummyListData.add(item);
            });
          }
        }
      }
      setState(() {
        searchedItems.clear();
        searchedItems.addAll(dummyListData);
        searchedItemsIndexPosition.clear();
        for (var i = 0; i < searchedItems.length; i++) {
          final index = dummySearchList
              .indexWhere((element) => element.code == searchedItems[i].code);
          searchedItemsIndexPosition.add(index);
        }
      });
      searchedItems.clear();
      for (var i = 0; i < searchedItemsIndexPosition.length; i++) {
        searchedItems.add(
            countries[int.parse(searchedItemsIndexPosition[i].toString())]);
      }
      return;
    } else {
      setState(() {
        searchedItems.clear();
      });
    }
  }


  Future<void> filterItem(String query) async {
    searchedItemsIndexPosition.clear();
    List dummySearchList = [];
    dummySearchList.addAll(countries);
    if (kDebugMode) {
      print('printing data - $dummySearchList');
    }
    if(query.isNotEmpty) {
      List dummyListData = [];
      for (var item in dummySearchList) {
        debugPrint("data - ${item.languages}");
        for(var i=0; i<item.languages.length; i++) {
          Languages lang = item.languages![i];
          if(lang.name.toString().toLowerCase()==query.toLowerCase()) {
            setState(() {
              dummyListData.add(item);
            });
          }
        }
      }
      setState(() {
        searchedItems.clear();
        searchedItems.addAll(dummyListData);
        searchedItemsIndexPosition.clear();
        for(var i=0; i<searchedItems.length; i++){
          final index = dummySearchList.indexWhere((element) =>
          element.code == searchedItems[i].code);
          searchedItemsIndexPosition.add(index);
        }
      });
      searchedItems.clear();
      for(var i=0; i<searchedItemsIndexPosition.length; i++){
        searchedItems.add(countries[int.parse(searchedItemsIndexPosition[i].toString())]);
      }
      return;
    } else {
      setState(() {
        searchedItems.clear();
      });
    }
  }
  void _modalBottomSheetMenu(AsyncSnapshot<List<Languages>> snapshot) {
    var languageList = snapshot.data;
    if (snapshot.connectionState == ConnectionState.done) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            shrinkWrap: true,
            children: List.generate(
                languageList!.length,
                    (index) {
                  Languages lang = languageList[index];
                  languageList.sort((a, b) => a.name!.compareTo(b.name!));
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        if(selectedLanguage.toString()!=lang.name.toString()) {
                          filterItem(lang.name.toString());
                          setState(() {
                            selectedLanguage = lang.name.toString();
                          });
                        }else{
                          setState(() {
                            selectedLanguage = null;
                            searchedItemsIndexPosition.clear();
                            searchedItems.clear();
                          });
                        }
                        Navigator.pop(context);
                      },
                      child: Text(lang.name.toString(), style: TextStyle(color: selectedLanguage.toString()!=lang.name.toString()?Colors.white:Colors.red),),
                    ),
                  );
                }

            )
        );
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Loading")));
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange)),
                        hintText: "Country Name",
                      ),
                      onChanged: (v) {
                        search(v);
                      },
                    ),
                  ),
                  FutureBuilder<List<Languages>>(
                    future: futureLang,
                    builder: (context, snapshot) {
                      return Stack(
                         children :[
                           IconButton(
                            onPressed: () {
                              _modalBottomSheetMenu(snapshot);
                            },
                            icon: const Icon(Icons.sort)),
                           if(selectedLanguage!=null)
                             const Positioned( //<-- SEE HERE
                               right: 0,
                               top: 0,
                               child: Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.red),),
                             )
                         ]
                      );
                    },
                  ),
                ],
              ),
            ),
            if(selectedLanguage!=null)
              const SizedBox(height: 10,),
            if(selectedLanguage!=null)
              Text("Selected Language - $selectedLanguage"),
            const SizedBox(height: 50),
            Expanded(
              child: FutureBuilder<List<Country>>(
                future: getAllCountries(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? pickCountriesWidget(context, snapshot)
                      : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget pickCountriesWidget(
      BuildContext context, AsyncSnapshot<List<Country>> snapshot) {
    countries = snapshot.data;
    if (snapshot.connectionState == ConnectionState.done) {
      return searchedItems.isEmpty
          ? ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctx, index) {
                Country project = snapshot.data![index];
                snapshot.data!.sort((a, b) => a.code!.compareTo(b.code!));
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                    code: project.code!,
                                    countryName: project.name!,
                                  )));
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          border: Border.all(
                              color: Colors.pink.shade800, // Set border color
                              width: 1.0), // Set border width
                          borderRadius: const BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
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
                                Text(
                                  project.code.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  project.capital.toString(),
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            Text(
                              project.code.toString(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
          : ListView.builder(
              itemCount: searchedItems.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctx, index) {
                Country project = searchedItems[index];
                snapshot.data!.sort((a, b) => a.code!.compareTo(b.code!));
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                    code: project.code!,
                                    countryName: project.code!,
                                  )));
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          border: Border.all(
                              color: Colors.pink.shade800, // Set border color
                              width: 1.0), // Set border width
                          borderRadius: const BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
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
                                Text(
                                  project.code.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  project.capital.toString(),
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            Text(
                              project.code.toString(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
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
