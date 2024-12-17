import Text "mo:base/Text";

module {

    public type Currency = {
        #ICP;
        #ckUSDC;
        #ckBTC;
        #ckETH;
    };

    public type Donation = {
        donorId : Principal;
        amount : Nat64;
        currency : Currency;
        blockIndex : Nat;   
        timestamp : Int;
        isConfirmed : Bool;
    };

    public type VotingPower = {
        userId : Principal;
        totalPower : Nat64;
        powerHistory : [PowerChange];
    };

    public type PowerChange = {
        amount : Nat64;
        timestamp : Int;
        source : Donation;        
    };
};
