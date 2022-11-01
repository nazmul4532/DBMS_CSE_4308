public class Account {
    public long balance=0;
    public long credit = 0;
    public long debit =0;
    public long total =0;
    public int accountID;
    public String getAccountType(){
        String str;
        if(total >=5000000 && balance>=1000000)
        {
            str = "CIP";
        }
        else if(balance>=500000 && balance<=900000 && total >=2500000 && total <=4500000)
        {
            str = "VIP";
        }
        else if(balance<=100000 && total <=1000000){
            str = "OP";
        }
        else{str = "Unclassified";}
        return str;
    }
    public void setBalance(){
        balance = credit - debit;
    }

    Account(int accountID){
        this.accountID = accountID;
    }
}
