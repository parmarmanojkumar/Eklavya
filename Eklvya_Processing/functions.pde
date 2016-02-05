float[] StringParseFloat (String[] dataFrame, int startpoistion) 
// Function to extract data from string and convert to float
{
  float[] returnframe = new float[3]; //new reurn frame
  int start = startpoistion;  //start position from extraction
    for (int i = 0; i < 3; i = i+1)
    {
      int idx = i + start; 
      returnframe[i] = float(dataFrame[idx]);
    }
  return returnframe;
}

float sumFloatArray (float[] arrayFloat, int size)
// Function to add array sum)
{
  float aSum = 0;
  for (int i = 0; i < size ; i = i+1)
    {
      aSum += arrayFloat[i];
    }
  
  return aSum;
}