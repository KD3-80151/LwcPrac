/**
 * ----------------------------------------------------------------------------------------------------
 * Name: Sagar Kumar
 * Created Date: 27/06/2024
 * Last Modified Date: 
 * Purpose: to get the current date of birth
 * -----------------------------------------------------------------------------------------------------
 */


public class AgeConvert {
    public static void main() {
        
        Integer year = 1996;
        Integer month = 7;
        Integer day = 26;

        Date dob = Date.newInstance(year, month, day);
        Date currentDate = Date.today();

        Integer age = currentDate.year() - dob.year();
        if (currentDate.month() < dob.month() || 
           (currentDate.month() == dob.month() && currentDate.day() < dob.day())) {
            age--;
        }

        System.debug('Your age is: ' + age);
    }
}