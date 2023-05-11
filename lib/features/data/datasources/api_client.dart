import 'package:cinema_app/features/data/datasources/storage.dart';
import 'package:cinema_app/features/data/models/comment.dart';
import 'package:cinema_app/features/data/models/movie.dart';
import 'package:cinema_app/features/data/models/user.dart';
import 'package:cinema_app/features/data/models/ticket_list.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../models/session.dart';

class ApiClient {
  final Dio _dio = Dio();
  final accessToken = Storage.getAccessToken();

  Future<void> sendOTP(String phoneNumber) async {
    await _dio.post(
      'https://fs-mt.qwerty123.tech/api/auth/otp',
      data: {'phoneNumber': phoneNumber},
      options: Options(headers: {'Accept-Language': 'uk'}),
    );
  }

  Future<Response> authenticate(String phoneNumber, String otp) async {
    return _dio.post(
      'https://fs-mt.qwerty123.tech/api/auth/login',
      data: {'phoneNumber': phoneNumber, 'otp': otp},
      options: Options(headers: {'Accept-Language': 'uk'}),
    );
  }

  Future<User> getCurrentUser(String accessToken) async {
    final response = await _dio.get(
      'https://fs-mt.qwerty123.tech/api/user',
      options: Options(headers: {
        'Accept-Language': 'uk',
        'Authorization': 'Bearer $accessToken',
      }),
    );

    return User.fromJson(response.data['data']);
  }

  Future<TicketList> getTickets(String accessToken) async {
    final response = await _dio.get(
      'https://fs-mt.qwerty123.tech/api/user/tickets',
      options: Options(headers: {
        'Accept-Language': 'uk',
        'Authorization': 'Bearer $accessToken',
      }),
    );
    return TicketList.fromJson(response.data);
  }

  Future<List<Movie>> getMovies(String accessToken) async {
    final response = await _dio.get(
      'https://fs-mt.qwerty123.tech/api/movies?date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
      options: Options(headers: {
        'Accept-Language': 'uk',
        'Authorization': 'Bearer $accessToken',
      }),
    );

    return (response.data['data'] as List)
        .map((movieJson) => Movie.fromJson(movieJson))
        .toList();
  }

  Future<User> updateCurrentUser(String accessToken, String newName) async {
    final response = await _dio.post(
      'https://fs-mt.qwerty123.tech/api/user',
      data: {'name': newName},
      options: Options(headers: {
        'Accept-Language': 'uk',
        'Authorization': 'Bearer $accessToken',
      }),
    );

    return User.fromJson(response.data['data']);
  }

  Future<List<Session>> getMovieSessions(
      String accessToken, int movieId, String date) async {
    final response = await _dio.get(
      'https://fs-mt.qwerty123.tech/api/movies/sessions?movieId=$movieId&date=$date',
      options: Options(headers: {
        'Accept-Language': 'uk',
        'Authorization': 'Bearer $accessToken',
      }),
    );

    if (response.statusCode == 200) {
      final json = response.data;
      if (json['success']) {
        return (json['data'] as List)
            .map((sessionJson) => Session.fromJson(sessionJson))
            .toList();
      } else {
        throw Exception('Error fetching movie sessions: ${json['error']}');
      }
    } else {
      throw Exception(
          'Failed to load movie sessions with status code ${response.statusCode}');
    }
  }

  Future<Session> getSessionById(String accessToken, int sessionId) async {
    try {
      final response = await _dio.get(
        'https://fs-mt.qwerty123.tech/api/movies/sessions/$sessionId',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final data = response.data;
      if (data['success']) {
        return Session.fromJson(data['data']);
      } else {
        throw Exception('Failed to load session');
      }
    } catch (e) {
      throw Exception('Failed to load session: $e');
    }
  }

  Future<bool> bookSeats(
      String accessToken, List<int> seatIds, int sessionId) async {
    final response = await _dio.post(
      'https://fs-mt.qwerty123.tech/api/movies/book',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {
        'seats': seatIds,
        'sessionId': sessionId,
      },
    );

    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Failed to book seats');
    }
  }

  Future<bool> buyTickets(
      String accessToken,
      List<int> seatIds,
      int sessionId,
      String email,
      String cardNumber,
      String expirationDate,
      String cvv) async {
    final response = await _dio.post(
      'https://fs-mt.qwerty123.tech/api/movies/buy',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {
        'seats': seatIds,
        'sessionId': sessionId,
        'email': email,
        'cardNumber': cardNumber,
        'expirationDate': expirationDate,
        'cvv': cvv,
      },
    );

    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Failed to buy tickets');
    }
  }

  Future<List<Comment>> getMovieComments(
      String accessToken, int movieId) async {

    try {
      final response = await _dio.get(
        'https://fs-mt.qwerty123.tech/api/movies/comments?movieId=$movieId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data']
            .map<Comment>((item) => Comment.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } on DioError catch (e) {
      // Handle error
      throw Exception('Failed to load comments: $e');
    }
  }
  Future<bool> postMovieComment(
      String accessToken, int movieId, String content, int rating) async {

    try {
      final response = await _dio.post(
        'https://fs-mt.qwerty123.tech/api/movies/comments',
        data: {
          "content": content,
          "rating": rating,
          "movieId": movieId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to post comment');
      }
    } on DioError catch (e) {
      // Handle error
      throw Exception('Failed to post comment: $e');
    }
  }

  Future<bool> deleteMovieComment(String accessToken, int commentId) async {
    try {
      final response = await _dio.delete(
        'https://fs-mt.qwerty123.tech/api/movies/comments/$commentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to delete comment');
      }
    } on DioError catch (e) {
      // Handle error
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query, String accessToken) async{
    final response = await _dio.get(
        'https://fs-mt.qwerty123.tech/api/movies?query=${query}',
      options: Options(headers: {
        'Accept-Language': 'uk',
        'Authorization': 'Bearer $accessToken',
      }),
    );
    if (response.statusCode == 200) {
      final json = response.data;
      if (json['success']) {
        return (json['data'] as List)
            .map((sessionJson) => Movie.fromJson(sessionJson))
            .toList();
      } else {
        throw Exception('Error fetching movie sessions: ${json['error']}');
      }
    } else {
      throw Exception(
          'Failed to load movie sessions with status code ${response.statusCode}');
    }
  }
  Future<bool> checkToken(String accessToken) async {
    final response = await _dio.get(
      'https://fs-mt.qwerty123.tech/api/user',
      options: Options(headers: {
        'Accept-Language': 'uk',
        'Authorization': 'Bearer $accessToken',
      }),
    );
    if(response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }
  }
}