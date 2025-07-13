// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title NFTCollateralLoan
/// @notice Simple NFT-backed loan contract
contract NFTCollateralLoan is Ownable {
    /// @notice The ERC20 token to be lent to borrowers
    ERC20 public immutable loanToken;

    /// @notice The accepted NFT collection for collateral
    IERC721 public immutable collateralNFT;

    /// @notice Records which borrower deposited which NFT
    mapping(uint256 => address) public collateralOwner;

    /// @notice Constructor sets the loan token and collateral NFT
    constructor(address _loanToken, address _collateralNFT) Ownable(msg.sender) {
        require(_loanToken != address(0), "Invalid loan token");
        require(_collateralNFT != address(0), "Invalid NFT collection");

        loanToken = ERC20(_loanToken);
        collateralNFT = IERC721(_collateralNFT);
    }

    /**
     * @notice Deposit an NFT as collateral and receive loan tokens
     * @param tokenId The ID of the NFT to deposit
     * @param loanAmount The amount of loan tokens to receive
     */
    function depositAndBorrow(uint256 tokenId, uint256 loanAmount) external {
        require(loanAmount > 0, "Loan amount must be > 0");

        // Transfer NFT from borrower to this contract
        collateralNFT.transferFrom(msg.sender, address(this), tokenId);

        // Record that this NFT belongs to this borrower
        collateralOwner[tokenId] = msg.sender;

        // Transfer loan tokens to borrower
        require(loanToken.transfer(msg.sender, loanAmount), "Token transfer failed");
    }

    /**
     * @notice Repay the loan and withdraw the NFT collateral
     * @param tokenId The ID of the NFT to withdraw
     * @param repayAmount The amount to repay
     */
    function repayAndWithdraw(uint256 tokenId, uint256 repayAmount) external {
        address borrower = collateralOwner[tokenId];
        require(borrower != address(0), "NFT not collateralized");
        require(borrower == msg.sender, "Not the borrower");
        require(repayAmount > 0, "Repay amount must be >0");

        // Transfer repayment tokens from borrower to contract
        require(loanToken.transferFrom(msg.sender, address(this), repayAmount), "Repayment failed");

        // Clear collateral ownership record
        collateralOwner[tokenId] = address(0);

        // Transfer NFT back to borrower
        collateralNFT.transferFrom(address(this), msg.sender, tokenId);
    }

    /**
     * @notice Liquidate NFT collateral if the borrower fails to repay
     * @param tokenId The ID of the NFT to liquidate
     */
    function liquidate(uint256 tokenId) external {
        address borrower = collateralOwner[tokenId];
        require(borrower != address(0), "NFT not collateralized");

        // Clear the record
        collateralOwner[tokenId] = address(0);

        // Transfer the NFT to the caller (the liquidator)
        collateralNFT.transferFrom(address(this), msg.sender, tokenId);
    }
}
