import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:service_app/models/chart.dart';

class PieChart extends StatefulWidget {
  const PieChart({Key key}) : super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  //List<ChartData> _chartData;
  TooltipBehavior _tooltipBehavior;
  bool isInit = true;

  // @override
  // void initState() {
  //   Provider.of<Customer>(context, listen: false)
  //       .dashboardChart()
  //       .then((value) {
  //     _chartData;
  //   });
  //   // _chartData = getChartData();
  //   _tooltipBehavior = TooltipBehavior(enable: true);
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false).dashboardChart();
      Provider.of<JobProvider>(context, listen: false).workerdashboardChart();
    }
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).currentUser;
    final _chartData = Provider.of<Customer>(context).dashboardData;
    final _workerchartData =
        Provider.of<JobProvider>(context).workerdashboardData;
    if (user.isCustomer) {
      return SafeArea(
          child: Scaffold(
        body: SfCircularChart(
          tooltipBehavior: _tooltipBehavior,
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          series: <CircularSeries>[
            DoughnutSeries<ChartData, String>(
              dataSource: _chartData,
              xValueMapper: (ChartData data, _) => data.status,
              yValueMapper: (ChartData data, _) => data.total,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              enableTooltip: true,
            )
          ],
        ),
      ));
    } else {
      return SafeArea(
          child: Scaffold(
        body: SfCircularChart(
          tooltipBehavior: _tooltipBehavior,
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          series: <CircularSeries>[
            DoughnutSeries<ChartData, String>(
              dataSource: _workerchartData,
              xValueMapper: (ChartData data, _) => data.status,
              yValueMapper: (ChartData data, _) => data.total,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              enableTooltip: true,
            )
          ],
        ),
      ));
    }
  }

//   List<ChartData> getChartData() {
//     final List<ChartData> chartData = [
//       ChartData('Oceania', 1600),
//       ChartData('Africa', 2490),
//       ChartData('S America', 2900),
//       ChartData('Europe', 23050),
//       ChartData('Asia', 2000)
//     ];
//     return chartData;
//   }
// }

  // getChartData() {
  //   Provider.of<Customer>(context, listen: false)
  //       .dashboardChart()
  //       .then((value) {});
  // }

// class ChartData {
//   ChartData(this.continent, this.gdp);
//   final String continent;
//   final int gdp;
// }
}
