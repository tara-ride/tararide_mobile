import 'package:tararide_mobile/models/places_data.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

abstract class PlacesRepository {
  Stream<List<Places>> getPlacesList();
  Stream<List<Places>> getPlacesListStream();
  Stream<Places> getPlaceByID(String placeId);
  Future<Places> getPlaceByIDOnce(String placeId);
  Future<List<Places>> getPlacesListOnce();
}

class PlacesRepositoryImplementation implements PlacesRepository {
  @override
  Stream<List<Places>> getPlacesList() async* {
    // This method should be implemented to fetch the list of places from a data source.
    // For now, it yields an empty list.

    // Example: Fetching from a local database or an API can be done here.
    // load the file complete_ncr_list.json from lib/data/complete_ncr_list.json
    // and parse it into a list of Places objects.

    final String jsonString = await rootBundle.loadString('assets/complete_ncr_list.json');

    final List<dynamic> jsonList = json.decode(jsonString);
    final List<Places> placesList = jsonList.map((item) => Places.fromJson(item)).toList();
    yield placesList;
  }

  @override
  Stream<List<Places>> getPlacesListStream() {
    // This method should be implemented to return a stream of places.
    // For now, it returns an empty stream.
    return Stream.empty();
  }

  @override
  Stream<Places> getPlaceByID(String placeId) async* {
    // This method should be implemented to fetch a place by its ID from a data source.
    // For now, it yields null.
    yield Places(name: '', category: '', latitude: 0.0, longitude: 0.0, city: City.CALOOCAN_CITY);
  }

  @override
  Future<Places> getPlaceByIDOnce(String placeId) async {
    // This method should be implemented to fetch a place by its ID once from a data source.
    // For now, it returns an empty Places object.

    final String jsonString = await rootBundle.loadString('assets/complete_ncr_list.json');

    final List<dynamic> jsonList = json.decode(jsonString);
    final List<Places> placesList = jsonList.map((item) => Places.fromJson(item)).toList();

    return Places(name: '', category: '', latitude: 0.0, longitude: 0.0, city: City.CALOOCAN_CITY);
  }

  @override
  Future<List<Places>> getPlacesListOnce() async {
    final String jsonString = await rootBundle.loadString('assets/complete_ncr_list.json');

    final List<dynamic> jsonList = json.decode(jsonString);
    final List<Places> placesList = jsonList.map((item) => Places.fromJson(item)).toList();

    return placesList;
  }
}
