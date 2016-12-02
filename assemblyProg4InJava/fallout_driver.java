import java.io.*;
import java.util.*;

public class fallout_driver
{
    public static void main(String[] args)
    {
        String fileName = "fallout.txt";
        String array[] = new String[20];
        String newArray[] = new String[20];
        int sizeOfArray = 0;
        int sizeOfNewArray = 0;
        int indexPass = 0;
        int matches = 0;
        try{
            Scanner sc = new Scanner(new File(fileName));
            String temp = "";
            boolean end = false;
            while(end == false)
            {
                temp = sc.nextLine();
                System.out.println("Enter a string: " + temp);
                if(temp.charAt(0) == 'x')
                {
                    end = true;
                } else {
                    array[sizeOfArray] = temp;
                    sizeOfArray++;
                }
            }

            System.out.println("\n" + "The number of string entered is: " + Integer.toString(sizeOfArray) + "\n");

            for(int i = 0; i < sizeOfArray; i++)
            {
                System.out.println(array[i]);
            }

            temp = sc.nextLine();
            indexPass = Integer.parseInt(temp);
            System.out.println("Enter the index for the test password (1-based): " + temp);
            
            temp = sc.nextLine();
            matches = Integer.parseInt(temp);
            System.out.println("Enter the number of exact character matches: " + temp);
            
            for(int i=0;i < sizeOfArray; i++)
            {
                int count = 0;
                String tempStr = array[indexPass-1];
                String compStr = array[i];
                for(int k = 0; k < array[0].length(); k++)
                {
                    char tempChar = tempStr.charAt(k);
                    char compChar = compStr.charAt(k);
                    if(tempChar == compChar)
                    {
                        count++;
                    }
                }
                
                if(count == matches)
                {
                    newArray[sizeOfNewArray] = compStr;
                    sizeOfNewArray++;
                }
            }
            System.out.println("\n");            
            for(int i=0; i<sizeOfNewArray; i++)
            {
                System.out.println(newArray[i]);
            }
            
            temp = sc.nextLine();
            indexPass = Integer.parseInt(temp);
            System.out.println("Enter the index for the test password (1-based): " + temp);
            
            temp = sc.nextLine();
            matches = Integer.parseInt(temp);
            System.out.println("Enter the number of exact character matches: " + temp);
            sizeOfArray = 0;
            for(int i=0;i < sizeOfNewArray; i++)
            {
                int count = 0;
                String tempStr = newArray[indexPass-1];
                String compStr = newArray[i];
                for(int k = 0; k < array[0].length(); k++)
                {
                    char tempChar = tempStr.charAt(k);
                    char compChar = compStr.charAt(k);
                    if(tempChar == compChar)
                    {
                        count++;
                    }
                }
                
                if(count == matches)
                {
                    array[sizeOfArray] = compStr;
                }
            }
            
            System.out.println("\n");
            System.out.println(array[0]);
            
            sc.close();
        } catch (IOException e){
            System.out.println("End of file");
        }

    }
}