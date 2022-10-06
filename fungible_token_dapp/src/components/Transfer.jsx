import React from "react";
import {AptosClient} from "aptos";
import { Button, Checkbox, Form, Input } from 'antd';

const tokenStore = "0xafa14f6a40838a5891788dd441d49531bd94b0d1da0ec79d3153d921d8611464::fungible_token::TokenStore";
const transfer = "0xafa14f6a40838a5891788dd441d49531bd94b0d1da0ec79d3153d921d8611464::fungible_token::transfer";

// const address = this.props.address;
class Transfer extends React.Component {
    constructor(props) {
        super(props);
        // this.state = {
        //     hash:null
        // }
    }


    handleSubmit(values) {
            // Create a transaction
            const transaction = {
                arguments: [values.to, values.amount],
                function: transfer,
                type: 'entry_function_payload',
                type_arguments: [],
            };
            window.aptos.signAndSubmitTransaction(transaction).then(data=>{
                console.log(data)
            })
    }

    render() {
        return (
            <div>
                <Form
                    name="basic"
                    labelCol={{ span: 8 }}
                    wrapperCol={{ span: 16 }}
                    initialValues={{ remember: true }}
                    autoComplete="off"
                    onFinish={this.handleSubmit}
                >
                    <Form.Item
                        label="To"
                        name="to"
                        rules={[{ required: true, message: 'Please input address!' }]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item
                        label="Amount"
                        name="amount"
                        rules={[{ required: true, message: 'Please input amount!' }]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item wrapperCol={{ offset: 8, span: 16 }}>
                        <Button type="primary" htmlType="submit">
                            Submit
                        </Button>
                    </Form.Item>
                </Form>
            </div>
        )
    }
}

export default Transfer
