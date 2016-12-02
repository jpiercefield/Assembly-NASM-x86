
import java.io.*;
import java.util.*;

public class PlaneLineIntersection
{
    public static void main(String[] args)
    {
        String fileName = "plane_line.txt";
        String P[][] = new String[5][3]; // PA = 0, PB = 1, PC = 2, P1 = 3, P2 = 4 : x = 0, y = 2, z = 3
        int Pint[][] = new int[5][3];

        //Read Input
        P = readInput(fileName, P); // read Input to array

        //Turn String into Integer
        Pint = StringToInt(P, Pint);

        int crossProduct[] = new int[3]; //aXb

        crossProduct = findCrossProduct(crossProduct, Pint); //Find aXb = n-vector
        
        
        int nProduct = 0;
        nProduct = findNProduct(nProduct, crossProduct, Pint);
        
        int dProduct = 0;
        dProduct = findDProduct(dProduct, crossProduct, Pint);
        System.out.println(dProduct);
        float finalNumbers[] = new float[3];
        finalNumbers = findFinalNumbers(finalNumbers, nProduct, dProduct, Pint);

        System.out.println( "( " + finalNumbers[0] + ", " + finalNumbers[1] + ", " + finalNumbers[2] + " )");


    }

    private static String[][] readInput (String fileName, String P[][])
    {
        try{
            Scanner sc = new Scanner(new File(fileName));
            while (sc.hasNextLine()) 
            {
                for(int i = 0; i <= 4; i++)
                {
                    P[i][0] = sc.nextLine();
                    System.out.println("Enter x-coordinate: " + P[i][0]);
                    P[i][1] = sc.nextLine();
                    System.out.println("Enter y-coordinate: " + P[i][1]);
                    P[i][2] = sc.nextLine();
                    System.out.println("Enter z-coordinate: " + P[i][2]);
                }
            }
            sc.close();
            return(P);

        } catch (IOException e){
            System.out.println("End of file");
        }
        return(P);
    }

    private static int[][] StringToInt(String P[][], int Pint[][])
    {
        for(int i = 0; i <= 4; i++)
        {
            for(int k = 0; k <= 2; k++)
            {
                if(P[i][k].charAt(0) == '-') //Negative Number
                {
                    String temp = "";
                    int tempInt;
                    for(int j = 1; j <= 5; j++)
                    {
                        temp += P[i][k].charAt(j);
                    }
                    tempInt = Integer.parseInt(temp);
                    Pint[i][k] = tempInt * -1;
                } else {
                    Pint[i][k] = Integer.parseInt(P[i][k]);
                }
            }
        }
        return(Pint);
    }

    private static int[] findCrossProduct(int crossProduct[], int Pint[][] )
    {
        int PbMinusPa[] = new int[3];
        int PcMinusPa[] = new int[3];

        PbMinusPa[0] = Pint[1][0] - Pint[0][0];
        PbMinusPa[1] = Pint[1][1] - Pint[0][1];
        PbMinusPa[2] = Pint[1][2] - Pint[0][2];

        PcMinusPa[0] = Pint[2][0] - Pint[0][0];
        PcMinusPa[1] = Pint[2][1] - Pint[0][1];
        PcMinusPa[2] = Pint[2][2] - Pint[0][2];

        crossProduct[0] = PbMinusPa[1] * PcMinusPa[2] - PbMinusPa[2] * PcMinusPa[1];
        crossProduct[1] = PbMinusPa[2] * PcMinusPa[0] - PbMinusPa[0] * PcMinusPa[2];
        crossProduct[2] = PbMinusPa[0] * PcMinusPa[1] - PbMinusPa[1] * PcMinusPa[0];

        return(crossProduct);
    }
    
    private static int findNProduct(int nProduct, int crossProduct[], int Pint[][] )
    {
        nProduct += (Pint[2][0] - Pint[3][0]) * crossProduct[0];
        nProduct += (Pint[2][1] - Pint[3][1]) * crossProduct[1];
        nProduct += (Pint[2][2] - Pint[3][2]) * crossProduct[2];
        
        return(nProduct);
    }
    
    private static int findDProduct(int dProduct, int crossProduct[], int Pint[][] )
    {
        dProduct += (Pint[4][0] - Pint[3][0]) * crossProduct[0];
        dProduct += (Pint[4][1] - Pint[3][1]) * crossProduct[1];
        dProduct += (Pint[4][2] - Pint[3][2]) * crossProduct[2];
        
        return(dProduct);
    }
    
    private static float[] findFinalNumbers(float finalNumbers[], int nProduct, int dProduct, int Pint[][] )
    {
        finalNumbers[0] = (float)((dProduct * Pint[3][0]) - (nProduct * Pint[3][0]) + (nProduct * Pint[4][0])) / dProduct;
        finalNumbers[1] = (float)((dProduct * Pint[3][1]) - (nProduct * Pint[3][1]) + (nProduct * Pint[4][1])) / dProduct;
        finalNumbers[2] = (float)((dProduct * Pint[3][2]) - (nProduct * Pint[3][2]) + (nProduct * Pint[4][2])) / dProduct;
        
        return(finalNumbers);
    }
    
    
}
