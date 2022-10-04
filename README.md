# move-library
## fungible_token
```move
// Events
struct TransferEvent has store, drop {
        from: address,
        to: address,
        amount: u128
    }

struct ApprovalEvent has store, drop {
    owner: address,
    spender: address,
    amount: u128
}

// Functions
public fun initialize(sender:&signer,name:String,symbol:String,decimals:u8,total_supply:u128,monitor_supply: bool)
public fun register(sender: &signer)

public fun name(): String
public fun symbol(): String
public fun decimals(): u8
public fun total_supply(): u128

public fun balance_of(addr:address) :u128
public fun transfer(sender:&signer,to:address,amount:u128)

//ing
public fun transferFrom(sender:&signer,from:address,to:address,amount:u128)
public fun approve(sender:&signer,spender:address,amount:u128)
public fun allowance(address owner, address spender) :u128
```
## non_fungible_token
```move
//Designing
```

## multi_token
```move
//Designing
```
