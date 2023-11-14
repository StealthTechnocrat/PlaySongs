import 'package:flutter/material.dart';
import 'package:music/utils/place_service.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  final sessionToken;
  late PlaceApiProvider apiClient;
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // return FutureBuilder(
    //   future: query == ""
    //       ? null
    //       : apiClient.fetchSuggestions(
    //           query, Localizations.localeOf(context).languageCode),
    //   builder: (context, snapshot) => query == ''
    //       ? Container(
    //           padding: EdgeInsets.all(16.0),
    //           child: Text('Enter your address'),
    //         )
    //       : snapshot.hasData && snapshot.data != null
    //           ? ListView.builder(
    //               itemBuilder: (context, index) => ListTile(
    //                 title:
    //                     Text('ss',
    //                       onTap: () {
    //                         close(context, snapshot.data[index] as Suggestion);
    //                       },
    //                   ),

    //             ),
    //             itemCount: snapshot.data.length,
    //           )
    //           : Container(child: Text('Loading...')
    //         ),
    // );
    return const SizedBox.shrink();
  }
}
