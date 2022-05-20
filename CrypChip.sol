//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";

/// This contract handles the main logic for CrypChip
contract CrypChip {

    using Counters for Counters.Counter;
    Counters.Counter private gIds;
    Counters.Counter private eIds;

    enum ExpenseStatus {
        ACTIVE,
        ONGOING,
        SETTLED
    }

    struct ExpenseGroup {
        uint gId;
        address owner;
        address[] participants;
    }

    struct Expense {
        uint gId;
        uint eId;
        address payer;
        address creator;
        uint totalExpense;
        address[] participants;
        ExpenseStatus status;
        mapping(address => uint) balances;
        mapping(address => bool) settled;
    }

    mapping(uint => ExpenseGroup) groups;
    mapping(uint => Expense) expenses;
    mapping(uint => uint[]) groupExpenses;
    mapping(address => ExpenseGroup[]) expenseGroups;

    function createGroup(address[] memory participants) public returns(bool){

        //Generating a group ID every time a new group is created
        gIds.increment();
        uint id = gIds.current();

        //Create a new group
        ExpenseGroup storage newGroup = groups[id];
        newGroup.gId = id;
        newGroup.owner = msg.sender;
        newGroup.participants = participants;

        //Mapping groups to a user
        expenseGroups[msg.sender].push(newGroup);

        return true;
    }


    function addExpense(uint _gId, address _payer, uint _totalExpense, address[] memory _participants) public {
        require(groups[_gId].gId != 0, "Group doesn't exist");
        require(_payer != address(0), "Payer cannot be zero address");
        require(_totalExpense > 0, "Total expenses should be greater than 0");
        require(_participants. length > 0, "Number of participants to split with, cannot be zero");

        //Generating a expense ID every time a new expense is created
        eIds.increment();
        uint id = eIds.current();
        Expense storage newExpense = expenses[id];
        newExpense.gId = _gId;
        newExpense.eId = id;
        newExpense.payer = _payer;
        newExpense.creator = msg.sender;
        newExpense.totalExpense = _totalExpense;
        newExpense.participants = _participants;
        newExpense.status = ExpenseStatus.ACTIVE;

        //Create mappings of users and their balances
        uint numParticipants = _participants.length;
        uint expensePerPerson;
        unchecked {
            expensePerPerson = _totalExpense/numParticipants;
        }
        
        //Populating the balances and the user mapping
        for(uint i = 0; i < numParticipants; i++){
            newExpense.balances[_participants[i]] = expensePerPerson;
        }


        //Mapping the expenses of a group
        groupExpenses[_gId].push(id);

        //Mapping the expense groups an individual has created


    }

}
