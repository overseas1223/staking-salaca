import React, { useState, useEffect } from 'react';
import Web3 from "web3";
import { TOKEN_ADDRESS, STAKING_CONTRACT_ADDRESS } from './constants/constant';
import { TOKEN_ABI, STAKING_CONTRACT_ABI } from './constants/abi';
import Logo from './icon/logo.svg'
import connectIcon from './icon/connect.png'
import rank from './icon/rank.png'
import rank2 from './icon/rank2.png'
import rank3 from './icon/rank3.png'
import './App.css';

const CHAIN_ID = '0x61'
/* global BigInt */

export default function App() {
  let web3 = new Web3(window.ethereum)
  const decimal = 10 ** 18
  let tokenContract = new web3.eth.Contract(TOKEN_ABI, TOKEN_ADDRESS)
  let stakeContract = new web3.eth.Contract(STAKING_CONTRACT_ABI, STAKING_CONTRACT_ADDRESS)

  const [chainId, setChainId] = useState('')
  const [wallet, setWallet] = useState('CONNECT WALLET')
  const [mode, setMode] = useState(0)
  const [rewardRate, setRewardRate] = useState(0)
  const [unstakeFee, setUnStakeFee] = useState(0)
  const [withdrawFee, setWithdrawFee] = useState(0)
  const [stakeAmount, setStakeAmount] = useState(0.0)
  const [withdrawAmount, setWithDrawAmount] = useState(0.0)
  const [stakers, setStakers] = useState(0)
  const [stakeUsdAmout, setStakeUsdAmount] = useState(0)
  const [stakeTokenAmount, setStakeTokenAmount] = useState(0)
  const [usdBalance, setUsdBalance] = useState(0)
  const [balance, setBalance] = useState(0)
  const [stakedUsdAmount, setStakedUsdAmount] = useState(0)
  const [stakedAmount, setStakedAmount] = useState(0)
  const [rewardAmount, setRewardAmount] = useState(0)

  window.ethereum.on('accountsChanged', async () => {
    const accounts = await window.ethereum.request({method: 'eth_accounts'});
    if (!(accounts && accounts.length > 0)) {
      setWallet('CONNECT WALLET')
      getStakeState()
    }
  });

  const connectWallet = async () => {
    if(window.ethereum) {
      await window.ethereum.request({ method: "eth_requestAccounts" })
        .then(async (accounts) => {
          let chainId = window.ethereum.chainId // 0x1 Ethereum, 0x2 testnet, 0x89 Polygon, etc.
          setWallet(accounts[0])
          if(chainId !== CHAIN_ID) {
            await window.ethereum.request({
              method: 'wallet_switchEthereumChain',
              params: [{ chainId: Web3.utils.toHex(CHAIN_ID) }],
            }).then((res) => { setChainId(CHAIN_ID) }).catch(err => console.log(err))
          } else setChainId(CHAIN_ID)
        }).catch((err) => console.log(err))
    } else {
      console.log("Please install metamask")
    }
  }

  const getStakeState = async () => {
    const result = await Promise.all([
      stakeContract.methods.getNumberofStakers().call(),
      stakeContract.methods.getTotalStakedAmount().call(),
      stakeContract.methods.getStakedAmount(wallet).call(),
      stakeContract.methods.getRewardAmount(wallet).call(),
      tokenContract.methods.balanceOf(wallet).call()
    ])

    setStakers(Number(result[0]))
    setStakeTokenAmount(Math.round(Number(result[1] * 100) / (decimal * 100)))
    setStakedAmount(Math.round(Number(result[2] * 100) / (decimal * 100)))
    setRewardAmount(Math.round(Number(result[3] * 100) / (decimal * 100)))
    setBalance(Math.round(Number(result[4] * 100) / (decimal * 100)))
  }

  const getRateAndFee = async () => {
    const result = await Promise.all([
      stakeContract.methods.getRewardRate(mode).call(),
      stakeContract.methods.getWithdrawFee(mode, false).call(),
      stakeContract.methods.getWithdrawFee(mode, true).call()
    ])

    setRewardRate(Number(result[0]) / 100)
    setUnStakeFee(Number(result[1]) / 100)
    setWithdrawFee(Number(result[2]) / 100)
  }

  const stake = async () => {
    if(stakeAmount <= 0) {
      alert('stakeAmount should be more than zero')
      return
    } else if(stakeAmount > balance) {
      alert('Token balance is not Insufficient')
      return
    }

    await tokenContract.methods.approve(STAKING_CONTRACT_ADDRESS, BigInt(stakeAmount * decimal)).send({ from: wallet })
    await stakeContract.methods.startStaking(BigInt(stakeAmount * decimal), mode).send({ from: wallet })
    getStakeState()
  }

  const withdraw = async () => {
    if(withdrawAmount <= 0) {
      alert("Withdraw Amount should be more than zero")
      return
    } else if(withdrawAmount >= stakedAmount) {
      alert("staked Amount is not Insufficient")
      return
    }

    await stakeContract.methods.withdraw(BigInt(withdrawAmount * decimal)).send({ from: wallet })
    getStakeState()
  }

  const harvest = async () => {
    await stakeContract.methods.harvest().send({ from: wallet })
    getStakeState()
  }

  useEffect(() => { connectWallet() }, [])
  useEffect(() => { if(chainId === CHAIN_ID) getStakeState() }, [chainId])
  useEffect(() => { getRateAndFee() }, [mode])

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
            <button className="connect-button" onClick={connectWallet}>
              <img src={connectIcon} alt="connect-icon"/>
              <span style={{ marginLeft: '8px' }}>{wallet === 'CONNECT WALLET' ? wallet : `${wallet.substring(0, 9).toUpperCase()}...${wallet.substring(-1, 4).toUpperCase()}`}</span>
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
                method={mode}
                setMethod={setMode}
              />
            </div>
            <div className="reward">
              <div>
                <h3 style={{ marginBottom: '8px' }}>Lock period: first {mode === 0 ? 30 : mode * 3 * 30} days</h3>
                <h3 style={{ marginBottom: '8px' }}>Early unstake fee: {unstakeFee}%</h3>
                <h3 style={{ marginBottom: '8px' }}>Status: unLocked</h3>
                <h3 style={{ marginBottom: '8px' }}>Minimum Staking Amount: 3000000</h3>
              </div>
              <div>
                <h3 style={{ textAlign: 'right', marginBottom: '8px' }}>Reward Rate</h3>
                <h1 style={{ textAlign: 'right', marginBottom: '8px', color: '#a3ff12' }}>{rewardRate}%</h1>
                <h3 style={{ textAlign: 'right', marginBottom: '8px' }}>Reward Per Day</h3>
              </div>
            </div>
            <div style={{ marginBottom: '20px' }}>
              <h2>Balance: {balance} SALACA ( 0 $ )</h2>
              <div className="input-button">
                <div>
                  <input value={stakeAmount} onChange={(e) => { setStakeAmount(e.target.value) }} className="input-style" />
                </div>
                <div>
                  <button className="style-button" onClick={stake}>STAKE</button>
                </div>
              </div>
            </div>
            <div style={{ marginBottom: '20px' }}>
              <h2>Staked: {stakedAmount} SALACA ( 0 $ )</h2>
              <div className="input-button">
                <div>
                  <input value={withdrawAmount} onChange={(e) => { setWithDrawAmount(e.target.value) }} className="input-style"/>
                </div>
                <div>
                  <button className="style-button" onClick={withdraw}>WITHDRAW</button>
                </div>
              </div>
            </div>
            <div style={{ marginBottom: '20px' }}>
              <h2>Reward:</h2>
              <div className="input-button">
                <div>
                  <h2>{rewardAmount} SALACA</h2>
                </div>
                <div>
                  <button className="style-button" onClick={harvest}>HARVEST</button>
                </div>
              </div>
            </div>
          </div>
          <div className="stacking-info">
            <div className="stacking-info-card clock" id="desktop-clock">
              <span style={{ fontSize: '35px' }}>20</span>&nbsp;days
              &nbsp;<span style={{ fontSize: '35px' }}>4</span>&nbsp;hrs&nbsp;
              <span style={{ fontSize: '35px' }}>10</span>&nbsp;mins&nbsp;<span style={{ fontSize: '35px' }}>5</span>&nbsp;secs
            </div>
            <div className="stacking-info-card">
              <div className="info">
                <div className="number">0</div>
                <div className="currency">$</div>
                <div className="description">Total Staked</div>
              </div>
              <div className="diagram">
                <img src={rank} alt="rank"/>
              </div>
            </div>
            <div className="stacking-info-card">
              <div className="info">
                <div className="number">{stakeTokenAmount}</div>
                <div className="currency">SALACA</div>
                <div className="description">Total Staked</div>
              </div>
              <div className="diagram">
                <img src={rank2} alt="rank2"/>
              </div>
            </div>
            <div className="stacking-info-card">
              <div className="info">
                <div className="number">{stakers}</div>
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