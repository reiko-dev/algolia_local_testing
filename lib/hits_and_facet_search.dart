import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';

class HitsAndFacetSearch extends StatefulWidget {
  const HitsAndFacetSearch({super.key});

  @override
  State<HitsAndFacetSearch> createState() => _HitsAndFacetSearchState();
}

class _HitsAndFacetSearchState extends State<HitsAndFacetSearch> {
  // Create a multi searcher.
  // The Searcher performs search requests and obtains search result
  final multiSearcher = MultiSearcher(
    applicationID: 'latency',
    apiKey: '1f6fd3a6fb973cb08419fe7d288fa4db',
  );

  late FacetSearcher facetSearcher;
  late HitsSearcher hitsSearcher;

  _HitsAndFacetSearchState() {
    hitsSearcher = multiSearcher.addHitsSearcher(
      initialState: const SearchState(
        indexName: 'instant_search',
      ),
    );
    facetSearcher = multiSearcher.addFacetSearcher(
        initialState: const FacetSearchState(
      facet: 'brand',
      searchState: SearchState(
        indexName: 'instant_search',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              onChanged: (input) {
                facetSearcher.query(input);
                hitsSearcher.query(input);
              }, // 3. Run your search operations
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Column(children: [
        const Header(title: 'Brands'),
        Expanded(
          child: StreamBuilder<FacetSearchResponse>(
            // Listen and display facet search results
            stream: facetSearcher.responses,
            builder: (
              BuildContext context,
              AsyncSnapshot<FacetSearchResponse> snapshot,
            ) {
              if (snapshot.hasData) {
                final response = snapshot.data;
                final facets = response?.facetHits.toList() ?? [];
                return ListView.builder(
                  itemCount: facets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final facet = facets[index];
                    return ListTile(
                      title: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleSmall,
                          children: facet.getHighlightedString().toInlineSpans()
                            ..add(TextSpan(text: '(${facet.count})')),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        const Divider(),
        const Header(title: 'Items'),
        Expanded(
          child: StreamBuilder<SearchResponse>(
            // Listen and display hits search results
            stream: hitsSearcher.responses,
            builder: (
              BuildContext context,
              AsyncSnapshot<SearchResponse> snapshot,
            ) {
              if (snapshot.hasData) {
                final response = snapshot.data;
                final hits = response?.hits.toList() ?? [];
                return ListView.builder(
                  itemCount: hits.length,
                  itemBuilder: (BuildContext context, int index) {
                    final hit = hits[index];
                    return ListTile(
                      title: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleSmall,
                          children:
                              hit.getHighlightedString('name').toInlineSpans(),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        )
      ]),
    );
  }
}

class Header extends StatelessWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
