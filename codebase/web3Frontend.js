import { React, useState, useEffect } from "react";
import { ethers } from "ethers";
import styles from "./Bank.module.css";
import simple_token_abi from "./Contracts/bank_app_abi.json";
import Interactions from "./Interactions";

const BankApp = () => {
  // deploy simple token contract and paste deployed contract address here. This value is local ganache chain
  let contractAddress = "0x5bEe5176271f7b671253A39b99E5e1fd652D4cFA";

  const [errorMessage, setErrorMessage] = useState(null);
  const [defaultAccount, setDefaultAccount] = useState(null);
  const [connButtonText, setConnButtonText] = useState("Connect Wallet");

  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [contract, setContract] = useState(null);

  const [transferHash, setTransferHash] = useState(null);
  const [checkAcc, setCheckAcc] = useState("false");
  const [accStatus, setAccStatus] = useState("");
  const [accbalance, setAccBalance] = useState("");

  const connectWalletHandler = () => {
    if (window.ethereum && window.ethereum.isMetaMask) {
      window.ethereum
        .request({ method: "eth_requestAccounts" })
        .then((result) => {
          accountChangedHandler(result[0]);
          setConnButtonText("Wallet Connected");
        })
        .catch((error) => {
          setErrorMessage(error.message);
        });
    } else {
      console.log("Need to install MetaMask");
      setErrorMessage("Please install MetaMask browser extension to interact");
    }
  };

  // update account, will cause component re-render
  const accountChangedHandler = (newAccount) => {
    setDefaultAccount(newAccount);
    updateEthers();
  };
  const chainChangedHandler = () => {
    // reload the page to avoid any errors with chain change mid use of application
    window.location.reload();
  };

  // listen for account changes
  window.ethereum.on("accountsChanged", accountChangedHandler);

  window.ethereum.on("chainChanged", chainChangedHandler);

  const updateEthers = () => {
    let tempProvider = new ethers.providers.Web3Provider(window.ethereum);
    setProvider(tempProvider);

    let tempSigner = tempProvider.getSigner();
    setSigner(tempSigner);

    let tempContract = new ethers.Contract(
      contractAddress,
      simple_token_abi,
      tempSigner
    );
    setContract(tempContract);
  };

  const createAccount = async () => {
    let txt = await contract.createAcc();
    console.log(txt);
    setAccStatus("Your Account is created");
  };
  const checkAccountExists = async () => {
    ///e.preventDefault();
    let txt = await contract.accountExists();
    if (txt == true) {
      setCheckAcc("true");
    }
  };
  const AccountBalance = async () => {
    let txt = await contract.accountBalance();
    let balanceNumber = txt.toNumber();
    //let tokenDecimals = await contract.decimals();
    console.log(balanceNumber);
    setAccBalance("" + balanceNumber);
  };
  const DepositBalance = async (e) => {
    e.preventDefault();
    let depositAmount = e.target.depositAmount.value;
    let txt = await contract.deposit({
      value: depositAmount,
    });
  };
  const transferHandler = async (e) => {
    e.preventDefault();
    let transferAmount = e.target.sendAmount.value;
    let recieverAddress = e.target.recieverAddress.value;
    let txt = await contract.transferEther(recieverAddress, transferAmount);
    setTransferHash("Transfer confirmation hash: " + txt.hash);
  };
  const WithdrawBalance = async (e) => {
    e.preventDefault();
    let withdrawAmount = e.target.withdrawAmount.value;
    let txt = await contract.withdraw(withdrawAmount);
    console.log(txt);
  };

  return (
    <div>
      <h2>
        {" "}
        Bank Dapp- Create Account,Check Account,Check Balance,Transfer and
        Deposit{" "}
      </h2>
      <button className={styles.button6} onClick={connectWalletHandler}>
        {connButtonText}
      </button>

      <div className={styles.walletCard}>
        <div>
          <h3>Address: {defaultAccount}</h3>
        </div>

        <div>
          <button onClick={AccountBalance}>Account Balance</button>{" "}
          <h3>Balance in the Bank: {accbalance} </h3>
        </div>

        {errorMessage}
      </div>
      <div className={styles.interactionsCard}>
        <div>
          <h4>
            Click here to Create your account. Make sure you are connected to
            Wallet
          </h4>
          <button onClick={createAccount}>CreateAccount</button>
          <h4>Click here to check if your account Exists or not</h4>
          <button onClick={checkAccountExists}>CheckAccountExists</button>
          <h4>Your Account Status</h4> <h5> {checkAcc}</h5>
        </div>
        <form onSubmit={transferHandler}>
          <h3> Transfer money </h3>
          <p> Reciever Address </p>
          <input
            type="text"
            id="recieverAddress"
            className={styles.addressInput}
          />

          <p> Transfer Amount </p>
          <input type="number" id="sendAmount" min="0" step="1" />

          <button type="submit" className={styles.button6}>
            Transfer
          </button>
          <div>{transferHash}</div>
        </form>
        <form onSubmit={DepositBalance}>
          <h3> Deposit Money </h3>
          <p> Deposit Amount </p>
          <input type="number" id="depositAmount" min="0" step="1" />
          <button type="submit" className={styles.button6}>
            Deposit
          </button>
        </form>
        <form onSubmit={WithdrawBalance}>
          <h3> Withdraw Money </h3>
          <p>Withdraw Amount </p>
          <input type="number" id="withdrawAmount" min="0" step="1" />
          <button type="submit" className={styles.button6}>
            Withdraw
          </button>
        </form>
      </div>
    </div>
  );
};

export default BankApp;
