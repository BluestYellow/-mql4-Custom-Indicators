#property library

//+------------------------------------------------------------------+
//| dynamic arrays                                                   |
//+------------------------------------------------------------------+
void DynamicArrays(int &array[], int size, bool modeSeries = false){
  ArrayInitialize(array, (int)empty);
  if(modeSeries) ArraySetAsSeries(array, true);
  ArrayResize(array, size+1);
}

// dynamic array polimorfism
void DynamicArrays(double &array[], int size, bool modeSeries = false){
  ArrayInitialize(array, empty);
  if(modeSeries) ArraySetAsSeries(array, true);
  ArrayResize(array, size+1);
}

//+------------------------------------------------------------------+
//| create buffer                                                    |
//+------------------------------------------------------------------+
void CreateFunction(
  string  series, 
  int     index, 
  double  &array[],
  int     type,
  int     style,
  int     width,
  color   clr
){
  string bufferName = StringFormat(
    "buffer | %s | %d", series, index
  );
  
  // configure buffers display
  ArrayInitialize(array, empty);
  ArraySetAsSeries(array, true);
  SetIndexBuffer(index, array);
  SetIndexEmptyValue(index, empty);
  SetIndexLabel(index, bufferName);
  SetIndexStyle(index, type, style, width, clr);
}

