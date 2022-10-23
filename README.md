# Aptos-Simple-Coin
# 目录

1. Aptos cli
    1. 安装
    2. 生成测试账户
    3. 搭建测试网
    4. 领水龙头
    5. move开发常用

2. 如何发coin
    1. 发coin方式1
    2. managed_coin.move讲解
    3. 发coin方式2
    4. coin.move讲解
3. aptos dapp交互
    1. 调用钱包
    2. 调用方法

Aptos cli -> coin合约实战 -> 使用钱包调合约

## Aptos cli

1. 安装

安装Aptos https://github.com/aptos-labs/aptos-core/releases

2.启动本地测试网

```shell
aptos node run-local-testnet --force-restart --with-faucet
```

3.生成测试账户

 ```shell
aptos key generate --output-file test
 ```

petra钱包: https://chrome.google.com/webstore/detail/petra-aptos-wallet/ejjladinnckdgjemekebdpeokbikhfci

4.领取水龙头激活账户

```
curl --location --request POST 'http://127.0.0.1:8081/mint?amount=100000000&address=0xab3f49e4916208de2e3fe124e2dda01b747f985d81c47d4e751e2a76de266aa6'
```

5.合约相关：

```shell
#新建move项目
aptos move init --name project_name

#编译move
aptos move compile

#测试
aptos move test

#部署合约
aptos move publish --named-addresses simple_coin_2=0xaf1a16a2a1e0a4c161d302d7dd65d4bed2fe831c2184562e85fc4d10c425a860 --private-key-file ../test1 --url http://127.0.0.1:8080

#调用合约
aptos move run --function-id 0x7f533d257e92a2cd676b8255d945672d738ef6307c7c4563a764b904cc5ed87f::SimpleCoin::issue --private-key-file test --url http://127.0.0.1:8080
```

# 如何发coin

Aptos move仓库：https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework

aptos_framework部署在0x1地址下，带有entry可以直接使用命令行调用

调用命令：

1. aptos move run --function-id
2. --args : 指定参数，注意要加类型，string::String，vector< u8 >类型使用string:"USDT"，其他u8，bool等
3. --type-args：如果方法带有泛型，注意要加，如managed_coin下的initialize方法，需指定coin类型

initialize

```shell
aptos move run --function-id 0x1::managed_coin::initialize --args string:"USDT" string:"USDT" u8:8 bool:true --type-args
 0xaf1a16a2a1e0a4c161d302d7dd65d4bed2fe831c2184562e85fc4d10c425a860::SimpleCoin1::USDT --private-key-file ../test1 --url http://127.0.0.1:8080
```

register

```shell
aptos move run --function-id 0x1::managed_coin::register --type-args 0xaf1a16a2a1e0a4c161d302d7dd65d4bed2fe831c2184562e85fc4d10c425a860::SimpleCoin1::USDT --private-key-file ../test1 --url http://127.0.0.1:8080

```

mint

```shell
aptos move run --function-id 0x1::managed_coin::mint --args address:0xaf1a16a2a1e0a4c161d302d7dd65d4bed2fe831c2184562e85fc4d10c425a860 u64:1000000000 --type-args 0xaf1a16a2a1e0a4c161d302d7dd65d4bed2fe831c2184562e85fc4d10c425a860::SimpleCoin1::USDT --private-key-file ../test1 --url http://127.0.0.1:8080
```

## aptos钱包交互讲解

https://github.com/hqwangningbo/Aptos-Simple-Coin/blob/master/simple_coin_template/src/SimpleCoin.jsx

```javascript
		connectWallet = async () => {
        const response = await window.aptos.connect()
        console.log(response.address)
        this.setState({ address: response.address });
    }

    issue = async () =>{
        const transaction = {
            type: "entry_function_payload",
            function: issue,
            arguments: [],
            type_arguments: [],
        };
        await window.aptos.connect()
        let ret = await window.aptos.signAndSubmitTransaction(transaction);
        console.log('ret', ret.hash);
        this.setState({
            address: this.state.address ,
            hash:ret.hash
        });
    }

    register = async () =>{
        const transaction = {
            type: "entry_function_payload",
            function: register,
            arguments: [],
            type_arguments: [],
        };
        await window.aptos.connect()
        let ret = await window.aptos.signAndSubmitTransaction(transaction);
        console.log('ret', ret.hash);
        this.setState({
            address: this.state.address,
            hash:ret.hash
        });
    }

    transfer = async () =>{
        const transaction = {
            type: "entry_function_payload",
            function: transfer,
            arguments: ["0xd8f6f1195aad9e39a3bd4bfe98a682bc6e6618b8640cf39c26f79a42863d6172","10"],
            type_arguments: [coinType],
        };
        await window.aptos.connect()
        let ret = await window.aptos.signAndSubmitTransaction(transaction);
        console.log('ret', ret.hash);
        this.setState({
            address: this.state.address,
            hash: ret.hash,
        });
    }

```

