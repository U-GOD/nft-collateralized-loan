# NFT Collateralized Loan

A Solidity smart contract demonstrating how to create a simple NFT-backed lending system. Borrow ERC20 tokens using an ERC721 NFT as collateral, inspired by real-world protocols like NFTfi.

---

## 📖 Overview

This project shows how NFTs can be used as collateral to access liquidity:

- **Borrowers** deposit an NFT into the contract.
- They receive ERC20 loan tokens.
- If they repay, they can reclaim their NFT.
- If they fail to repay, their NFT can be liquidated by anyone.

This example is intentionally minimal for educational purposes.

---

## 🛠 How It Works

### 1. Deploy Contracts

- Deploy an ERC20 token (the loan currency).
- Deploy an ERC721 token (the NFT collateral).
- Deploy `NFTCollateralLoan` providing:
  - The ERC20 contract address.
  - The ERC721 contract address.

---

### 2. Mint and Approve NFTs

- Mint your NFT to your wallet.
- Approve the loan contract to transfer your NFT using:
approve(<NFTCollateralLoan Address>, <Token ID>)


---

### 3. Fund the Loan Contract

- Transfer ERC20 tokens to the loan contract so it has liquidity to lend.

---

### 4. Borrow Tokens

- Call: depositAndBorrow(uint256 tokenId, uint256 loanAmount)

- The NFT is transferred to the contract.
- You receive loan tokens in return.

---

### 5. Repay and Reclaim NFT

- Approve the contract to spend your ERC20 tokens.
- Call:repayAndWithdraw(uint256 tokenId, uint256 repayAmount)

- Your repayment is transferred.
- Your NFT is returned to you.

---

### 6. Liquidation

- If a borrower fails to repay, any address can call: liquidate(uint256 tokenId)

- The NFT will be transferred to the liquidator.

---

---

## ⚠️ Disclaimer

This contract is for demonstration and learning purposes only.  
It has **no production safeguards**, including:

- No loan terms or deadlines.
- No interest calculation.
- No NFT valuation.
- No security audits.

Use at your own risk.

---

## 📝 License

MIT License

---

