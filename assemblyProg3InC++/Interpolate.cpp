#include <iostream>
#include "compute_bs.h"
#include "Interpolate.h"

using namespace std;

void Inter(float arr[40], float xCoord, int arraySize, int degreeInt, float exStack[8])
{
   float result = 0;
   baseCase(exStack, arr);
   if(degreeInt == 0)
   {
      cout << "The result: " << arr[1] << endl;
   } else {
      result += exStack[0];
      exStack[0] = 0;
      int WhichBofN = 1;
      while(WhichBofN <= degreeInt)
      {
         cBsRecur(degreeInt, WhichBofN, 1, 0, exStack, arr);
         result += EvalPolynomialProc(arr, xCoord, WhichBofN, exStack);
         WhichBofN++;
         for(int i = 0; i < degreeInt; i++)  //Pop rest of stack
         {
            exStack[i] = 0;
         }
      }
      cout << "The result: " << result << endl;       
   }  
}
