#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

int main() {
   string line;
   string outLine;
   int n;
   int m;
   ifstream myfile ("vankins_in.txt");
   int counter = 0;
   int temp = 0;
   vector< vector<int> > inputGrid;
   vector< vector<int> > outputGrid;
   if(myfile.is_open())
   {
      getline(myfile,line);
      n = std::stoi(line);
      getline(myfile,line);
      m = std::stoi(line);
      inputGrid.resize(n, std::vector<int>(m, 0));
      outputGrid.resize(n, std::vector<int>(m, 0));
      for(int i = 0; i < m; i++)
      {
         outLine = "";
         for(int j = 0; j < n; j++)
         {
            getline(myfile,line);
            inputGrid[i][j] = std::stoi(line);
            outLine += std::to_string(inputGrid[i][j]) + " ";
         }
         cout << outLine << '\n';
      }      
      myfile.close();
   } else {
      cout << "Unable to open file";
   }

   for(int i = m-1; i >= 0; i--) //for all of the squares
   {
        for(int j = n-1; j >= 0; j--) //for all of the squares starting at very right/bottom
        {
            //Find the largest number for each individual square inputGrid[i][j]
            u
            if(i == m-1 && j == n-1)
            {
               //outputGrid[i][j] += inputGrid[i][j];
            } else if(i == m-1 && j!= n-1) {
               if(outputGrid[i][j+1] >= 0)
               {
                  outputGrid[i][j] += outputGrid[i][j+1];
               }
            } else if(i != m-1 && j == n-1) {
               if(outputGrid[i+1][j] >= 0)
               {
                  outputGrid[i][j] += outputGrid[i+1][j];
               }
            } else if(outputGrid[i][j+1] >= outputGrid[i+1][j]) {
               outputGrid[i][j] += outputGrid[i][j+1];
            }  else {
               outputGrid[i][j] += outputGrid[i+1][j];
            } 
        }        
   }
   cout << endl;
   for(int i = 0; i < m; i++)
   {
      outLine = "";
      for(int j = 0; j < n; j++)
      {
         outLine += std::to_string(outputGrid[i][j]) + " ";
      }
      cout << outLine << '\n';
   }
   cout << endl;
   outLine = "";
   int count = 0;
   bool done = false;
   while(done != true)
   {
      if(counter == m-1 && temp == n-1) {
         outLine += "d";
         done = true;
      } else if(counter == m-1 && temp != n-1) {
         if(outputGrid[counter][temp+1] >= 0)
         {
            outLine += "d";
            temp++;
         } else {
            outLine += "d";
            done = true;
         }
      } else if(counter != m-1 && temp == n-1) {
         if(outputGrid[counter+1][temp] >= 0)
         {
            outLine += "r";
            counter++;
         } else {
            outLine += "r";
            done = true;
         }
      } else if(outputGrid[counter+1][temp] >= outputGrid[counter][temp+1]) {
         outLine += "d";
         counter++;
      } else {
         outLine += "r";
         temp++;
      }
   } 
   
   cout << outLine << endl; 
   return 0;
}