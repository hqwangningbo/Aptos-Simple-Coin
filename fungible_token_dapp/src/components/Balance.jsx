import React from "react";
import {AptosClient} from "aptos";
import {Card,Row,Col} from "antd";

const tokenStore = "0xafa14f6a40838a5891788dd441d49531bd94b0d1da0ec79d3153d921d8611464::fungible_token::TokenStore";
const tokenInfo = "0xafa14f6a40838a5891788dd441d49531bd94b0d1da0ec79d3153d921d8611464::fungible_token::TokenInfo";

// const address = this.props.address;
class Balance extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            balance: 0,
            tokenInfo:{}
        };
    }
    componentDidMount() {
        // this.getBalance(this.props.address)
        this.getTokenInfo()
    }
    getTokenInfo = () => {
        const client = new AptosClient("https://fullnode.devnet.aptoslabs.com");
        client.getAccountResources("0xafa14f6a40838a5891788dd441d49531bd94b0d1da0ec79d3153d921d8611464").then(data=> {
            let userTokenInfo = data.find((r) => r.type === tokenInfo)
            if (userTokenInfo.data.monitor_supply===false){
                userTokenInfo.data.monitor_supply = "false"
            }
            this.setState({
                tokenInfo: userTokenInfo.data
            });
        })
    }

    getBalance = (address) => {
        const client = new AptosClient("https://fullnode.devnet.aptoslabs.com");
        client.getAccountResources(address).then(data=> {
            console.log(data)
            let userTokenStore = data.find((r) => r.type === tokenStore)
            console.log(userTokenStore.data.token.value)
            this.setState({
                balance: userTokenStore.data.token.value
            });
        })

    }

    render() {
        return (
            <div>
                <Row gutter={16}>
                    <Col span={8}>
                        <Card
                            hoverable
                            title="TokenInfo"
                            style={{
                                width: 240,
                            }}
                        >
                            <p>name: {this.state.tokenInfo.name}</p>
                            <p>symbol: {this.state.tokenInfo.symbol}</p>
                            <p>decimals: {this.state.tokenInfo.decimals}</p>
                            <p>total_supply: {this.state.tokenInfo.total_supply}</p>
                            <p>monitor_supply: {this.state.tokenInfo.monitor_supply}</p>
                        </Card>
                    </Col>
                    <Col span={8}>
                        <Card
                            hoverable
                            title="TokenInfo"
                            style={{
                                width: 240,
                            }}
                        >
                            <p>name: {this.state.tokenInfo.name}</p>
                            <p>symbol: {this.state.tokenInfo.symbol}</p>
                            <p>decimals: {this.state.tokenInfo.decimals}</p>
                            <p>total_supply: {this.state.tokenInfo.total_supply}</p>
                            <p>monitor_supply: {this.state.tokenInfo.monitor_supply}</p>
                        </Card>
                    </Col>
                    <Col span={8}>
                        <Card
                            hoverable
                            title="TokenInfo"
                            style={{
                                width: 240,
                            }}
                        >
                            <p>name: {this.state.tokenInfo.name}</p>
                            <p>symbol: {this.state.tokenInfo.symbol}</p>
                            <p>decimals: {this.state.tokenInfo.decimals}</p>
                            <p>total_supply: {this.state.tokenInfo.total_supply}</p>
                            <p>monitor_supply: {this.state.tokenInfo.monitor_supply}</p>
                        </Card>
                    </Col>
                </Row>

                {/*<button onClick={()=>this.getBalance(this.props.address)}>*/}
                {/*    getBalance*/}
                {/*</button> <br/>*/}

                {/*<p>Balance: {this.state.balance}</p>*/}
            </div>
        )
    }
}

export default Balance
