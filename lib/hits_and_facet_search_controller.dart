import 'dart:async';
import 'dart:convert';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:algolia_local_testing/algolia_credentials.dart';
import 'package:flutter/material.dart';

class HitsAndFacetSearchController extends ChangeNotifier {
  final _streamController = StreamController<List<Company>>();

  // Create a multi searcher.
  // The Searcher performs search requests and obtains search result
  final multiSearcher = MultiSearcher(
    applicationID: algoliaID,
    apiKey: algoliaAPIKey,
  );

  // late FacetSearcher facetSearcher;
  late final _searcher = multiSearcher.addHitsSearcher(
    initialState: const SearchState(
      indexName: 'companies',
      facets: ['*'],
    ),
  );

  // 4.1 Components (disposables) composite
  late final CompositeDisposable _components;

  HitsAndFacetSearchController() {
    _components = CompositeDisposable()..add(_searcher);
    _searcher.responses.listen(_searchResponseToList);
  }

  void _searchResponseToList(SearchResponse response) {
    _streamController
        .add(response.hits.map((e) => Company.fromMap(e)).toList());
  }

  Stream<List<Company>> get companies {
    return _streamController.stream;
  }

  Stream<Map<String, List<Facet>>> get facets {
    return _searcher.responses.map((e) => e.facets);
  }

  void search(String query) {
    _searcher.query(query);
  }

  // 4.2 Dispose of all underlying resources when done
  @override
  void dispose() {
    _components.dispose();
    super.dispose();
  }
}

class Company {
  final String id;
  final String? name;
  final String? cnpj;

  const Company({
    this.name,
    this.cnpj,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'cnpj': cnpj,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['objectID'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      cnpj: map['cnpj'] != null ? map['cnpj'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source) as Map<String, dynamic>);
}
