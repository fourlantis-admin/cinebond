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
   Future<List<MovieResp>> getMovies(BuildContext context,
   ) async {
  try {
    final response = await networkManager.getBase(
      context,
      "3/movie/top_rated?api_key=6ae6730e286206d3f389407fd34b9509",
    );
    final List list = response["results"];
    print(list);
    return list
        .map((e) => MovieResp.fromJson(e))
        .toList();
  } catch (e) {
    rethrow;
  }
}

 Future<List<MovieResp>> searchMovies(BuildContext context,
  String searchQuery ) async {
  try {
    final response = await networkManager.getBase(
      context,
      "3/search/movie?api_key=6ae6730e286206d3f389407fd34b9509&query=${searchQuery}"
    );
    final List list = response["results"];
    print(list);
    return list
        .map((e) => MovieResp.fromJson(e))
        .toList();
  } catch (e) {
    rethrow;
  }
}
Future<MovieResp> getMovieDetail(BuildContext context,
  String movie_id ) async {
  try {
    final response = await networkManager.getBase(
      context,
      "3/movie/${movie_id}?api_key=6ae6730e286206d3f389407fd34b9509"
    );
    print(response);
    return MovieResp.fromJson(response);
      
  } catch (e) {
    rethrow;
  }
}

}