// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
// import {console} from  "./utils/console.sol";
// import "./utils/cheat.sol";
// import "../CrowdFunding.sol";
// import "../IERC20.sol";


// contract ContractTest is DSTest {
//     CheatCodes internal constant cheat = CheatCodes(HEVM_ADDRESS);
//     CrowdFund public fund;
//     ProjectCreated public project;
//     IERC20 token ;
//     address payable creator = payable (0xC02cc6235f43D9e51143B5ec1Bb12f2Fa7BB6B7a);
//     address Theta = 0x3883f5e181fccaF8410FA61e12b59BAd963fb645;
//     // struct createdProject{
//     //     uint256 goalAmount = 30000000000000000000000;
//     //     string projectName = "newProject";
//     //     uint256 fundRaisingDeadline = 1650964006;
//     // }
//     struct createdProject{
//         uint256 goalAmount;
//         string projectName;
//         uint256 fundRaisingDeadline;

//     }
//     function setUp() public {
//         fund = new CrowdFund();
//         project = new ProjectCreated(creator, "newProject");
//         token =  IERC20(Theta);

//     }
    
//     function testCrowdCreation() public {
//         cheat.startPrank(creator);
//         CrowdFund.createdProject memory i_;
//         i_.goalAmount = 200000;
//         i_.projectName = "newProject";
//         i_.fundsRaisingDeadline = 20000000000;
//         fund.startProject(i_);
//         bytes32 ip = bytes32(abi.encodePacked(i_.projectName));
//         bytes32 com = bytes32(abi.encodePacked("newProject")); 
//         assertEq(ip ,com);
//         cheat.stopPrank(creator);
//     }
//     uint256 projectnumbers;
//     function testNumberofCreatedProject() public {
//         fund.getCreatedProjects(0);
//     }
//     address contributor = 0x2d56dEf1e86b8Ae36F9545F1FD65Bd8cbD1Befef;

//     function testforFundsContributed public {
//         cheat.startPrank(contributor);
//         token.allowance(contributor, address(this));
//         token .approve(address(this), "3000000000000000000000");
//         fund.contributeFunds(2000000000000000000000)

//     }
// }
