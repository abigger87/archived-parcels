// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

/// @title Multicall
/// @notice Adapted from MakerDAO's Multicall
/// @dev https://github.com/makerdao/multicall
/// @author andreas@nascent.xyz
contract Multicall {

  /// >>>>>>>>>>>>>>>>>>>>>  CUSTOM STRUCTS  <<<<<<<<<<<<<<<<<<<<<< ///

  /// @notice A Single Call
  struct Call {
    address target;
    bytes callData;
    bool requireSuccess;
  }

  /// @notice A call result
  struct Result {
    bool success;
    bytes returnData;
  }

  /// >>>>>>>>>>>>>>>>>>>>>  CUSTOM ERRORS  <<<<<<<<<<<<<<<<<<<<<< ///

  /// @notice Thrown when a call fails
  error UnsuccessfulCall();

  /// >>>>>>>>>>>>>>>>>>>>>>  AGGREGATION  <<<<<<<<<<<<<<<<<<<<<<<< ///

  /// @notice Aggregate calls
  /// @dev Backwards compatibility for Multicall V1
  /// @param calls An array of `Call` objects
  /// @return blockNumber The block number executed on
  /// @return blockHash The block hash executed on
  /// @return returnData An array of return data
  function aggregate(Call[] memory calls) public returns (uint256 blockNumber, bytes32 blockHash, bytes[] memory returnData) {
    blockNumber = block.number;
    blockHash = blockhash(block.number);
    returnData = new bytes[](calls.length);
    for(uint256 i = 0; i < calls.length; i++) {
      (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);
      if (calls[i].requireSuccess && !success) revert UnsuccessfulCall();
      returnData[i] = ret;
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>  HELPER METHODS  <<<<<<<<<<<<<<<<<<<<<< ///

  /// @notice Returns the block hash for the given block number
  /// @param blockNumber The block number
  /// @return blockHash The 32 byte block hash
  function getBlockHash(uint256 blockNumber) public view returns (bytes32 blockHash) {
    blockHash = blockhash(blockNumber);
  }

  /// @notice Returns the block number
  /// @return blockNumber The 32 byte (256 bits) unsigned block number
  function getBlockNumber() public view returns (uint256 blockNumber) {
    blockNumber = block.number;
  }

  /// @notice Returns the block coinbase
  /// @return coinbase The 20 byte coinbase address
  function getCurrentBlockCoinbase() public view returns (address coinbase) {
    coinbase = block.coinbase;
  }

  /// @notice Returns the block difficulty
  /// @return difficulty The 32 byte (256 bits) unsigned block difficulty
  function getCurrentBlockDifficulty() public view returns (uint256 difficulty) {
    difficulty = block.difficulty;
  }

  /// @notice Returns the block gas limit
  /// @return gaslimit The 32 byte (256 bits) unsigned block gas limit
  function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
    gaslimit = block.gaslimit;
  }

  /// @notice Returns the block timestamp
  /// @return timestamp The 32 byte (256 bits) unsigned block timestamp
  function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
    timestamp = block.timestamp;
  }

  /// @notice Returns the (ETH) balance of a given address
  /// @return balance The 32 byte (256 bits) unsigned balance
  function getEthBalance(address addr) public view returns (uint256 balance) {
    balance = addr.balance;
  }

  /// @notice Returns the block hash of the last block
  /// @return blockHash The 32 byte last block hash
  function getLastBlockHash() public view returns (bytes32 blockHash) {
    blockHash = blockhash(block.number - 1);
  }
}
