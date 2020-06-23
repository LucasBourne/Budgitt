import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

import '../home_screen.dart';
import 'main_page.dart';
import '../sign_in.dart';

class TrendsScreen extends StatefulWidget 
{
  TrendsScreen();

  factory TrendsScreen.withSampleData() 
  {
    return new TrendsScreen();
  }

  @override
  TrendsScreenState createState() => TrendsScreenState();
}

/// Sample ordinal data type.
class OrdinalSpend
{
  final String title;
  final double spend;

  OrdinalSpend(this.title, this.spend);
}



class TrendsScreenState extends State<TrendsScreen>
{
  Widget chart()
  {
    return new charts.BarChart(
      _createSampleData(),
      behaviors: [
        new charts.ChartTitle(
          "Spend (£)",
          behaviorPosition: charts.BehaviorPosition.start,
          titleStyleSpec: new charts.TextStyleSpec(
            fontFamily: 'Karla',
            fontSize: 12, // size in Pts.
            color: charts.Color.fromHex(code: "#BA68C8"),
          ),
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
      ],
      animate: true,
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
            fontFamily: 'Karla',
            fontSize: 12, // size in Pts.
            color: charts.Color.fromHex(code: "#BA68C8"),
          ),
          // Change the line colors to match text color.
          lineStyle: new charts.LineStyleSpec(
            color: charts.Color.fromHex(code: "#BA68C8"),
          )
        )
      ),

      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
            fontFamily: 'Karla',
            fontSize: 12, // size in Pts.
            color: charts.Color.fromHex(code: "#BA68C8"),
          ),
          // Change the line colors to match text color.
          lineStyle: new charts.LineStyleSpec(
            color: charts.Color.fromHex(code: "#BA68C8"),
          )
        )
      ),

      barGroupingType: charts.BarGroupingType.stacked,
      customSeriesRenderers: 
      [
        new charts.BarTargetLineRendererConfig<String>(
          // ID used to link series to this renderer.
          customRendererId: 'customTargetLine',
          groupingType: charts.BarGroupingType.stacked,
        )
      ]
    );
  }

  List<charts.Series<OrdinalSpend, String>> _createSampleData()
  {
    final weeklyData = [
      new OrdinalSpend('Weekly Total', values["wSpend"].toDouble()),
    ];

    final totalData = [
      new OrdinalSpend('Overall Total', (values["wSpend"] + values["tSpend"]).toDouble()),
    ];
    
    final weeklyTargetLineData = [
      new OrdinalSpend('Weekly Total', double.parse(getRemainingPerWeek())),
    ];

    final totalTargetLineData = [
      new OrdinalSpend('Overall Total', values["loan"].toDouble()),
    ];

    return [
      new charts.Series<OrdinalSpend, String>(
        id: 'weeklySpend',
        seriesColor: charts.Color.fromHex(code: "#BA68C8"),
        domainFn: (OrdinalSpend spend, _) => spend.title,
        measureFn: (OrdinalSpend spend, _) => spend.spend,
        data: weeklyData,
      ),
      new charts.Series<OrdinalSpend, String>(
        id: 'totalSpend',
        seriesColor: charts.Color.fromHex(code: "#BA68C8"),
        domainFn: (OrdinalSpend spend, _) => spend.title,
        measureFn: (OrdinalSpend spend, _) => spend.spend,
        data: totalData,
      ),

      new charts.Series<OrdinalSpend, String>(
        id: 'weeklyTarget',
        colorFn: (_, __) => charts.Color.fromHex(code: "#e53935"),
        domainFn: (OrdinalSpend spend, _) => spend.title,
        measureFn: (OrdinalSpend spend, _) => spend.spend,
        data: weeklyTargetLineData,
      )
      // Configure our custom bar target renderer for this series.
      ..setAttribute(charts.rendererIdKey, 'customTargetLine'),
      new charts.Series<OrdinalSpend, String>(
        id: 'totalTarget',
        colorFn: (_, __) => charts.Color.fromHex(code: "#e53935"),
        domainFn: (OrdinalSpend spend, _) => spend.title,
        measureFn: (OrdinalSpend spend, _) => spend.spend,
        data: totalTargetLineData,
      )
      // Configure our custom bar target renderer for this series.
      ..setAttribute(charts.rendererIdKey, 'customTargetLine'),
    ];
  }
  
  String getRemainingPerWeek()
  {
    DateTime loanStart;
    DateTime loanEnd;
    DateTime durationStart;
    int loanDuration;
    double remainingLoan;
    double remainingPerWeek;
    if(values["iDat"] != null && values["oDat"] != null)
    {
      loanStart = DateTime.parse(values["iDat"]);
      loanEnd = DateTime.parse(values["oDat"]);
      if(DateTime.now().isBefore(loanStart))
      {
        loanActive = false;
        return "Your loan has not yet been paid.";
      }
      else if(DateTime.now().isAfter(loanEnd))
      {
        loanActive = false;
        return "You've reached your end date. Well done!";
      }
      else
      {
        loanActive = true;
        durationStart = DateTime.now();
        loanDuration = loanEnd.difference(durationStart).inDays + 1;

        if(int.parse(getDateCode(DateTime.now())) > int.parse(values["dCode"]))
        {
          double oldTotal = values["tSpend"].toDouble();
          dbRef.child(userID).update({
            "tSpend" : oldTotal + values["wSpend"],
            "wSpend" : 0.0,
            "dCode" : getDateCode(DateTime.now())
          });
          setState(() {
            readData();
          });
        }
        else
        {
          if(values["loan"] != null && values["tSpend"] != null)
          {
            remainingLoan = double.parse(values["loan"].toString()) - double.parse(values["tSpend"].toString());
            int loanDurationInWeeks = (loanDuration / 7).ceil();
            remainingPerWeek = double.parse((remainingLoan / loanDurationInWeeks).toString());
            return remainingPerWeek.toString();
          }        
        }
      }
    }
    return "0";
  }

  @override
  void initState()
  {
    super.initState();
    if (values != null)
    {
      values.clear();
    }
    readData();
  }

  void readData()
  {
    dbRef.child(userID).once().then((DataSnapshot ds)
    {
      values = ds.value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    if (loanActive && values != null)
    {
      if (values["wSpend"] != null && values["tSpend"] != null && values["loan"] != null)
      {
        return Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Center(
            child: chart(),
          ),
        ); 
      }
    }
    return Center(
      child: Text(
        "Set up account in Settings",
        style: GoogleFonts.karla(
          color: accentColour,
        ),
      ),
    );
  }
}