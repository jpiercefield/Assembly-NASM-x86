//MaxBn = Max
//CurN = Cur or N
//Indx = Index
//Times = Times - TempCounter 4 Amount of Computations (Times Computed Count)
//exStk = StackArr or Stack
//arr = Sorted Array

//computeBsRecursion
#include <iostream>
#include <string>
using namespace std;

void cBsRecur(int MaxBn, int CurN, int Indx, int Times, float exStk[8], float arr[40])
{
   float temp = 0;
   if(Times == 0)
   {
      //= (F(Xn+1) - F(Xn)) / (Xn+1 - Xn)
      temp = (arr[Indx + 2] - arr[Indx]); // = (F(Xn+1) - F(Xn)) -Y's
      temp = temp / (arr[Indx + 1] - arr[Indx - 1]); // /(Xn+1 - Xn) -X's
   }
   if(MaxBn == 1) {
      exStk[0] = temp; //End Here
      return;
   } else  {
      if(CurN == 1)
      {
         exStk[0] = temp; //Don't forget Recur
         cBsRecur(MaxBn, CurN+1, Indx+2, 0, exStk, arr);
      } else { //heere
         int spot = CurN - 1;
         spot = spot - Times;
         if(spot == CurN - 1)
         {
            exStk[spot] = temp;
            return;
         } else {
            temp = (exStk[spot+1] - exStk[spot]);
            temp = temp/(arr[CurN*2] - arr[spot*2]);
            exStk[spot] = temp;
         }
         if(CurN == Times)
         {
            if(CurN == MaxBn)
            {
               //END Do Nothing
               exStk[0] = temp;
               return;
            } else {
               cBsRecur(MaxBn, CurN+1, Indx + 2, 0, exStk, arr);
            }
         } else {
            cBsRecur(MaxBn, CurN, Indx + 2, Times+1, exStk, arr);
         }
      }
   
   } 
}

void baseCase(float exStack[8], float arr[40])
{
   exStack[0] = arr[1]; //Push F[Xo] onto Bs-Stack (Bottom of Stack)
}

float EvalPolynomialProc(float arr[40], float xCoord, int WhichBofN, float exStack[8])
{
   float temp = exStack[0];
   int index = 0;
   for(int i = 0; i < WhichBofN; i++)
   {
      temp = temp * (xCoord - arr[index]);
      index += 2;
   }
   return temp;
}
