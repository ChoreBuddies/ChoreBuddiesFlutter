import 'dart:convert';

import 'package:chorebuddies_flutter/api/http_util.dart';
import 'package:chorebuddies_flutter/chores/models/chore_overview.dart';

class ChoreService {
  final HttpUtil _httpUtil;
  ChoreService({required HttpUtil httpUtil}) : _httpUtil = httpUtil;

  Future<List<ChoreOverview>> getChores() async {
    final response = await _httpUtil.get('/chores');

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList
        .map((json) => ChoreOverview.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
