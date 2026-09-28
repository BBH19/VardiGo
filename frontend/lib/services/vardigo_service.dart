// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:frontend/models/candidate.dart';
import 'package:frontend/models/offer.dart';
import 'package:frontend/utils/global_params.dart';

class VardigoService {
  static String? token;


  static Future<bool> login(String role) async {
    try {
      var body = json.encode({
        'role': role,
      });

      var url = Uri.parse(
        '${GlobalParams.baseUrl}auth/login',
      );

      var res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      // print('LOGIN STATUS: ${res.statusCode}');
      // print('LOGIN BODY: ${res.body}');

      if (res.statusCode == 200) {
        var result = json.decode(res.body);

        token = result['data']['token'];

        // print('TOKEN: $token');

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

static Future<Map<String, dynamic>> getCandidates({
  String? tab,
  String sort = 'recommended',
}) async {
  String url =
      '${GlobalParams.baseUrl}candidates?sort=$sort';

  if (tab != null) {
    url += '&tab=$tab';
  }

  // print('GET CANDIDATES TOKEN = $token');
  // print('GET CANDIDATES URL = $url');

  final res = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );


  if (res.statusCode == 200) {
    final result = json.decode(res.body);

    final responseData = result['data'];

    final candidatesData = responseData['candidates'] as List;

    final candidates = candidatesData
        .map<Candidate>(
          (json) => Candidate.fromJson(json),
        )
        .toList();

    return {
      'candidates': candidates,
      'totalPerfect': responseData['totalPerfect'] ?? 0,
      'totalSimilar': responseData['totalSimilar'] ?? 0,
      'pendingCountLabel':
          responseData['pendingCountLabel'] ?? 0,
    };
  }

  return {
    'candidates': <Candidate>[],
    'totalPerfect': 0,
    'totalSimilar': 0,
    'pendingCountLabel': 0,
  };
}

  static Future<bool> createOffers(
    List<String> workerIds,
  ) async {

    var body = json.encode({
      'workerIds': workerIds,
    });

    var res = await http.post(
      Uri.parse('${GlobalParams.baseUrl}offers'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<List<Offer>> getOffers({
    String status = 'pending',
  }) async {

    var url = '${GlobalParams.baseUrl}offers?status=$status';

    print('GET OFFERS URL = $url');

    var res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('GET OFFERS STATUS = ${res.statusCode}');
    print('GET OFFERS BODY = ${res.body}');

    if (res.statusCode == 200) {
      var result = json.decode(res.body);

      var data = result['data']['offers'] as List;

      return data
          .map<Offer>(
            (json) => Offer.fromJson(json),
          )
          .toList();
    }

    return [];
  }

  static Future<bool> acceptOffer(String id) async {
    print('ACCEPT OFFER TOKEN = $token');
    print('ACCEPT OFFER ID = $id');

    var res = await http.post(
      Uri.parse('${GlobalParams.baseUrl}offers/$id/accept'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('ACCEPT OFFER STATUS = ${res.statusCode}');
    print('ACCEPT OFFER BODY = ${res.body}');

    return res.statusCode == 200;
  }


  static Future<bool> rejectOffer(String id) async {
    print('REJECT OFFER TOKEN = $token');
    print('REJECT OFFER ID = $id');

    var res = await http.post(
      Uri.parse('${GlobalParams.baseUrl}offers/$id/reject'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('REJECT OFFER STATUS = ${res.statusCode}');
    print('REJECT OFFER BODY = ${res.body}');

    return res.statusCode == 200;
  }
}