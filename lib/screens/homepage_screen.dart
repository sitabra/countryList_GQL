import 'package:countries_list_with_graphql/screens/details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../model/country_model.dart';
import '../provider/providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // ignore: prefer_typing_uninitialized_variables
  // ignore: prefer_typing_uninitialized_variables
  var allLanguages;
  ///this function is for the searching country on CODE
  Future<void> search(String query, dynamic savedCountry,
      List searchedItemsIndexPosition, List searchedItems) async {
    searchedItems.clear(); //to clear searched list items index
    searchedItemsIndexPosition.clear();
    List dummyList = []; // initialise a dummy list
    dummyList.addAll(savedCountry); // to store all countries data on dummy list
    if (query.isNotEmpty) {
      List dummyListData = []; // to store list searched data for runtime if query is not empty
      for (var searchedCountry in dummyList) {
        if (searchedCountry.code.toString().toLowerCase() == query.toLowerCase()) {
          dummyListData.add(
              searchedCountry); // to store searched data on the dummy list data
        }
      }
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
      Provider.of<CountryProvider>(context, listen: false)
          .getSelectedItems(dummyListData);
      Provider.of<CountryProvider>(context, listen: false)
          .getIndexPosition([]); //to clear the searched items index position
      for (var i = 0; i < searchedItems.length; i++) {
        final index = dummyList.indexWhere((element) =>
            element.code ==
            searchedItems[i]
                .code); // to match the element index with searched item index
        Provider.of<CountryProvider>(context, listen: false)
            .getIndexPosition([index]);
      }
      if (searchedItemsIndexPosition.isEmpty) {
        // to check if the list is empty
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No country with this country code"),
        ));
      } else {
        const Text("Country found with this code");
      }
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]); // to clear the searched item list
      for (var i = 0; i < searchedItemsIndexPosition.length; i++) {
        Provider.of<CountryProvider>(context, listen: false).getSelectedItems([
          savedCountry[int.parse(searchedItemsIndexPosition[i].toString())]
        ]);
      }
    } else {
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
    }
  }

  Future<List<Country>> future = getAllCountries();

  Future<List<Languages>> futureLang = getAllLanguages();

  ///this function is for filter the search results
  Future<void> filterItem(String query, dynamic savedCountries,
      List searchedItemsIndexPosition, List searchedItems) async {
    searchedItemsIndexPosition.clear();
    searchedItems.clear();
    List dummySearchList = [];
    dummySearchList.addAll(savedCountries);
    if (kDebugMode) {
      print('printing data - $dummySearchList');
    }
    if (query.isNotEmpty) {
      List dummyListData = [];
      for (var item in dummySearchList) {
        debugPrint("data here - ${item.languages}");
        for (var i = 0; i < item.languages.length; i++) {
          Languages lang = item.languages![i];
          if (kDebugMode) {
            print("here: ${item.languages![i]}");
          }
          if (lang.name.toString().toLowerCase() == query.toLowerCase()) {
            if (kDebugMode) {
              print("selected here: ${lang.name}");
            }
            Provider.of<CountryProvider>(context, listen: false)
                .getSelectedLanguage(lang.name);
            dummyListData.add(item);
          }
        }
      }
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
      Provider.of<CountryProvider>(context, listen: false)
          .getSelectedItems(dummyListData);
      Provider.of<CountryProvider>(context, listen: false).getIndexPosition([]);
      for (var i = 0; i < searchedItems.length; i++) {
        final index = dummySearchList
            .indexWhere((element) => element.code == searchedItems[i].code);
        Provider.of<CountryProvider>(context, listen: false)
            .getIndexPosition([index]);
      }
      for (var i = 0; i < searchedItemsIndexPosition.length; i++) {
        Provider.of<CountryProvider>(context, listen: false).getSelectedItems([
          savedCountries[int.parse(searchedItemsIndexPosition[i].toString())]
        ]);
      }
      return;
    } else {
      Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
    }
  }

  void _modalBottomSheetMenu(
      AsyncSnapshot<List<Languages>> snapshot,
      dynamic savedCountries,
      String? selectedLanguage,
      List searchedItemsIndexPosition,
      List searchedItems) {
    var languageList = snapshot.data;
    if (snapshot.connectionState == ConnectionState.done) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ListView.builder(
                itemCount: languageList!.length,
                itemBuilder: (BuildContext context, int index) {
              Languages lang = languageList[index];
              languageList.sort((a, b) => a.name!.compareTo(b.name!));
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                  onPressed: () {
                if (selectedLanguage.toString() !=
                    lang.name.toString()) {
                  filterItem(lang.name.toString(), savedCountries,
                      searchedItemsIndexPosition, searchedItems);
                  Provider.of<CountryProvider>(context, listen: false)
                      .getSelectedLanguage(lang.name.toString());
                } else {
                  Provider.of<CountryProvider>(context, listen: false)
                      .getSelectedLanguage(null);
                  Provider.of<CountryProvider>(context, listen: false)
                      .getIndexPosition([]);
                  Provider.of<CountryProvider>(context, listen: false).getSelectedItems([]);
                  searchedItems.clear();
                }
                      Navigator.pop(context);
                   },
                      child: Text(lang.name.toString(),
                    style: TextStyle(fontSize: 20,
                    color: selectedLanguage.toString() !=
                    lang.name.toString()
                    ? Colors.white
                        : Colors.red),
            )));
            });
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Data Loading")));
    }
  }

  @override
  Widget build(BuildContext context) {
    List storedCountry = Provider.of<CountryProvider>(context).allCountriesList;
    String? selectedLanguage = Provider.of<CountryProvider>(context).selectedLanguage;
    List searchedItems = Provider.of<CountryProvider>(context).searchedItems;
    List searchedItemsIndexPosition = Provider.of<CountryProvider>(context).searchedItemsIndexPosition;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text("Country Directory"),
        actions: [
          FutureBuilder<List<Languages>>(
            future: futureLang,
            builder: (context, snapshot) {
              return Stack(children: [
                IconButton(
                    onPressed: () {
                      storedCountry = Provider.of<CountryProvider>(
                          context,
                          listen: false)
                          .allCountriesList;
                      if (storedCountry.isNotEmpty) {
                        _modalBottomSheetMenu(
                            snapshot,
                            storedCountry,
                            selectedLanguage,
                            searchedItemsIndexPosition,
                            searchedItems);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Data not present kindly reload"))
                        );
                      }
                    },
                    icon: const Icon(Icons.sort)),
                if (selectedLanguage != null)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Text(
                      '1',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                  )
              ]);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  hintText: "Search with Country Code",
                ),
                onChanged: (v) {
                  Provider.of<CountryProvider>(context, listen: false).getSelectedLanguage(null);
                  search(v, storedCountry, searchedItemsIndexPosition, searchedItems);
                },
              ),
            ),
            if (selectedLanguage != null)
              Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.white60,
                  child: Center(
                    child: RichText(
                text:  TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 36),
                    children: <TextSpan>[
                      const TextSpan(text: 'Selected language: ', style: TextStyle(color: Colors.black)),
                      TextSpan(text: selectedLanguage, style: const TextStyle(color: Colors.blue,
                          decoration: TextDecoration.underline))
                    ],
                ),
                textScaleFactor: 0.5,
              ),
                  )),
            Expanded(
              child: FutureBuilder<List<Country>>(
                future: getAllCountries(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? pickCountriesWidget(context, snapshot, searchedItems)
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

  Widget pickCountriesWidget(BuildContext context,
      AsyncSnapshot<List<Country>> snapshot, List searchedItems) {
    if (snapshot.connectionState == ConnectionState.done) {
      Provider.of<CountryProvider>(context, listen: false)
          .addCountries(snapshot);
      return searchedItems.isEmpty
          ? ListView.separated(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctx, index) {
                Country project = snapshot.data![index];
                snapshot.data!.sort((a, b) => a.name!.compareTo(b.name!));
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                                  code: project.code!,
                                  countryName: project.name!,
                                )));
                  },
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFFFFF),
                          child: Text(project.emoji.toString()),
                        ),
                        const SizedBox(width: 50,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              project.name.toString(),
                              overflow: TextOverflow.ellipsis,
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
                        const Spacer(),
                        Text(
                          project.code.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) =>  const Divider(thickness: 1,) ,)
          : ListView.separated(
              itemCount: searchedItems.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctx, index) {
                Country project = searchedItems[index];
                snapshot.data!.sort((a, b) => a.code!.compareTo(b.code!));
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                                  code: project.code!,
                                  countryName: project.code!,
                                )));
                  },
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFFFFF),
                          child: Text(project.emoji.toString()),
                        ),
                        const SizedBox(width: 50,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              project.name.toString(),
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
                        const Spacer(),
                        Text(
                          project.code.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) => const Divider(thickness: 1,),);
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
