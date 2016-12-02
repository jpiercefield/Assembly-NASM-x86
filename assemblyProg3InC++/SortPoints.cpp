//Sort array based on X's closeness to x_comp (Recursive)
#include <iostream>
using namespace std;
void sort(float arr[40], float x_comp, int arraySize, int currentTimes)
{
   int index;
   float difference;
   float temp = 0;
   for(int i=currentTimes; i<arraySize; i++)
   {
      temp = arr[i] - x_comp;
      if(temp < 0)
      {
         temp = temp * -1;
      }
      if(i == currentTimes)
      {
         difference = temp;
         index = i;
      } else if(temp < difference) {
      
         difference = temp;
         index = i;
      }
      i++;
   }
   temp = arr[currentTimes];
   arr[currentTimes] = arr[index];
   arr[index] = temp;
   
   temp = arr[currentTimes+1];
   arr[currentTimes+1] = arr[index+1];
   arr[index+1] = temp;
   
   currentTimes = currentTimes + 2;
   if(currentTimes == arraySize)
   {
   
   } else {
      sort(arr, x_comp, arraySize, currentTimes);
   }
}

void outputArray(float arr[40], int arraySize)
{
   cout << endl;
   for(int i = 0; i < arraySize; i++)
   {
      cout << arr[i] << endl;
   }
}