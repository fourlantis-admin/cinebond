import 'package:cinebond/models/movie/actors_resp.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/models/user/generic_by_id_req.dart';
import 'package:cinebond/service/network_manager.dart';
import 'package:flutter/material.dart';

//********************************************************************************************************* */
//SERVICES FOR MOVIES
//********************************************************************************************************* */

class MovieRepository {
  NetworkManager networkManager = NetworkManager();
  MovieRepository();

  Future<List<MovieResp>> getMovies(
    BuildContext context, {
    String pageNumber = "0",
    String filter = "",
  }) async {
    try {
      final response = await networkManager.get(
        "api/movies?pageNumber=${pageNumber}&pageSize=15&sortedField=name&sort=ASC&filters[name]=${filter}",
      );
      final List list = response;
      print(list);
      return list.map((e) => MovieResp.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieResp> getMovieDetail(BuildContext context, String movieId) async {
    try {
      final response = await networkManager.get("api/movies/${movieId}");
      print(response);
      return MovieResp.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieResp>> setFavoriteMovie(GenericByIdReq movie) async {
    try {
      final response = await networkManager.post(
        movie.toMapMovieId(),
        "api/profile/favorite-movies",
      );
      List list = response;
      return list.map((e) => MovieResp.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieResp> removeFavoriteMovie(
    BuildContext context,
    GenericByIdReq movieId,
  ) async {
    try {
      final response = await networkManager.post(
        movieId.toMapMovieId(),
        "api/profile/favorite-movies",
      );
      print(response);
      return MovieResp.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActorsResp>> getActors(
    BuildContext context, {
    String pageNumber = "0",
    String filter = "",
  }) async {
    try {
      final response = await networkManager.get(
        "api/actors?pageNumber=${pageNumber}&pageSize=15&sortedField=name&sort=DESC",
      );
      final List list = response;
      print(list);
      return list.map((e) => ActorsResp.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
  Future<List<MovieResp>> getActorById(
  {
    String? id,
  }) async {
    try {
      final response = await networkManager.get(
        "api/actors/${id}"
      );
      final List list = response;
      print(list);
      return list.map((e) => MovieResp.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
