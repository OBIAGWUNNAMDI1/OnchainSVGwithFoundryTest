// SPDX-License-Identifier: MIT
/// @title A crowdfunding project deployed on RinkebyNetwork that uses ether.
///The contract will be able to create fundraisers, let people donate and payout the money raised to the project creator

pragma solidity 0.8.13;
import "./IERC20.sol";

import "./Project.sol";
contract CrowdFund{
    ProjectCreated[] private projects;
    event ProjectStarted(
        address contractAddress,
        address creator,
        string title,
        uint256 goalamount,
        uint256 deadline
    );
    struct createdProject{
        uint256 goalAmount;
        string projectName;
        uint256 fundsRaisingDeadline;
    }
    uint256 projectnumbers;
    mapping(uint => createdProject) projectList;

    function startProject(createdProject memory pr)public{
        createdProject storage prs = projectList[projectnumbers];
        prs.goalAmount = pr.goalAmount;
        prs.fundsRaisingDeadline = block.timestamp + 5 days;
        prs.fundsRaisingDeadline = pr.fundsRaisingDeadline;
        prs.projectName = pr.projectName;
        projectnumbers++;

        //emitted events 
        emit ProjectStarted(
        address(this),
        msg.sender,
        prs.projectName,
        prs.goalAmount,
        prs.fundsRaisingDeadline);
    }
    function getCreatedProjects(uint index) external view returns(createdProject[] memory cp){
        assert(projectnumbers <= index);
        cp = new createdProject[](index);
        for(uint256 i = 0 ; i < index; i++){
            cp[i] = projectList[i];
        }

    }
}








  
  




