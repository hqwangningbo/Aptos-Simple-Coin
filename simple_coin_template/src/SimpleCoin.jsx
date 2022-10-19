import React from "react";
import {Button} from "antd";

const issue = '0xd8f6f1195aad9e39a3bd4bfe98a682bc6e6618b8640cf39c26f79a42863d6172::SimpleCoin::issue'
const register = '0xd8f6f1195aad9e39a3bd4bfe98a682bc6e6618b8640cf39c26f79a42863d6172::SimpleCoin::register'
const coinType = '0xd8f6f1195aad9e39a3bd4bfe98a682bc6e6618b8640cf39c26f79a42863d6172::SimpleCoin::USDT'
const transfer = '0x1::coin::transfer'

function stringToHex(text) {
    const encoder = new TextEncoder();
    const encoded = encoder.encode(text);
    return Array.from(encoded, (i) => i.toString(16).padStart(2, "0")).join("");
}
class SimpleCoin extends React.Component {

    constructor() {
        super();
        this.state = {
            address: "",
            hash:""
        };
    }

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



    render() {
        return (
            <div>
                <h1>Hello SimpleCoin</h1>
                <Button style={{marginTop:40,marginBottom:40}} onClick={this.connectWallet}>Connect Wallet</Button>
                <br/>
                <h3 style={{marginTop:10,marginBottom:10}}>{this.state.address}</h3>
                <br/>
                <Button style={{marginTop:40,marginBottom:40}} onClick={this.issue}>Issue Coin</Button>
                <br/>
                <Button style={{marginTop:40,marginBottom:40}} onClick={this.register}>Register Coin</Button>
                <br/>
                <Button style={{marginTop:40,marginBottom:40}} onClick={this.transfer}>Transfer Coin</Button>
                <h3 style={{marginTop:40,marginBottom:40}}>{this.state.hash}</h3>
            </div>
        )
    }
}
export default SimpleCoin
