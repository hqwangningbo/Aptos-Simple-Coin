/*
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from,address to,uint256 amount) external returns (bool);


    function name() public view virtual override returns (string memory);
    function symbol() public view virtual override returns (string memory);
    function decimals() public view virtual override returns (uint8);

*/

module my_address::fungible_token {
    use std::signer;
    use std::string::{String, length};
    use aptos_std::type_info;
    use std::error;
    #[test_only]
    use std::string;
//    use aptos_std::event;
//    use aptos_framework::account;
//    use aptos_std::event::EventHandle;

    /// Maximum possible token supply.
    const MAX_U128: u128 = 340282366920938463463374607431768211455;
    /// Maximum possible token name.
    const MAX_TOKEN_NAME_LENGTH: u64 = 32;
    /// Maximum possible token symbol.
    const MAX_TOKEN_SYMBOL_LENGTH: u64 = 10;

    //
    // Errors.
    //

    /// Not permission
    const NOT_PERMISSION:u64 = 0;
    /// Already initialize
    const ALREADY_INITIALIZE:u64 = 1;
    /// Already register
    const ALREADY_REGISTER:u64 = 2;
    /// Not register
    const NOT_REGISTER:u64 = 3;
    /// Not monitor supply
    const NOT_MONITOR_SUPPLY:u64 = 4;
    /// more than u128
    const MORE_THAN_U128:u64 = 5;
    /// Name of the token is too long
    const TOKEN_NAME_TOO_LONG: u64 = 6;
    /// Symbol of the token is too long
    const TOKEN_SYMBOL_TOO_LONG: u64 = 7;
    /// Insufficient balance
    const INSUFFICIENT_BALANCE:u64 = 8;

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
//        transfer_event:EventHandle<TransferEvent>,
//        approval_event:EventHandle<ApprovalEvent>,
    }
    struct TokenInfo has key {
        name: String,
        symbol: String,
        decimals: u8,
        total_supply: u128,
        /// Whether to support mint and burn
        monitor_supply: bool,
    }

    public fun initialize(sender:&signer,name:String,symbol:String,decimals:u8,total_supply:u128,monitor_supply: bool)  {
        let addr = signer::address_of(sender);
        assert!(addr == token_address(),error::invalid_argument(NOT_PERMISSION));
        assert!(!exists<TokenInfo>(token_address()),error::already_exists(ALREADY_INITIALIZE));
        assert!(length(&name) <= MAX_TOKEN_NAME_LENGTH,error::invalid_argument(TOKEN_NAME_TOO_LONG));
        assert!(length(&symbol) <= MAX_TOKEN_SYMBOL_LENGTH,error::invalid_argument(TOKEN_SYMBOL_TOO_LONG));
        let token_info = TokenInfo {
            name,
            symbol,
            decimals,
            total_supply,
            monitor_supply
        };
        let token_store = TokenStore {
            token: Token { value: total_supply },
//            transfer_event: account::new_event_handle<TransferEvent>(sender),
//            approval_event: account::new_event_handle<ApprovalEvent>(sender),
        };
        move_to(sender,token_info);
        move_to(sender,token_store);
    }

    public fun token_address(): address {
        let type_info = type_info::type_of<Token>();
        type_info::account_address(&type_info)
    }

    /// Returns `true` if the token is an initialized token.
    public fun is_token_initialized(): bool {
        exists<TokenInfo>(token_address())
    }

    /// Returns `true` if `account_addr` is registered to receive token.
    public fun is_account_registered(addr: address): bool {
        exists<TokenStore>(addr)
    }

    /// Returns the name of the coin.
    public fun name(): String acquires TokenInfo {
        borrow_global<TokenInfo>(token_address()).name
    }

    /// Returns the symbol of the coin, usually a shorter version of the name.
    public fun symbol(): String acquires TokenInfo {
        borrow_global<TokenInfo>(token_address()).symbol
    }

    /// Returns the number of decimals used to get its user representation.
    /// For example, if `decimals` equals `2`, a balance of `505` coins should
    /// be displayed to a user as `5.05` (`505 / 10 ** 2`).
    public fun decimals(): u8 acquires TokenInfo {
        borrow_global<TokenInfo>(token_address()).decimals
    }

    /// Returns the amount of token in existence.
    public fun total_supply(): u128 acquires TokenInfo {
        borrow_global<TokenInfo>(token_address()).total_supply
    }

    /// Whether to support mint and burn
    public fun monitor_supply(): bool acquires TokenInfo {
        borrow_global<TokenInfo>(token_address()).monitor_supply
    }

    public fun register(sender: &signer) {
        let addr = signer::address_of(sender);
        assert!(!is_account_registered(addr), ALREADY_REGISTER);
        let token_store = TokenStore {
            token: Token { value: 0 },
//            transfer_event: account::new_event_handle<TransferEvent>(sender),
//            approval_event: account::new_event_handle<ApprovalEvent>(sender),
        };
        move_to(sender, token_store);
    }

    public fun balance_of(addr:address) :u128 acquires TokenStore {
        assert!(is_account_registered(addr),error::not_found(NOT_REGISTER));
        borrow_global<TokenStore>(addr).token.value
    }

    public fun mint(sender:&signer,to:address,amount:u128) acquires TokenInfo, TokenStore {
        assert!(signer::address_of(sender) == token_address(),error::permission_denied(NOT_PERMISSION));
        assert!(monitor_supply(),error::permission_denied(NOT_MONITOR_SUPPLY));
        assert!(is_account_registered(to),error::invalid_argument(NOT_REGISTER));
        let token_store = borrow_global_mut<TokenStore>(to);
        let token_info = borrow_global_mut<TokenInfo>(token_address());
        assert!(token_info.total_supply + amount <= MAX_U128,error::invalid_argument(MORE_THAN_U128));
        token_store.token.value = token_store.token.value + amount;
        token_info.total_supply = token_info.total_supply + amount
    }

    public fun burn(sender:&signer,from:address,amount:u128) acquires TokenInfo, TokenStore {
        assert!(signer::address_of(sender) == token_address(),error::permission_denied(NOT_PERMISSION));
        assert!(monitor_supply(),error::permission_denied(NOT_MONITOR_SUPPLY));
        assert!(is_account_registered(from),error::invalid_argument(NOT_REGISTER));
        let token_store = borrow_global_mut<TokenStore>(from);
        let token_info = borrow_global_mut<TokenInfo>(token_address());
        assert!(token_store.token.value >= amount,error::invalid_argument(INSUFFICIENT_BALANCE));
        token_store.token.value = token_store.token.value - amount;
        token_info.total_supply = token_info.total_supply - amount;
    }

    public fun transfer(from:&signer,to:address,amount:u128) acquires TokenStore {
        let addr = signer::address_of(from);
        assert!(is_account_registered(addr),error::invalid_argument(NOT_REGISTER));
        assert!(is_account_registered(to),error::invalid_argument(NOT_REGISTER));
        let from_token_store = borrow_global_mut<TokenStore>(addr);
        assert!(from_token_store.token.value >= amount,error::invalid_argument(INSUFFICIENT_BALANCE));
        from_token_store.token.value = from_token_store.token.value - amount;

//        event::emit_event<TransferEvent>(
//            &mut from_token_store.transfer_event,
//            TransferEvent { from: addr , to , amount },
//        );

        let to_token_store = borrow_global_mut<TokenStore>(to);
        to_token_store.token.value = to_token_store.token.value + amount;
    }

    #[test]
    fun token_address_should_work()  {
        assert!(token_address()==@my_address,0);
    }

    #[test_only]
    fun setup_initialize(sender:&signer)  {
        initialize(
            sender,
            string::utf8(b"nb token"),
            string::utf8(b"NB"),
            18,
            10000000000000000000,
            false,
        );
    }

    #[test(sender = @my_address)]
    fun initialize_should_work(sender:&signer)  acquires TokenInfo, TokenStore {
        let addr = signer::address_of(sender);
        assert!(is_token_initialized() == false, 0);
        assert!(is_account_registered(addr) == false, 0);

        setup_initialize(sender);

        assert!(is_token_initialized(),0);
        assert!(is_account_registered(addr),0);
        assert!(balance_of(addr) == 10000000000000000000,0);
        assert!(name() == string::utf8(b"nb token"),0);
        assert!(symbol() == string::utf8(b"NB"),0);
        assert!(decimals()==18,0);
        assert!(total_supply()==10000000000000000000,0);
        assert!(monitor_supply()==false,0);
    }

    #[test(sender = @my_address)]
    public fun register_should_work(sender:&signer) acquires TokenStore {
        let addr = signer::address_of(sender);
        assert!(is_account_registered(addr) == false, 0);
        register(sender);
        assert!(is_account_registered(addr), 0);
        assert!(balance_of(addr)==0, 0);
    }

    #[test(from = @my_address ,to = @0x2)]
    public fun transfer_should_work(from:&signer,to:&signer) acquires TokenStore {
        setup_initialize(from);
        let from_addr = signer::address_of(from);
        let to_addr = signer::address_of(to);
        register(to);
        assert!(balance_of(from_addr) == 10000000000000000000,0);
        assert!(balance_of(to_addr) == 0,0);
        transfer(from,to_addr,2000000000000000000);
        assert!(balance_of(from_addr) == 8000000000000000000,0);
        assert!(balance_of(to_addr) == 2000000000000000000,0);
    }



}
