class CustData {
  final int conversion;
  final Map<String, int> chartData;
  final int chosenInterval;

  CustData(this.conversion, this.chartData, this.chosenInterval);

  factory CustData.fromJson(Map<String, dynamic> data, int chosenInterval) =>
      new CustData(
          data['conversion'],
          data['chartData'],
          chosenInterval);
}
