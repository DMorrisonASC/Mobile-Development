import 'package:flutter/material.dart';

import 'model/nearby_response.dart';

class ListBathrooms extends StatefulWidget {
  final ScrollController scrollController;
  final NearbyPlacesResponse nearbyPlacesResponse;

  const ListBathrooms({required this.scrollController, required this.nearbyPlacesResponse });
  @override
  _ListBathroomsState createState() => _ListBathroomsState();
}

class _ListBathroomsState extends State<ListBathrooms> {
  final DraggableScrollableController sheetController = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    print(widget.nearbyPlacesResponse);
    if (widget.nearbyPlacesResponse.results != null) {
      debugPrint("Here!");
    }
    else{
      debugPrint("Null!");
    }
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: widget.nearbyPlacesResponse.results != null ?
      CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SliverAppBar(
            title: Text('My App'),
            primary: false,
            pinned: true,
            centerTitle: false,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return nearbyPlacesWidget(widget.nearbyPlacesResponse.results![index]);
              },
              childCount: widget.nearbyPlacesResponse.results?.length,
            ),
          ),
        ],

      ) : Center(
        child: CircularProgressIndicator(),
      ),

    );
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Name: " + results.name!),
          Text("ID: " + results.placeId!),
          Text("Location: " +
              results.geometry!.location!.lat.toString() +
              " , " +
              results.geometry!.location!.lng.toString()),
          Text(results.openingHours != null ? "Open" : "Closed"),
        ],
      ),
    );
  }
}
