#property indicator_buffers 3
#property indicator_separate_window
#property strict

// global var
input int inputMaxLookBack  = 450;
input int inputMaPeriod     = 14;

// arrays
double upHistogram[];
double dnHistogram[];
double maLine[];
double divData[];

//+------------------------------------------------------------------+
//| init event                                                       |
//+------------------------------------------------------------------+
int init(){
  AdjustArray(divData, inputMaxLookBack);
  return(0);
}

//+------------------------------------------------------------------+
//| pertick event                                                    |
//+------------------------------------------------------------------+
int start(){
    BufferConfig(0, upHistogram, clrLime);
    BufferConfig(1, dnHistogram, clrRed);
    BufferConfig(2, maLine, clrYellow, DRAW_LINE);
    MainLoop(inputMaxLookBack, inputMaPeriod);
    return(0);
}

//+------------------------------------------------------------------+
//| loop event                                                       |
//+------------------------------------------------------------------+
void MainLoop(int maxBar, int maPeriod){
  int limit = ArraySize(Close);
  int maMethod = MODE_EMA;
  for(int i = 0; i <= limit; i++){
    if(i >= maxBar) continue;
    double fastMA   = GetMaValue(maPeriod*1, maMethod, i);
    double slowMA   = GetMaValue(maPeriod*2, maMethod, i);
    double signalMA = GetMaValue(maPeriod*3, maMethod, i);
    GetDivValue(fastMA, slowMA, divData, i);
    if(divData[i] != EMPTY_VALUE){
      PlotMaHistogram(upHistogram, dnHistogram, i);
    }
    
  }
}

//+------------------------------------------------------------------+
//| buffer config                                                    |
//+------------------------------------------------------------------+
void BufferConfig(
  int     index, 
  double  &array[], 
  color   clr, 
  int     draw = DRAW_HISTOGRAM
){
  int style = STYLE_SOLID;
  int zoom  = (int)ChartGetInteger(0, CHART_SCALE);
  int width = 1;
  
  if(draw != DRAW_LINE){
    switch(zoom){
      case 5: width = 13; break;
      case 4: width = 06; break;
      case 3: width = 03; break;
      case 2: width = 02; break;
      case 1: width = 01; break;
    }
  }

  CreateBuffer(0, array, index, draw, style, width, clr);
}

//+------------------------------------------------------------------+
//| ma - get div value                                               |
//+------------------------------------------------------------------+
void GetDivValue(
  double  fastMA, 
  double  slowMA, 
  double  &array[],
  int     index
){
  double div = (fastMA / slowMA) - 1;
  array[index] = div;
}

//+------------------------------------------------------------------+
//| ma - plot ma histograms                                          |
//+------------------------------------------------------------------+
void PlotMaHistogram(
  double  &upHisto[], 
  double  &dnHisto[],
  int     index
){
  double div = divData[index];
  double empty  = EMPTY_VALUE;

  if(div > 0){
    upHisto[index] = div;
  } else {
    upHisto[index] = empty;
  }

  if(div < 0){
    dnHisto[index] = div;
  } else {
    dnHisto[index] = empty;
  }
}


//+------------------------------------------------------------------+
//| ma - get ma value                                                |
//+------------------------------------------------------------------+
double GetMaValue(int period, int maMethod, int index){
  // ma parameters
  string  symbol    = Symbol();
  int     timeframe = PERIOD_CURRENT;
  int     priceType = PRICE_CLOSE;
  
  double  ma = iMA(
    symbol, timeframe, period, 0, maMethod, priceType, index 
  );

  return(ma);
}
  
//+------------------------------------------------------------------+
//| utils function                                                   |
//+------------------------------------------------------------------+
void AdjustArray(int &array[], int size){
  ArrayInitialize(array, EMPTY_VALUE);
  ArraySetAsSeries(array, true);
  ArrayResize(array, size+1);
} 

void AdjustArray(double &array[], int size){
  ArrayInitialize(array, EMPTY_VALUE);
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