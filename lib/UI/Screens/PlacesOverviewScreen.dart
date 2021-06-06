import 'package:expeditions/Providers/Places.dart';
import 'package:expeditions/UI/Screens/AddPlaceScreen.dart';
import 'package:expeditions/UI/Screens/PlaceDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesOverviewScreen extends StatelessWidget {
  static final id = 'places-overview-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          'Expeditions',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddPlaceScreen.id),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).iconTheme.color,
              ))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Places>(
                // child:
                //     Center(child: const Text('GOT NO PLACES YET..START ADDING SOME')),
                builder: (ctx, places, ch) => places.items.length == 0
                    ? Center(
                        child:
                            const Text('GOT NO PLACES YET..START ADDING SOME'))
                    : ListView.builder(
                        itemCount: places.items.length,
                        itemBuilder: (ctx, i) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(places.items[i].image),
                            ),
                            title: Text(places.items[i].title),
                            subtitle: Text(places.items[i].location.address),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlaceDetailsScreen.id,
                                  arguments: places.items[i].id);
                            },
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
