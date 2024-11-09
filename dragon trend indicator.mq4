//+------------------------------------------------------------------+
//| Name:   Blue Special Dragon                                      |
//| Autor:  BlueX Indicadores                                        |
//| Link:   t.me/BlueXind                                            |
//+------------------------------------------------------------------+
#property indicator_buffers 18
#property indicator_chart_window
#property strict

//| user input
input int   maxBarsLoaded   = 500;
input int   calculumPeriod  = 50;
int         probability     = 6;
input color dojiColor       = clrGray;
input color neutralBullClr  = C'169,186,202';
input color neutralBearClr  = C'71,85,117';
input color dragonUpBullclr = Chartreuse;
input color dragonUpBearclr = DarkGreen;
input color dragonDnBullclr = C'64,0,0';
input color dragonDnBearclr = Red;
input color backgroundclr   = C'33,33,33';
input color foregroundclr   = Bisque;

//| global var
static datetime expiration = D'2024.12.05 00:00';

//| buffers
double upTrendLine[];
double dnTrendLine[];

double hi[];
double lo[];
double op_doji[];
double cl_doji[];

double bull_op[];
double bull_cl[];
double bear_op[];
double bear_cl[];

double bull_op_dragonUp[];
double bull_cl_dragonUp[];
double bear_op_dragonUp[];
double bear_cl_dragonUp[];

double bull_op_dragonDn[];
double bull_cl_dragonDn[];
double bear_op_dragonDn[];
double bear_cl_dragonDn[];

//+------------------------------------------------------------------+
//| main loop event                                                  |
//+------------------------------------------------------------------+
void MainLoop(int maxBar){
  int limit = ArraySize(Close);
  for(int i = 0; i <= limit; i++){
    if(i>= maxBar) continue;
    
    PlotLines(calculumPeriod, upTrendLine, dnTrendLine, i);
    
    PlaceCandles(probability, dragonUpBullclr, dragonDnBearclr, i);
  
  }
}

//+------------------------------------------------------------------+
//| per-tick event                                                   |
//+------------------------------------------------------------------+
int start(){
  if(Time[0] > expiration) return(0);
  ObjectsDeleteAll(0, -1, OBJ_TEXT);
  LineConstructor(upTrendLine, dnTrendLine);
  CandleBuffers();
  
  ColorsUpdate(
    neutralBullClr, 
    neutralBearClr, 
    dojiColor, 
    backgroundclr, 
    foregroundclr
  );
  
  MainLoop(maxBarsLoaded); 
  return(0);
}


//+------------------------------------------------------------------+
//| color update                                                     |
//+------------------------------------------------------------------+
void ColorsUpdate(
  color bullclr, 
  color bearclr, 
  color dojiclr, 
  color background, 
  color foreground
){
  ChartSetInteger(0, CHART_COLOR_CHART_UP, bullclr);
  ChartSetInteger(0, CHART_COLOR_CHART_DOWN, bearclr);
  ChartSetInteger(0, CHART_COLOR_CHART_LINE, dojiclr);
  ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, bearclr);
  ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, bullclr);
  ChartSetInteger(0, CHART_COLOR_BACKGROUND, background);
  ChartSetInteger(0, CHART_COLOR_FOREGROUND, foreground);
}

//+------------------------------------------------------------------+
//| probability - prob value                                         |
//+------------------------------------------------------------------+
double ProbabilityValue(int index, int period, int priceMode){
  double w1 = 4.23, w2 = 2.61, w3 = 1.61;
  double rsi1 = rsi(period*1, priceMode, index) * w1;
  double rsi2 = rsi(period*2, priceMode, index) * w2;
  double rsi3 = rsi(period*3, priceMode, index) * w3;
  
  double prob = (rsi1+rsi2+rsi3) / (w1+w2+w3);
  return(prob);
}

//+------------------------------------------------------------------+
//| probability - rsi                                                |
//+------------------------------------------------------------------+
double rsi(int period, int priceMode, int index){
  string  symbol    = Symbol();
  int     timeframe = PERIOD_CURRENT;
  
  double r = iRSI(symbol, timeframe, period, priceMode, index);
  return(r);
}

