import java.sql.*;
import java.util.ArrayList;

public class Lab_8
{
    static final String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
    static final String DB_URL= "jdbc:oracle:thin:@localhost:1521:xe";
    static final String USER="dbms_200042118";
    static final String PASS="cse4308";
    public static void main (String args[])
    {
        Connection conn=null;
        Statement stmt=null;
        try
        {
            Class.forName(JDBC_DRIVER);
            System.out.println("Connecting to database");
            conn=DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("Creating statement");
            stmt=conn.createStatement();
            String sql;

            System.out.println("\n\n");

            System.out.println("Task 1");
            sql="SELECT A_ID AS ACCOUNT, COUNT(T_ID) AS NO_OF_TRANSACTIONS FROM TRANSACTIONS WHERE a_id = 49 GROUP BY a_id";
            System.out.println("Executing the query of Task 1:\n" + sql);
            ResultSet rs=stmt.executeQuery(sql);
            while(rs.next()) {
                int account = rs.getInt("ACCOUNT");
                long no_of_transactions = rs.getLong("NO_OF_TRANSACTIONS");
                System.out.print("Account ID: "+account + " has a total of " + no_of_transactions + " transactions.");
            }
            System.out.println("\n\n");

            System.out.println("Task 2");
            sql="SELECT COUNT (TYPE) AS NO_OF_CREDIT FROM TRANSACTIONS WHERE TYPE = 0 GROUP BY TYPE";
            System.out.println("Executing the query of Task 2: " + sql);
            rs=stmt.executeQuery(sql);
            while(rs.next())
            {
                long no_of_credit=rs.getLong("NO_OF_CREDIT");
                System.out.print("There are a total of "+no_of_credit+" credit transactions.");
            }
            rs.close();

            System.out.println("\n\n");
            System.out.println("Task 3");
            sql="SELECT T_ID FROM TRANSACTIONS WHERE MONTHS_BETWEEN(DATE'2022-1-1', DTM)<=6 AND DTM < DATE '2022-1-1'";
            System.out.println("Executing the query of Task 3: " + sql);
            rs=stmt.executeQuery(sql);
            System.out.println("The list of transactions which occurred in the last 6 months of 2021 are: ");
            while(rs.next())
            {
                int t_id=rs.getInt("T_ID");
                System.out.print(t_id+"\n");
            }
            rs.close();

            System.out.println("\n\n");
            System.out.println("Task 4");
            ArrayList<Account> accounts = new ArrayList<Account>();
            String sql1="SELECT A_ID, SUM(AMOUNT) AS TOTAL_AMOUNT FROM TRANSACTIONS GROUP BY A_ID ORDER BY A_ID";
            String sql2="SELECT A_ID, SUM(AMOUNT) AS TOTAL_CREDIT FROM TRANSACTIONS WHERE TYPE = 0 GROUP BY A_ID ORDER BY A_ID";
            String sql3="SELECT A_ID, SUM(AMOUNT) AS TOTAL_DEBIT FROM TRANSACTIONS WHERE TYPE = 1 GROUP BY A_ID ORDER BY A_ID";
            System.out.println("Executing the query of Task 4: \n" + sql1 + "\n"+sql2+"\n"+sql3);



            System.out.println("The list of transactions which occurred in the last 6 months of 2021 are:\n");
            ResultSet rs1=stmt.executeQuery(sql1);
            while(rs1.next())
            {
                int id=rs1.getInt("A_ID");
                long total_amount=rs1.getLong("TOTAL_AMOUNT");
                boolean flag = false;
                for(Account a : accounts)
                {
                    if(a.accountID == id)
                    {
                        a.total = a.total + total_amount;
                        flag = true;
                    }
                }
                if(flag == false);
                {
                    Account dummy = new Account(id);
                    dummy.total = total_amount;
                    accounts.add(dummy);
                }
            }
            ResultSet rs2=stmt.executeQuery(sql2);
            while(rs2.next())
            {
                int id=rs2.getInt("A_ID");
                long total_credit=rs2.getLong("TOTAL_CREDIT");
                boolean flag = false;
                for(Account a : accounts)
                {
                    if(a.accountID == id)
                    {
                        a.credit = a.credit + total_credit;
                        flag = true;
                    }
                }
                if(flag == false);
                {
                    Account dummy = new Account(id);
                    dummy.credit = total_credit;
                    accounts.add(dummy);
                }
            }
            ResultSet rs3=stmt.executeQuery(sql3);
            while(rs3.next())
            {
                int id=rs3.getInt("A_ID");
                long total_debit=rs3.getLong("TOTAL_DEBIT");
                boolean flag = false;
                for(Account a : accounts)
                {
                    if(a.accountID == id)
                    {
                        a.debit = a.debit + total_debit;
                        flag = true;
                    }
                }
                if(flag == false);
                {
                    Account dummy = new Account(id);
                    dummy.debit = total_debit;
                    accounts.add(dummy);
                }
            }
            long cipCount=0;
            long vipCount=0;
            long opCount=0;
            long unclassifiedCount=0;
            for(Account a : accounts) {
                {
                    a.setBalance();
                    String type = a.getAccountType();
                    if(type == "CIP")
                    {
                        cipCount++;
                    }
                    else if(type=="VIP")
                    {
                        vipCount++;
                    }
                    else if(type == "OP")
                    {
                        opCount++;
                    }
                    else
                    {
                        unclassifiedCount++;
                    }
                }
            }
            System.out.println("The number of CIP accounts are "+cipCount+".\n");
            System.out.println("The number of VIP accounts are "+vipCount+".\n");
            System.out.println("The number of OP accounts are "+opCount+".\n");
            System.out.println("The number of accounts which don't fall under any of the given categories are "+unclassifiedCount+".\n");
            rs1.close();
            rs2.close();
            rs3.close();
            stmt.close();
            conn.close();
            System.out.println("Thank you for banking with us!");
        }

        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}