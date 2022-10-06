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

struct Token has store {
    value: u128
}

struct TokenStore has key {
    token: Token,
    transfer_event:EventHandle<TransferEvent>,
    approval_event:EventHandle<ApprovalEvent>,
}
struct TokenInfo has key {
    name: String,
    symbol: String,
    decimals: u8,
    total_supply: u128,
    /// Whether to support mint and burn
    monitor_supply: bool,
}

// Functions
public entry fun initialize(sender:&signer,name:String,symbol:String,decimals:u8,total_supply:u128,monitor_supply: bool)
public entry fun register(sender: &signer)
public entry fun transfer(sender:&signer,to:address,amount:u128)

//ing
public entry fun transferFrom(sender:&signer,from:address,to:address,amount:u128)
public entry fun approve(sender:&signer,spender:address,amount:u128)
public entry fun allowance(address owner, address spender) :u128
```
## non_fungible_token
```move
//Designing
```

## multi_token
```move
//Designing
```
