class Crypto {
  String? symbol;
  String? name;
  String? image;
  dynamic currentPrice;
  double? totalVolume;
  double? priceChangePercentage24h;
  double? high_24h;
  double? low_24h;


  Crypto(
      {
      this.symbol,
      this.name,
      this.image,
      this.currentPrice,
      this.totalVolume,
      this.priceChangePercentage24h,
      this.high_24h,
      this.low_24h,});

  Crypto.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    name = json['name'];
    image = json['image'];
    currentPrice = json['current_price'];
    totalVolume = json['total_volume'].toDouble();
    priceChangePercentage24h = json['price_change_percentage_24h'];
    high_24h = json['high_24h'].toDouble();
    low_24h = json['low_24h'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['symbol'] = symbol;
    data['name'] = name;
    data['image'] = image;
    data['current_price'] = currentPrice;
    data['total_volume'] = totalVolume;
    data['price_change_percentage_24h'] = priceChangePercentage24h;
    data['high_24h'] =high_24h;
    data['low_24h'] =low_24h;
    return data;
  }

  static List<Crypto> coinsFromsApi(dynamic snapshot){
   final List<Crypto> coins = [];

    for(int i=0; i<100; i++){
      Crypto coin = Crypto.fromJson(snapshot[i]);
      print(coin);
      coins.add(coin);
    }

    return coins;
  }
}