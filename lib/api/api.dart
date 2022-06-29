import 'package:countries_list_with_graphql/common/apiConstant.dart';
import 'package:graphql/client.dart';

import '../model/country_model.dart';



final _httpLink = HttpLink(
  ApiConstant.baseUrl
);

final GraphQLClient client = GraphQLClient(
  link: _httpLink,
  cache: GraphQLCache(),
);

const _getAllCountries = r'''
query {
  countries{
    code
    name
    capital
    emoji
    }
  }
''';

const _getCountry = r'''
query getCountry($code:ID!){
  country(code:$code){
    name
    capital
    code
    native
    currency
    phone
    emoji
    languages {
    name
    native
    }
  }
}

''';

Future<List<Country>> getAllCountries() async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getAllCountries),
    ),
  );

  var json = result.data!["countries"];
  List<Country> countries = [];

  for (var res in json) {
    var country = Country.fromJson(res);
    countries.add(country);
  }
  return countries;
}

Future<Country> getCountry(String code) async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getCountry),
      variables: {
        "code": code,
      },
    ),
  );


  var json = result.data!["country"];


  var country = Country.fromJson(json);
  return country;
}