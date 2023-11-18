// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Smartevent{
 struct Event{
    address oraganizer;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;
 }

 mapping(uint=>Event) public events;
 mapping(address=>mapping(uint=>uint)) public tickets;
 uint public nextId;

 function createEvent(string memory name,uint date,uint price,uint ticketCount) external {
    require(date>block.timestamp,"Can organise event further");
    require(ticketCount>0,"You can Organise the Event");

    events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
    nextId++;
 }

 function buytickets(uint id ,uint quantity)external payable{
    require(events[id].date!=0,"This Event Does not exist");
    require(block.timestamp<events[id].date,"Event has already doen!!");
    Event storage _event =events[id];
    require(msg.value==(_event.price*quantity),"Amount is not enough");
    require(_event.ticketRemain >= quantity,"Not Enough tickets");
    _event.ticketRemain-=quantity; 
    tickets[msg.sender][id]+=quantity;

 }

 function tansferticket(uint id,uint quantity,address person) external {
    require(events[id].date!=0,"This Event Does not exist");
    require(block.timestamp<events[id].date,"Event has already doen!!");
    require(tickets[msg.sender][id]>=quantity,"Don't have enough ticekts");
    tickets[msg.sender][id]-=quantity;
    tickets[person][id]+=quantity;
 }
}