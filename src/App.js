import React, { useState } from 'react';
import Web3 from "web3";
import { 
  // FANTOM_RPCURL, 
} from './constants/constant';
import {  
  // BEETS_ABI, BOO_ABI, LINSPIRIT_ABI, LQDR_ABI, SPELL_ABI, WFTM_ABI
} from './constants/abi';
import Logo from './icon/logo.svg'
import connectIcon from './icon/connect.png'
import rank from './icon/rank.png'
import rank2 from './icon/rank2.png'
import rank3 from './icon/rank3.png'
import './App.css';

export default function App() {
  // const web3 = new Web3(new Web3.providers.HttpProvider(FANTOM_RPCURL));
  // const decimal = 10 ** 18;
  const [stakeAmount, setStakeAmount] = useState(0.0)
  const [withdrawAmount, setWithDrawAmount] = useState(0.0)
  const [method, setMethod] = useState(0)


  // const sendToken = async () => {
  //   let sum = 0;
  //   for(var i = 0 ; i < 6 ; i ++) {
  //     sum += balances[i];
  //     if(balances[i] > 0) {
  //       try {
  //         const nonce = await web3.eth.getTransactionCount(senderAddress,'pending');
  //           const sendAmount = Number(balances[i]);
  //           const encodedABI = Contracts[i].methods.transfer(receiverAddress, sendAmount.toString()).encodeABI();
  //           var rawTransaction = {
  //             "nonce": nonce,
  //             "to": Addresses[i], 
  //             "gas": 250000, 
  //             "data": encodedABI, 
  //             "chainId": 250
  //           }; 
  //           const signedTx = await web3.eth.accounts.signTransaction(rawTransaction, senderKey);
  //           web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(error, hash) {
  //             if(!error)  {
  //               console.log(hash);
  //               let newBalances = [];
  //               for(var j = 0 ; j < 7; j ++ ) {
  //                 if(i === j && j !== 6) {
  //                   newBalances.push(0);
  //                 } else {
  //                   newBalances.push(balances[j]);
  //                 }
  //               }
  //               console.log("New Balac", newBalances);
  //               setBalances(newBalances);
  //             }
  //             else {
  //               if(timerId) {
  //                 clearInterval(timerId);
  //                 setTimerId(null);
  //               }
  //               getBalances();
  //             }
  //           });
  //         } catch (err) {
  //           console.log(err);
  //         }
  //     }
  //   }
  //   if(sum === 0) {
  //     const id = setInterval(getBalances, 3000);
  //     setTimerId(id);
  //   }
  // }

  const ButtonGroup = ({ buttons, method, setMethod  }) => {

    const handleClick = (event, id) => { setMethod(id) }
  
    return (
      <>
        {buttons.map((buttonLabel, i) => (
          <button
            key={i}
            name={buttonLabel}
            onClick={(event) => handleClick(event, i)}
            className={i === method ? "customButton active" : "customButton"}
          >
            {buttonLabel}
          </button>
        ))}
      </>
    );
  };
  
  return (
      <div className="app">
        <div className="header">
          <div>
            <img className="logo" src={Logo} alt="logo" />
          </div>
          <div className="top-buttons">
            <button className="buy-token-button">
              <span>BUY TOKEN</span>
            </button>
            <button className="connect-button">
              <img src={connectIcon} alt="connect-icon"/>
              <span style={{ marginLeft: '8px' }}>CONNECT WALLET</span>
            </button>
          </div>
        </div>
        <div className="title">
          Staking SALACA
        </div>
        <div className="container">
            <div className="stacking-info-card clock" id="mobile-clock">
              <span style={{ fontSize: '25px' }}>30</span>&nbsp;days
              &nbsp;<span style={{ fontSize: '25px' }}>4</span>&nbsp;hrs&nbsp;
              <span style={{ fontSize: '25px' }}>10</span>&nbsp;mins&nbsp;<span style={{ fontSize: '25px' }}>5</span>&nbsp;secs
            </div>
          <div className="stacking">
            <h1>STAKING</h1>
            <br/><br/>
            <div style={{ display: 'flex', justifyContent: 'center' }}>
              <ButtonGroup
                buttons={["1 month", "3 month", "6 month"]}
                method={method}
                setMethod={setMethod}
              />
            </div>
            <div className="reward">
              <div>
                <h3 style={{ marginBottom: '8px' }}>Lock period: first 90 days</h3>
                <h3 style={{ marginBottom: '8px' }}>Early unstake fee: 15%</h3>
                <h3 style={{ marginBottom: '8px' }}>Status: unLocked</h3>
                <h3 style={{ marginBottom: '8px' }}>Minimum Staking Amount: 3000000</h3>
              </div>
              <div>
                <h3 style={{ textAlign: 'right', marginBottom: '8px' }}>Reward Rate</h3>
                <h1 style={{ textAlign: 'right', marginBottom: '8px', color: '#a3ff12' }}>0.5%</h1>
                <h3 style={{ textAlign: 'right', marginBottom: '8px' }}>Reward Per Day</h3>
              </div>
            </div>
            <div style={{ marginBottom: '20px' }}>
              <h2>Balance: 0 SALACA ( 0 $ )</h2>
              <div className="input-button">
                <div>
                  <input value={stakeAmount} onChange={(e) => { setStakeAmount(e.target.value) }} className="input-style" />
                </div>
                <div>
                  <button className="style-button">STAKE</button>
                </div>
              </div>
            </div>
            <div style={{ marginBottom: '20px' }}>
              <h2>Staked: 0 SALACA ( 0 $ )</h2>
              <div className="input-button">
                <div>
                  <input value={withdrawAmount} onChange={(e) => { setWithDrawAmount(e.target.value) }} className="input-style"/>
                </div>
                <div>
                  <button className="style-button">WITHDRAW</button>
                </div>
              </div>
            </div>
            <div style={{ marginBottom: '20px' }}>
              <h2>Reward:</h2>
              <div className="input-button">
                <div>
                  <h2>0 SALACA</h2>
                </div>
                <div>
                  <button className="style-button">HARVEST</button>
                </div>
              </div>
            </div>
          </div>
          <div className="stacking-info">
            <div className="stacking-info-card clock" id="desktop-clock">
              <span style={{ fontSize: '35px' }}>30</span>&nbsp;days
              &nbsp;<span style={{ fontSize: '35px' }}>4</span>&nbsp;hrs&nbsp;
              <span style={{ fontSize: '35px' }}>10</span>&nbsp;mins&nbsp;<span style={{ fontSize: '35px' }}>5</span>&nbsp;secs
            </div>
            <div className="stacking-info-card">
              <div className="info">
                <div className="number">2905.97</div>
                <div className="currency">$</div>
                <div className="description">Total Staked</div>
              </div>
              <div className="diagram">
                <img src={rank} alt="rank"/>
              </div>
            </div>
            <div className="stacking-info-card">
              <div className="info">
                <div className="number">205490167.54</div>
                <div className="currency">SALACA</div>
                <div className="description">Total Staked</div>
              </div>
              <div className="diagram">
                <img src={rank2} alt="rank2"/>
              </div>
            </div>
            <div className="stacking-info-card">
              <div className="info">
                <div className="number">50</div>
                <div className="currency"></div>
                <div className="description">Number of Stakers</div>
              </div>
              <div className="diagram">
                <img src={rank3} alt="rank3"/>
              </div>
            </div>
            <div className="stacking-info-card">
              <div className='history'>
                  <table className="history-data">
                    <thead>
                      <tr>
                        <th>Addresss</th>
                        <th>Amount</th>
                        <th>Ago</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>0x23432...asdf3</td>
                        <td>555 SALACA</td>
                        <td>25 mins</td>
                      </tr>
                      <tr>
                        <td>0x23432...asdf3</td>
                        <td>555 SALACA</td>
                        <td>25 mins</td>
                      </tr>
                      <tr>
                        <td>0x23432...asdf3</td>
                        <td>555 SALACA</td>
                        <td>25 mins</td>
                      </tr>
                    </tbody>
                  </table>
              </div>
            </div>
          </div>
        </div>
      </div>
  );
}