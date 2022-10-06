import './App.css';
import React from "react";
import Balance from "./components/Balance";
import Transfer from "./components/Transfer";
import {Col,Row} from "antd";

function App() {
  // Retrieve aptos.account on initial render and store it.
  const [address, setAddress] = React.useState(null);
  React.useEffect(() => {
    window.aptos.account().then((data) => setAddress(data.address));
  }, []);

  return (
      <div className="App">
                      <p><code>{ address }</code></p>
                      <Balance address={address}/>
                      {/*<Transfer/>*/}
      </div>
  );
}

export default App;
