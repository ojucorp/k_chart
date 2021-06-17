import 'package:flutter/material.dart' show Color;

class ChartColors {

  Color kLineColor = Color(0xff4C86CD);
  Color lineFillColor = Color(0x554C86CD);
  Color ma5Color = Color(0xffC9B885);
  Color ma10Color = Color(0xff6CB0A6);
  Color ma30Color = Color(0xff9979C6);
  Color upColor = Color(0xff4DAA90);
  Color dnColor = Color(0xffC15466);
  Color volColor = Color(0xff4729AE);

  Color macdColor = Color(0xff4729AE);
  Color difColor = Color(0xffC9B885);
  Color deaColor = Color(0xff6CB0A6);

  Color kColor = Color(0xffC9B885);
  Color dColor = Color(0xff6CB0A6);
  Color jColor = Color(0xff9979C6);
  Color rsiColor = Color(0xffC9B885);

  Color defaultTextColor = Color(0xff60738E);

  Color nowPriceColor = Color(0xffC9B885);

  Color depthBuyColor = Color(0xff60A893);
  Color depthSellColor = Color(0xffC15866);
  Color selectBorderColor = Color(0xff6C7A86);

  Color selectFillColor = Color(0xff0D1722);

  Color gridColor = Color(0xff4c5c74);

  Color infoWindowNormalColor = Color(0xffffffff);
  Color infoWindowTitleColor = Color(0xffffffff);
  Color infoWindowUpColor = Color(0xff00ff00);
  Color infoWindowDnColor = Color(0xffff0000);

  Color hCrossColor = Color(0xffffffff);
  Color vCrossColor = Color(0x1Effffff);
  Color crossTextColor = Color(0xffffffff);

  Color maxColor = Color(0xffffffff);
  Color minColor = Color(0xffffffff);

  Color getMAColor(int index) {
    Color maColor = ma5Color;
    switch (index % 3) {
      case 0:
        maColor = ma5Color;
        break;
      case 1:
        maColor = ma10Color;
        break;
      case 2:
        maColor = ma30Color;
        break;
    }
    return maColor;
  }
}

class ChartStyle {
  double pointWidth = 11.0;

  double candleWidth = 8.5;

  double candleLineWidth = 1.5;

  double candleRadius = 1.5;

  double volWidth = 8.5;

  double volHeightRatio = 0.15;

  double macdWidth = 3.0;

  double vCrossWidth = 8.5;

  double hCrossWidth = 0.5;
}
