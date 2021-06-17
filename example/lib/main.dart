import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:k_chart/chart_style.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';

void main() => runApp(MyApp());

/// Example of an ordinal combo chart with two series rendered as stacked bars, and a
/// third rendered as a line.

class OrdinalComboBarLineChart extends StatelessWidget {
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';

  final simpleCurrencyFormatter =
  charts.BasicNumericTickFormatterSpec.fromNumberFormat(
    NumberFormat.compact(
    ),
  );

  final List<charts.Series<OrdinalSales, String>> seriesList;
  final bool animate;

  OrdinalComboBarLineChart({required this.seriesList, required this.animate});

  factory OrdinalComboBarLineChart.withSampleData() {
    return new OrdinalComboBarLineChart(
      seriesList: _createSampleData(),
      animate: false,
    );
  }

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;


    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      print(selectedDatum.first.datum.year);
    }

  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      behaviors: [
        // Add the sliding viewport behavior to have the viewport center on the
        // domain that is currently selected.
        charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        charts.PanAndZoomBehavior(),
        charts.InitialSelection(
          selectedDataConfig: [
            charts.SeriesDatumConfig<String>('Desktop', '2021'),
            charts.SeriesDatumConfig<String>('Tablet', '2021')
          ],
        ),
      ],
      // Set an initial viewport to demonstrate the sliding viewport behavior on
      // initial chart load.
      domainAxis: charts.OrdinalAxisSpec(
          viewport: charts.OrdinalViewport('2021', 7)),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 3,
        ),
        tickFormatterSpec: simpleCurrencyFormatter,
      ),
      secondaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0, label: '0 %'),
            charts.TickSpec<num>(50, label: '50 %'),
            charts.TickSpec<num>(100, label: '100 %'),
          ],
        ),
      ),

      // Configure the default renderer as a bar renderer.
      // defaultRenderer: new charts.BarRendererConfig(
      //     groupingType: charts.BarGroupingType.stacked),
      // Custom renderer configuration for the line series. This will be used for
      // any series that does not define a rendererIdKey.

      customSeriesRenderers: [
        new charts.LineRendererConfig(
          // ID used to link series to this renderer.
          customRendererId: 'customLine',
        ),
      ],
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5000),
      new OrdinalSales('2015', 2500000),
      new OrdinalSales('2016', 5000000),
      new OrdinalSales('2017', 5500000),
      new OrdinalSales('2018', 5500000),
      new OrdinalSales('2019', 3500000),
      new OrdinalSales('2020', 3500000),
      new OrdinalSales('2021', 2500000),
      new OrdinalSales('2022', 1500000),
    ];

    final tableSalesData = [
      new OrdinalSales('2014', 50000),
      new OrdinalSales('2015', 250000),
      new OrdinalSales('2016', 1000000),
      new OrdinalSales('2017', 250000),
      new OrdinalSales('2018', 350000),
      new OrdinalSales('2019', 1500000),
      new OrdinalSales('2020', 350000),
      new OrdinalSales('2021', 250000),
      new OrdinalSales('2022', 150000),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 20),
      new OrdinalSales('2015', 30),
      new OrdinalSales('2016', 35),
      new OrdinalSales('2017', 40),
      new OrdinalSales('2018', 30),
      new OrdinalSales('2019', 22),
      new OrdinalSales('2020', 15),
      new OrdinalSales('2021', 20),
      new OrdinalSales('2022', 30),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: desktopSalesData),
      new charts.Series<OrdinalSales, String>(
          id: 'Tablet',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: tableSalesData),
      new charts.Series<OrdinalSales, String>(
          id: 'Mobile ',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: mobileSalesData)
      // Configure our custom line renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine')
        ..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}


