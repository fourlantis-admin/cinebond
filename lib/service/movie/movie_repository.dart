import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/service/network_manager.dart';
import 'package:flutter/material.dart';


//********************************************************************************************************* */
//SERVICES FOR MOVIES
//********************************************************************************************************* */

class MovieRepository {
  NetworkManager networkManager = NetworkManager();
  BuildContext context;

  MovieRepository({required this.context});
   Future<List<MovieResp>> getMovies(BuildContext context,{String pageNumber = "0",String filter = ""}
   ) async {
  try {
    final response = await networkManager.get(
      context,
      "api/movies?pageNumber=${pageNumber}&pageSize=15&sortedField=name&sort=ASC&filters[name]=${filter}",
    );
    final List list = response;
    print(list);
    return list
        .map((e) => MovieResp.fromJson(e))
        .toList();
  } catch (e) {
    rethrow;
  }
}

Future<MovieResp> getMovieDetail(BuildContext context,
  String movieId ) async {
  try {
    final response = await networkManager.get(
      context,
      "api/movies/${movieId}"
    );
    print(response);
    return MovieResp.fromJson(response);
      
  } catch (e) {
    rethrow;
  }
}

Future<MovieResp> setFavoriteMovie(BuildContext context,
  String movieId ) async {
  try {
    final response = await networkManager.post(
      context,
      movieId,
      "api/profile/favorite-movies"
    );
    print(response);
    return MovieResp.fromJson(response);
      
  } catch (e) {
    rethrow;
  }
}

Future<MovieResp> removeFavoriteMovie(BuildContext context,
  String movieId ) async {
  try {
    final response = await networkManager.post(
      context,
      movieId,
      "api/profile/favorite-movies"
    );
    print(response);
    return MovieResp.fromJson(response);
      
  } catch (e) {
    rethrow;
  }
}

}