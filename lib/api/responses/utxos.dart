import 'package:arbor/api/responses/coin_response.dart';

class UtxosResponse {
  List<CoinResponse> records;

  UtxosResponse({
    required this.records,
  });

  UtxosResponse.fromJson(List list)
      : records = list.map((value) => CoinResponse.fromJson(value)).toList();
}