class SlidingViewportOnSelection extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  SlidingViewportOnSelection({required this.seriesList, required this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SlidingViewportOnSelection.withSampleData() {
    return new SlidingViewportOnSelection(
      seriesList: _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      behaviors: [
        // Add the sliding viewport behavior to have the viewport center on the
        // domain that is currently selected.
        new charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        new charts.PanAndZoomBehavior(),
      ],
      // Set an initial viewport to demonstrate the sliding viewport behavior on
      // initial chart load.
      domainAxis: new charts.OrdinalAxisSpec(
          viewport: new charts.OrdinalViewport('2018', 4)),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
      new OrdinalSales('2018', 33),
      new OrdinalSales('2019', 80),
      new OrdinalSales('2020', 21),
      new OrdinalSales('2021', 77),
      new OrdinalSales('2022', 8),
      new OrdinalSales('2023', 12),
      new OrdinalSales('2024', 42),
      new OrdinalSales('2025', 70),
      new OrdinalSales('2026', 77),
      new OrdinalSales('2027', 55),
      new OrdinalSales('2028', 19),
      new OrdinalSales('2029', 66),
      new OrdinalSales('2030', 27),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("myapp build!");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<KLineEntity>? datas;
  bool showLoading = true;
  MainState _mainState = MainState.MA;
  bool _volHidden = false;
  SecondaryState _secondaryState = SecondaryState.MACD;
  bool isLine = true;
  bool isChinese = true;
  List<DepthEntity>? _bids, _asks;
  bool isChangeUI = false;

  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();

  @override
  void initState() {
    super.initState();
    getData('1day');
    rootBundle.loadString('assets/depth.json').then((result) {
      final parseJson = json.decode(result);
      final tick = parseJson['tick'] as Map<String, dynamic>;
      final List<DepthEntity> bids = (tick['bids'] as List<dynamic>)
          .map<DepthEntity>(
              (item) => DepthEntity(item[0] as double, item[1] as double))
          .toList();
      final List<DepthEntity> asks = (tick['asks'] as List<dynamic>)
          .map<DepthEntity>(
              (item) => DepthEntity(item[0] as double, item[1] as double))
          .toList();
      initDepth(bids, asks);
    });
  }

  void initDepth(List<DepthEntity>? bids, List<DepthEntity>? asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    _bids = [];
    _asks = [];
    double amount = 0.0;
    bids.sort((left, right) => left.price.compareTo(right.price));
    //累加买入委托量
    bids.reversed.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _bids!.insert(0, item);
    });

    amount = 0.0;
    asks.sort((left, right) => left.price.compareTo(right.price));
    //累加卖出委托量
    asks.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _asks!.add(item);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 400,
            child: OrdinalComboBarLineChart.withSampleData(),
          ),
          // Stack(children: <Widget>[
          //   Container(
          //     height: 450,
          //     width: double.infinity,
          //     child: KChartWidget(
          //       datas,
          //       chartStyle,
          //       chartColors,
          //       isLine: isLine,
          //       mainState: MainState.NONE,
          //       volHidden: false,
          //       secondaryState: SecondaryState.NONE,
          //       fixedLength: 2,
          //       timeFormat: TimeFormat.YEAR_MONTH_DAY,
          //       isEnglish: isChinese,
          //       // maDayList: [1, 100, 1000],
          //     ),
          //   ),
          //   if (showLoading)
          //     Container(
          //         width: double.infinity,
          //         height: 450,
          //         alignment: Alignment.center,
          //         child: const CircularProgressIndicator()),
          // ]),
          // buildButtons(),
          // if (_bids != null && _asks != null)
          //   Container(
          //     height: 230,
          //     width: double.infinity,
          //     child: DepthChart(_bids!, _asks!, chartColors),
          //   )
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        button("Time Mode", onPressed: () => isLine = true),
        button("K Line Mode", onPressed: () => isLine = false),
        button("Line:MA", onPressed: () => _mainState = MainState.MA),
        button("Line:BOLL", onPressed: () => _mainState = MainState.BOLL),
        button("Hide Line", onPressed: () => _mainState = MainState.NONE),
        button("Secondary Chart:MACD", onPressed: () => _secondaryState = SecondaryState.MACD),
        button("Secondary Chart:KDJ", onPressed: () => _secondaryState = SecondaryState.KDJ),
        button("Secondary Chart:RSI", onPressed: () => _secondaryState = SecondaryState.RSI),
        button("Secondary Chart:WR", onPressed: () => _secondaryState = SecondaryState.WR),
        button("Secondary Chart:CCI", onPressed: () => _secondaryState = SecondaryState.CCI),
        button("Secondary Chart:Hide", onPressed: () => _secondaryState = SecondaryState.NONE),
        button(_volHidden ? "Show Vol" : "Hide Vol",
            onPressed: () => _volHidden = !_volHidden),
        button("Change Language", onPressed: () => isChinese = !isChinese),
        button("Customize UI", onPressed: () {
          setState(() {
            this.isChangeUI = !this.isChangeUI;
            if(this.isChangeUI) {
              chartColors.selectBorderColor = Colors.red;
              chartColors.selectFillColor = Colors.red;
              chartColors.lineFillColor = Colors.grey;
              chartColors.kLineColor = Colors.yellow;
            } else {
              chartColors.selectBorderColor = Color(0xff6C7A86);
              chartColors.selectFillColor = Color(0xff0D1722);
              chartColors.lineFillColor = Color(0x554C86CD);
              chartColors.kLineColor = Color(0xff4C86CD);
              chartColors.nowPriceColor = Colors.white;
            }
          });
        }),
      ],
    );
  }

  Widget button(String text, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
          setState(() {});
        }
      },
      child: Text(text),
      style: TextButton.styleFrom(
        primary: Colors.white,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void getData(String period) {
    final Future<String> future = getIPAddress(period);
    future.then((String result) {
      final Map parseJson = json.decode(result) as Map<dynamic, dynamic>;
      final list = parseJson['data'] as List<dynamic>;
      datas = list
          .map((item) => KLineEntity.fromJson(item as Map<String, dynamic>))
          .toList()
          .reversed
          .toList()
          .cast<KLineEntity>();
      DataUtil.calculate(datas!);
      showLoading = false;
      setState(() {});
    }).catchError((_) {
      showLoading = false;
      setState(() {});
      print('### datas error $_');
    });
  }

  //获取火币数据，需要翻墙
  Future<String> getIPAddress(String? period) async {
    var url =
        'https://api.huobi.br.com/market/history/kline?period=${period ?? '1day'}&size=300&symbol=btcusdt';
    late String result;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      result = response.body;
    } else {
      print('Failed getting IP address');
    }
    return result;
  }
}
