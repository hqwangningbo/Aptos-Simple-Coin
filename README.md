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
    2. Manage_coin.move讲解
    3. 发coin方式2
    4. coin.move讲解
3. aptos.js sdk讲解
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

4.领取水龙头

```
curl --location --request POST 'http://127.0.0.1:8081/mint?amount=100000000&address=0xab3f49e4916208de2e3fe124e2dda01b747f985d81c47d4e751e2a76de266aa6'
```

5.合约相关：

```shell
#新建move项目
aptos move init --name project_name

#编译move
aptos move compiler

#测试
aptos move test

#部署合约
aptos move publish --named-addresses simple_coin_2=0xaf1a16a2a1e0a4c161d302d7dd65d4bed2fe831c2184562e85fc4d10c425a860 --private-key-file ../test1 --url http://127.0.0.1:8080

#调用合约
aptos move run --function-id 0x7f533d257e92a2cd676b8255d945672d738ef6307c7c4563a764b904cc5ed87f::SimpleCoin::issue --private-key-file test --url http://127.0.0.1:8080
```

# 如何发coin

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



## aptos.js sdk讲解
