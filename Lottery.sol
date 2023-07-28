// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable [] public players;
    address payable public winner;

    constructor(){
        manager=msg.sender;
    }

    function participate() public payable {
        require(msg.value==1 ether,"NOT ENOUGH FUNDS");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function random() internal view returns (uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
    }
    function pickWinner() public {
        require(msg.sender==manager,"Only the manager can provote that ");
        require(players.length>0,"Not enough participants");
        uint r=random();
        uint index=r%players.length;
        winner=players[index];
        winner.transfer(getBalance());
        }
    function initialize() public {
        require(msg.sender==manager,"Only the manager can provote that ");
        require(players.length>0,"Not enough participants");
        players=new address payable [](0);
    }
}