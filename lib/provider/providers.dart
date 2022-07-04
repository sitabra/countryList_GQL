import 'package:flutter/material.dart';

import '../model/country_model.dart';

class CountryProvider with ChangeNotifier {
 List<Country> allCountriesList = [];
 dynamic allLanguagesList;
 String? selectedLanguage;
 List searchedItems = [];
 List searchedItemsIndexPosition = [];

 void addCountries(AsyncSnapshot<List<Country>> snapshot) {
   allCountriesList = snapshot.data!;
   notifyListeners();
 }
 void addLanguages(AsyncSnapshot<List<Languages>> snapshot) {
   allLanguagesList = snapshot.data;
   notifyListeners();
 }
 void getSelectedLanguage(String? value) {
   selectedLanguage = value;
   notifyListeners();
 }
 void getSelectedItems(List value) {
   searchedItems.addAll(value);
   notifyListeners();
 }
 void getIndexPosition(List value) {
   searchedItemsIndexPosition = value;
   notifyListeners();
 }
}