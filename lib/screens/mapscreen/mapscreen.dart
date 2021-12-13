import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GooglePlace googlePlace =
      GooglePlace("AIzaSyCMYWYXY7CM6l3axYkOjHIqtuSUsTKbGAs");
  List<AutocompletePrediction> predictions = [];
  late GoogleMapController mapController;
  late DetailsResult detailsResult;

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.queryAutocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Search",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black54,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  autoCompleteSearch(value);
                } else {
                  if (predictions.length > 0 && mounted) {
                    setState(() {
                      predictions = [];
                    });
                  }
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(predictions[index].description!),
                    onTap: () {
                      getDetils(
                        googlePlace: googlePlace,
                        placeId: predictions[index].placeId!,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getDetils(
      {required String placeId, required GooglePlace googlePlace}) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result!;
      });

      print(detailsResult.geometry!.location!.lat);
      print(detailsResult.geometry!.location!.lng);
    }
  }
}
