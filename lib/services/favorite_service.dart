import 'dart:convert';
import 'package:doan/common/UriAPI.dart';
import 'package:doan/models/FavoriteDTOInsert.dart';
import 'package:http/http.dart' as http;

class FavoriteService {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<http.Response> getFavoriteByIdUser(int acID) {
    return http.get(Uri.parse('${UriApi.api}/Favorite/User/$acID'),
        headers: headers);
  }

  Future<http.Response> deleteFavorite(int favoriteId){
    return http.delete(Uri.parse('${UriApi.api}/Favorite/$favoriteId'));
  }

  Future<http.Response> insertFavorite(FavoriteDTOInsert favorite) {
    return http.post(
      Uri.parse('${UriApi.api}/Favorite'),
      headers: headers,
      body: json.encode(favorite.toJson()),
    );
  }

}
