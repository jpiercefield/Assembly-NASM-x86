#include <iostream>
#include <fstream>
#include <string>

using namespace std;

#include "SortPoints.h"
#include "Interpolate.h"


int main() {
   string line;
   string outLine;
   
   float xCoord = 0.0;
   int degreeInt = 0;
   float temp = 0.0;
   float arr[40] = { }; //Float Array, Stores up to 20 (x,y) Points. 
                        // (arr[0] = x & arr[1] = y)                  
   int arraySize = 0;
   ifstream myfile ("points.txt");

   if(myfile.is_open())
   {
      cout << "Enter the x-coordinate of the desired interpolated y." << endl;
      getline(myfile,line);
      xCoord = std::stof(line);
      cout << xCoord << endl;
      cout << "Enter the degree of the interpolating polynomial." << endl;
      getline(myfile,line);
      degreeInt = std::stoi(line);
      cout << degreeInt << endl;
      cout << "You may enter up to 20 points, one at a time." << endl;
      cout << "Input q to quit." << endl;
      for(int i = 0; i < 40; i++)
      {
         getline(myfile,line);
         if(line[0] == 'q')
         {
            cout << "q" << endl;
            break;
         } else {
            temp = std::stof(line);
            cout << temp << endl;
            arr[i] = temp;
            arraySize++;
         }
      }  
      myfile.close();       
   } else {
      cout << "Unable to open file";
   }
   float exStack[8] = { };
   sort(arr, xCoord, arraySize, 0);  //Sort Array   (SortPoints.cpp)
   outputArray(arr, arraySize);      //Output Array (SortPoints.cpp)
   Inter(arr, xCoord, arraySize, degreeInt, exStack);
   

   return 0;
}