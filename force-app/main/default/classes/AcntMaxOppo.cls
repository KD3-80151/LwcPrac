/**
 * ----------------------------------------------------------------------------------------------------
 * Name: Sagar Kumar
 * Created Date: 27/06/2024
 * Last Modified Date: 
 * Purpose: to calculate the total amount of all opportunities related to each account and 
 * then determine which account has the highest total opportunity amount
 * -----------------------------------------------------------------------------------------------------
 */

public class AcntMaxOppo {
    public static void getAccountMaxOppo(){
        List<Account> acct = [select Id, Name, (select Amount from Opportunities where Amount!=null) from Account];
        
        Account highest= null;
        Decimal totalAmount= 0;
        
        for(Account acc: acct){
            Decimal totalAmt =0;
            for(Opportunity opp: acc.Opportunities){
                totalAmt += opp.Amount;
            }
            if(totalAmt > totalAmount){
                totalAmount = totalAmt;
                highest = acc;
            }            
        }
         	
        System.debug('Highest Account Name is ' + highest.Name 
                     + ' and total amount is ' + totalAmount);
        
        
        
    }
    
}