//+------------------------------------------------------------------+
//| probability - plot tags                                          |
//+------------------------------------------------------------------+
void PlotTags(
  int   probPeriod,
  bool  upTest, 
  bool  dnTest, 
  int   index,
  color bullClr,
  color bearClr
){
  int    zoom  = (int)ChartGetInteger(0, CHART_SCALE);
  int    fsize = 0;
  double atr   = iATR(NULL, PERIOD_CURRENT, 14, index);
  double pLo   = Low[index]  - atr/5;
  double pHi   = High[index] + atr/2;
  double prbHi = ProbabilityValue(index, PRICE_LOW, probPeriod);
  double prbLo = ProbabilityValue(index, PRICE_HIGH, probPeriod);
  string tagHi = DoubleToStr(MathRound(prbHi), 0);
  string tagLo = DoubleToStr(MathRound(prbLo), 0);
  
  switch(zoom){
    case 5: fsize = 13; break;
    case 4: fsize = 10; break;
    case 3: fsize = 8; break;
    case 2: fsize = 5; break;
    case 1: fsize = 2; break;
  }
  
  if(upTest){
    DrawTags(pHi, tagLo, fsize, bullClr, index);
  }
  
  if(dnTest){
    DrawTags(pLo, tagHi, fsize, bearClr, index);
  }
}

//+------------------------------------------------------------------+
//| probability - draw tags                                          |
//+------------------------------------------------------------------+
void DrawTags(
  double  price, 
  string  text,
  int     fsize, 
  color   clr, 
  int     index 
){
  datetime  time    = Time[index];
  string    objName = StringFormat("[%d] - tag", index);
  string    font    = "Noto Sans Mono";
  
  if(ObjectFind(0, objName) == -1){
    ObjectCreate(0, objName, OBJ_TEXT, 0, 0, 0);
    ObjectSetText(objName, text, fsize, font, clr);
    ObjectSet(objName, OBJPROP_SELECTABLE, false);
    ObjectSet(objName, OBJPROP_PRICE1, price);
    ObjectSet(objName, OBJPROP_TIME1, time);
  } else {
    ObjectSetText(objName, text, fsize, font, clr);
    ObjectSet(objName, OBJPROP_PRICE1, price);
    ObjectSet(objName, OBJPROP_TIME1, time); 
  }
}


//+------------------------------------------------------------------+
//| candles - buffers constructor                                    |
//+------------------------------------------------------------------+
void CreateCandle(int index, double &buffer[], int width, color clr){
  int draw  = DRAW_HISTOGRAM;
  int style = STYLE_SOLID;
  
  CreateBuffer(0, buffer, index, draw, style, width, clr);
}

//+------------------------------------------------------------------+
//| candles - candle buffers creation                                |
//+------------------------------------------------------------------+
void CandleBuffers(){
  int zoom  = (int)ChartGetInteger(0, CHART_SCALE);
  int width = 0;
  
  switch(zoom){
    case 5: width = 13; break;
    case 4: width = 06; break;
    case 3: width = 03; break;
    case 2: width = 02; break;
    case 1: width = 01; break;
  }

  CreateCandle(2, hi     , 1    , dojiColor);
  CreateCandle(3, lo     , 1    , dojiColor);
  CreateCandle(4, op_doji, width, dojiColor);
  CreateCandle(5, cl_doji, width, dojiColor);
  //---
  CreateCandle(6, bull_op, width, neutralBullClr);
  CreateCandle(7, bull_cl, width, neutralBullClr);
  CreateCandle(8, bear_op, width, neutralBearClr);
  CreateCandle(9, bear_cl, width, neutralBearClr);
  //---
  CreateCandle(10, bull_op_dragonUp, width, dragonUpBullclr);
  CreateCandle(11, bull_cl_dragonUp, width, dragonUpBullclr);
  CreateCandle(12, bear_op_dragonUp, width, dragonUpBearclr);
  CreateCandle(13, bear_cl_dragonUp, width, dragonUpBearclr);
  //---
  CreateCandle(14, bull_op_dragonDn, width, dragonDnBullclr);
  CreateCandle(15, bull_cl_dragonDn, width, dragonDnBullclr);
  CreateCandle(16, bear_op_dragonDn, width, dragonDnBearclr);
  CreateCandle(17, bear_cl_dragonDn, width, dragonDnBearclr);
}

