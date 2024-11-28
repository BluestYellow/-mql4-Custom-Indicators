//+==================================================================+
//| projeto visual operations                                        |
//| blueXind && Petra                                                |
//| link: https://t.me/blueXind                                      |
//+==================================================================+
#property indicator_buffers 2
#property indicator_chart_window
#property strict

// enumerators
enum dgn{dgnUP, dgnDN, sleep};
enum bType{line, histo, arrow};

// global values
const int bbm = 300;

// arrays
double buffer1[];
double buffer2[];

//+==================================================================+
//| per-tick event                                                   |
//+==================================================================+
int start(){  
  PainelControl();
  CreateBuffer(line, 0, buffer1);
  CreateBuffer(line, 1, buffer2);

  int limit = ArraySize(Close);
  for(int i = 0; i <= limit; i++){
    if(i >= bbm) continue;
  }
  
  return(Bars);
}


//+==================================================================+
//| painel management                                                |
//+==================================================================+
void PainelControl(){
  // variables
  string trend = GetCurrentTrend();
  dgn fastDgn = GetDragonState(0, 09);
  dgn slowDgn = GetDragonState(0, 50);
  int oPos = 14; // original X position
  
  ObjectsDeleteAll(0, -1, OBJ_RECTANGLE_LABEL);
  ObjectsDeleteAll(0, -1, OBJ_LABEL);
  
  CreateBox(10, 20, 110, 60);
  CreateText(trend, clrWhiteSmoke, (oPos+10), 20, 1.002);
}

//+==================================================================+
//| get current trend                                                |
//+==================================================================+
string GetCurrentTrend(){
  dgn fastState[3]; ArraySetAsSeries(fastState, true);
  dgn slowState[3]; ArraySetAsSeries(slowState, true);
  int upCounter = 0;
  int dnCounter = 0;
  int vCandle = ArraySize(fastState)-1;// verification candle number
  string upTrend = "[Up Trend]";
  string dnTrend = "[Dn Trend]";
  string noTrend = "[No Trend]";
  
  for(int i = 0; i <= vCandle; i++){
    fastState[i] = GetDragonState(i, 09);
    slowState[i] = GetDragonState(i, 09);
  }
  
  for(int j = 0; j <= vCandle; j++){
    if(fastState[j] == dgnUP && slowState[j] == dgnUP) upCounter++;
    if(fastState[j] == dgnDN && slowState[j] == dgnDN) dnCounter++;
  }
  
  // return logical block
  ; if      (upCounter > MathRound(vCandle*0.75)) { return(upTrend);
  } else if (dnCounter > MathRound(vCandle*0.75)) { return(dnTrend);
  } else                                          { return(noTrend);
  }
}

//+==================================================================+
//| get dgn state                                                    |
//+==================================================================+
dgn GetDragonState(int index, int period=50){
  double hiMa = MovingAverage(PRICE_HIGH , index, period);
  double loMa = MovingAverage(PRICE_LOW  , index, period);
  double clMA = MovingAverage(PRICE_CLOSE, index, 1);
  
  if (clMA > hiMa)  {return(dgnUP);}
  if (clMA < loMa)  {return(dgnDN);}
  else              {return(sleep);}  
}

//+==================================================================+
//| get ancor point                                                  |
//+==================================================================+
double GetAncorPoint(dgn state, int index){
  double point;
  double op = Open[index];
  double cl = Close[index];
  bool bullCandle = cl > op;
  bool bearCandle = cl < op;
  
  if      (state == dgnUP && bullCandle) {point = op;}
  else if (state == dgnUP && bearCandle) {point = cl;}
  else if (state == dgnDN && bullCandle) {point = cl;}
  else if (state == dgnDN && bearCandle) {point = op;}
  else                                   {point = cl;}
  
  return(point);
}

//+==================================================================+
//| get moving average value                                         |
//+==================================================================+
double MovingAverage(int mode, int index, int per){
  string sym = Symbol();
  int tmf = Period();
  int mtd = MODE_EMA;
  double ma = iMA(sym, tmf, per, 0, mtd, mode ,index);
  
  return(ma);
}

//+==================================================================+
//| create box function                                              |
//+==================================================================+
string GetUniqueObjName(double rNum){
  double randomizer = Open[1] * rNum * 1.421343532;
  string name = "obj:"+DoubleToStr(randomizer, _Digits);
  
  return(name);
}

//+==================================================================+
//| create box function                                              |
//+==================================================================+
void CreateBox(
  int distX,
  int distY,
  int sizeX,
  int sizeY,
  bool plain = false,
  double multi = 1.02,
  int corner = 0
){
  string objName = GetUniqueObjName(multi);
  
  bool object = ObjectCreate(
    0, objName, OBJ_RECTANGLE_LABEL, 0, 0, 0
  );
  
  color foreground = (
    (color)ChartGetInteger(0, CHART_COLOR_FOREGROUND)
  );
  
  color background = (
    (color)ChartGetInteger(0, CHART_COLOR_GRID)
  );
  
  if(object){
    ObjectSet(objName, OBJPROP_XDISTANCE, distX);
    ObjectSet(objName, OBJPROP_YDISTANCE, distY);
    ObjectSet(objName, OBJPROP_CORNER, corner);
    ObjectSet(objName, OBJPROP_XSIZE, sizeX);
    ObjectSet(objName, OBJPROP_YSIZE, sizeY);
    ObjectSet(objName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSet(objName, OBJPROP_BGCOLOR, background);
    ObjectSet(objName, OBJPROP_BACK, false);
    ObjectSet(objName, OBJPROP_WIDTH, 2);
  }
  
  if (plain){
    ObjectSet(objName, OBJPROP_COLOR, background);
  } else {
    ObjectSet(objName, OBJPROP_COLOR, foreground);
  }
}

//+==================================================================+
//| create label text function                                       |
//+==================================================================+
void CreateText(
  string text, 
  color clr,
  int distX,
  int distY,
  double multi = 1.04,
  int fontSize = 11,
  int corner = 0
){
  string objName = GetUniqueObjName(multi);
  
  bool object = (
    ObjectCreate(0, objName, OBJ_LABEL, 0, 0, 0)
  );
  
  if(object){
    ObjectSetText(objName, text, fontSize, "Lexend", clr);
    ObjectSet(objName, OBJPROP_CORNER, corner);
    ObjectSet(objName, OBJPROP_XDISTANCE, distX);
    ObjectSet(objName, OBJPROP_YDISTANCE, distY);
    ObjectSet(objName, OBJPROP_BACK, false);
  }
}

//+==================================================================+
//| Create buffers function                                          |
//| > desc: Only for Histo, Arrow and Line                           |
//+==================================================================+
void CreateBuffer(
  bType type, 
  int index,
  double &array[],
  int width=2,
  int style=STYLE_SOLID,
  color clr=clrRed,
  int arCode=0
){
  int draw;
  string name = StringFormat("(%d) Buffer", index);
  
  if(type == line){
    draw = DRAW_LINE;
  } else if (type == histo) {
    draw = DRAW_HISTOGRAM;
  } else {
    draw = DRAW_ARROW;
    SetIndexArrow(index, arCode);
  }
  
  ArrayInitialize(array, EMPTY_VALUE);
  ArraySetAsSeries(array, true);
  SetIndexBuffer(index, array);
  SetIndexLabel(index, name);
  SetIndexStyle(index, draw, style, width, clr);
  
}