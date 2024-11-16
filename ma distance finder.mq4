#property indicator_buffers 3
#property indicator_separate_window
#property strict
#include <utils.mqh>

int       mmb       = 50;
input int maPeriod  = 50;
input int minus     = 3;
double    filter    = 0;
static int count;

double histo[];
double upArrow[];
double dnArrow[];

//+------------------------------------------------------------------+
//| per tick function                                                |
//+------------------------------------------------------------------+
int start(){
  string  sr    = "blue indicator";
  int     Hdraw  = DRAW_HISTOGRAM;
  int     Adraw  = DRAW_ARROW;
  int     style = STYLE_SOLID;
  int     zoom  = (int)ChartGetInteger(0, CHART_SCALE);
  int     width = 0;
  color   clr   = clrGray;
  color   upClr = clrLime;
  color   dnClr = clrRed;
  
  switch(zoom){
    case 5: width  = 13; break;
    case 4: width  = 6;  break;
    case 3: width  = 3;  break;
    case 2: width  = 2;  break;
    case 1: width  = 1;  break;
    default: width = 0;  break;
  }
  
  CreateFunction(sr, 0, histo,   Hdraw, style, width, clr);
  CreateFunction(sr, 1, upArrow, Adraw, style, 12, upClr, 158);
  CreateFunction(sr, 2, dnArrow, Adraw, style, 12, dnClr, 158);
  
  double  tempArray[]; DynamicArrays(tempArray, mmb);  
  int     limit = ArraySize(Close);
  
  // get max value
  for(int j = 0; j<= limit; j++){
    if(j>= mmb) continue;
    
    double  ma     = MovingAverage(maPeriod, j);
    double  cl     = Close[j];
    double  hi     = High[j];
    double  lo     = Low[j];
    double  dis    = (ma > cl) ? (ma - lo):(hi - ma);
    tempArray[j]  = dis;
  }
  
  
  for(int i = 0; i<= limit; i++){
    if(i>= mmb) continue;
    
    int     maxIndx = ArrayMaximum(tempArray);
    double  ma      = MovingAverage(maPeriod, i);
    double  cl      = Close[i];
    double  op      = Open[i];
    double  dist    = tempArray[i];
    double  max     = tempArray[maxIndx];
    double  min     = 0;
    double  norm    = ((dist - min)/(max - min))*100;
    bool    upTrend = cl < ma;
    bool    dnTrend = cl > ma;
    bool    trigger = norm > filter;
    bool    bullBar = cl > op;
    bool    bearBar = cl < op;

    bool callCondition = (
      upTrend &&
      trigger &&
      count >= mmb - 1
    );
    
    bool puttCondition = (
      dnTrend &&
      trigger &&
      count >= mmb - 1
    );
    
    histo[i]    = norm;
    
    upArrow[i]  = (callCondition) ? norm:EMPTY_VALUE;
    dnArrow[i]  = (puttCondition) ? norm:EMPTY_VALUE;
    
    if(histo[i] > filter) {
      filter = histo[i] - minus;
    }
    count++;
    
  }

  return(Bars);
}


//+------------------------------------------------------------------+
//| get moving average                                               |
//+------------------------------------------------------------------+
double MovingAverage(int period, int shift){
  string pair = Symbol();
  int    tf   = Period();
  int    mode = MODE_EMA;
  int    src  = PRICE_CLOSE;
  
  double data = iMA(pair, tf, period, 0, mode, src, shift);
  return(data);
}