//+------------------------------------------------------------------+
//| candles - place candles                                          |
//+------------------------------------------------------------------+
void PlaceCandles(
  int   probPeriod, 
  color bullClr, 
  color bearClr, 
  int   index
){
  double high   = High[index];
  double low    = Low[index];
  double open   = Open[index];
  double close  = Close[index];
  double empty  = EMPTY_VALUE;
  
  bool  doji      = close == open;
  bool  bull      = close >  open;
  bool  bear      = close <  open;
  bool  dragonUP  = upTrendLine[index] != EMPTY_VALUE;
  bool  dragonDN  = dnTrendLine[index] != EMPTY_VALUE;

  hi[index] = high;
  lo[index] = low;
  //---
  op_doji[index] = (doji) ? open:empty;
  cl_doji[index] = (doji) ? close:empty;
  //---
  bull_op[index] = (bull) ? open:empty;
  bull_cl[index] = (bull) ? close:empty;
  //---
  bear_op[index] = (bear) ? open:empty;
  bear_cl[index] = (bear) ? close:empty;
  //---
  bull_op_dragonUp[index] = (dragonUP && bull) ? open:empty;
  bull_cl_dragonUp[index] = (dragonUP && bull) ? close:empty;
  bear_op_dragonUp[index] = (dragonUP && bear) ? open:empty;
  bear_cl_dragonUp[index] = (dragonUP && bear) ? close:empty;
  //---
  bull_op_dragonDn[index] = (dragonDN && bull) ? open:empty;
  bull_cl_dragonDn[index] = (dragonDN && bull) ? close:empty;
  bear_op_dragonDn[index] = (dragonDN && bear) ? open:empty;
  bear_cl_dragonDn[index] = (dragonDN && bear) ? close:empty;
  
  PlotTags(
    probPeriod, 
    dragonUP, 
    dragonDN, 
    index, 
    bullClr, 
    bearClr
  );
}

//+------------------------------------------------------------------+
//| trend lines functions - buffers constructor                      |
//+------------------------------------------------------------------+
void LineConstructor(double &upLine[], double &dnLine[]) {
  int   draw    = DRAW_ARROW;
  int   style   = STYLE_SOLID;
  int   width   = 3;  
  color upColor = clrLime;
  color dnColor = clrRed;

  CreateBuffer(158, upLine, 0, draw, style, width, upColor);
  CreateBuffer(158, dnLine, 1, draw, style, width, dnColor);
}

//+------------------------------------------------------------------+
//| trend lines functions - plot lines                               |
//+------------------------------------------------------------------+
void PlotLines(
  int     clPeriod, 
  double  &upLine[], 
  double  &dnLine[],
  int     index
){
  int     index_c     = index+1;
  double  hiPrice     = High[index_c];
  double  loPrice     = Low[index_c];
  double  hiMa_c      = MaValue(clPeriod, PRICE_HIGH, index_c);
  double  loMa_c      = MaValue(clPeriod, PRICE_LOW,  index_c);
  bool    loLineCond  = loPrice > hiMa_c;
  bool    hiLineCond  = hiPrice < loMa_c;
  
  // line ploters 
  upLine[index] = (loLineCond) ? hiMa_c:EMPTY_VALUE;
  dnLine[index] = (hiLineCond) ? loMa_c:EMPTY_VALUE;
}

//+------------------------------------------------------------------+
//| trend lines functions - get ma values                            |
//+------------------------------------------------------------------+
double MaValue(int period, int priceMode, int index){
  string  symbol    = Symbol();
  int     timeframe = PERIOD_CURRENT;
  int     method    = MODE_EMA;
  
  double maValue = iMA(
    symbol, timeframe, period, 0, method, priceMode, index
  );
  
  return(maValue);
}


//+------------------------------------------------------------------+
//| utils function                                                   |
//+------------------------------------------------------------------+
void AdjustArray(int &array[], int size){
  ArraySetAsSeries(array, true);
  ArrayResize(array, size+1);
} 

void AdjustArray(double &array[], int size){
  ArraySetAsSeries(array, true);
  ArrayResize(array, size+1);
}

void CreateBuffer(
  int     arrowCode,
  double  &array[],
  int     index,
  int     draw,
  int     style,
  int     width,
  color   clr
){
  string bufferName = StringFormat(
    "buffer(%d)", index
  );
  ArrayInitialize(array, EMPTY_VALUE);
  SetIndexBuffer(index, array);
  SetIndexEmptyValue(index, EMPTY_VALUE);
  SetIndexLabel(index, bufferName);
  ArraySetAsSeries(array, true);
  
  // appearence
  SetIndexStyle(index, draw, style, width, clr);
  if(draw == DRAW_ARROW) SetIndexArrow(index, arrowCode);
}