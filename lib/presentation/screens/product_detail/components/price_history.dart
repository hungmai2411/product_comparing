import 'package:compare_product/data/models/price.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/utils/money_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceHistory extends StatelessWidget {
  final List<Price> prices;
  final int numOfDays;
  final int month;

  const PriceHistory({
    super.key,
    required this.numOfDays,
    required this.month,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    var maxOfY = findMaxPrice(prices);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Highest ', style: AppStyles.medium),
                Text(
                  maxOfY.toMoney,
                  style: AppStyles.medium.copyWith(color: AppColors.primary),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Lowest ', style: AppStyles.medium),
                Text(
                  findMinPrice(prices).toMoney,
                  style: AppStyles.medium.copyWith(color: AppColors.primary),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: false,
                    verticalInterval: 1,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFCFE1EB),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: bottomTitleWidgets,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        //interval: 1,
                        getTitlesWidget: leftTitleWidgets,
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(width: 1, color: Color(0xFFCFE1EB)),
                      bottom: BorderSide(width: 1, color: Color(0xFFCFE1EB)),
                    ),
                  ),
                  minX: 0,
                  maxX: numOfDays == 31 ? 7 : 6,
                  minY: 0,
                  maxY: 5,
                  lineBarsData: [
                    LineChartBarData(
                      dotData: FlDotData(
                        show: false,
                        getDotPainter: (p0, p1, p2, p3) {
                          return FlDotCirclePainter(
                            color: Colors.white,
                            radius: 2,
                            strokeWidth: 1,
                            strokeColor: const Color(0xFF2699E2),
                          );
                        },
                      ),
                      spots: createSpotsForMonthly(prices),
                      color: const Color(0xFF2699E2),
                      barWidth: 5,
                      isStrokeCapRound: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int findMinPrice(List<Price> pricesMonth) {
    if (pricesMonth.isEmpty) {
      return 0;
    }
    pricesMonth
        .sort((product1, product2) => product1.price.compareTo(product2.price));
    return pricesMonth[0].price;
  }

  int findMaxPrice(List<Price> pricesMonth) {
    if (pricesMonth.isEmpty) {
      return 0;
    }

    pricesMonth
        .sort((product1, product2) => product2.price.compareTo(product1.price));
    return pricesMonth[0].price;
  }

  List<FlSpot> createSpotsForMonthly(List<Price> pricesMonth) {
    List<FlSpot> spots = [];
    int dayTmp = 0;
    int i = 0;

    pricesMonth.sort((price1, price2) {
      DateTime dateTime1 = price1.date;
      DateTime dateTime2 = price2.date;

      return dateTime1.compareTo(dateTime2);
    });
    for (Price price in pricesMonth) {
      int dayCreated = price.date.day;

      double x = dayCreated / 5 - 0.2;

      if (dayTmp == dayCreated) {
        continue;
      }

      //List<int> values = [1, 5, 10, 15, 20, 25, 30];

      //if (values.contains(dayCreated)) {
      spots.add(FlSpot(x, price.price / 8000000));
      //}

      // if (i == 5) {
      //   break;
      // }
      dayTmp = dayCreated;
      i++;
    }

    return spots;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = AppStyles.regular.copyWith(
      fontSize: 12,
      color: AppColors.text,
    );
    late Widget text;

    if (numOfDays == 31) {
      List<String> days = [
        '$month/01',
        '$month/06',
        '$month/11',
        '$month/16',
        '$month/21',
        '$month/26',
        '$month/31',
        '',
      ];
      text = Text(days[value.toInt()], style: style);
    } else {
      List<String> days = [
        '$month/01',
        '$month/06',
        '$month/11',
        '$month/16',
        '$month/21',
        '$month/26',
        ''
      ];
      text = Text(days[value.toInt()], style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String result = '0';
    var max = findMaxPrice(prices);
    if (value == 0) {
      result = '0.0';
    } else {
      result = fomatMonney(value * max / 5);
    }
    return Text(
      result,
      style: AppStyles.regular.copyWith(
        fontSize: 12,
        color: AppColors.text,
      ),
    );
  }

  String fomatMonney(double money) {
    if (money > 1000000000) {
      return '${(money / 1000000000).toStringAsFixed(1)}B';
    } else if (money > 1000000) {
      return '${(money / 1000000).toStringAsFixed(1)}M';
    } else if (money > 1000) {
      return '${(money / 1000).toStringAsFixed(1)}K';
    } else {
      return money.toStringAsFixed(1);
    }
  }
}
