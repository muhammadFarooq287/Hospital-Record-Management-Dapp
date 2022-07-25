// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./3_Doctor.sol";

/*
*@Author Muhammad Farooq
*@Date 22 JULY 2022
*@title Decentralized Hospital Management System
*@dev
*/
contract Patient is Doctor
{
    function viewData()
        external view returns
        (patientRegistry memory)
    {
        require(patientDetails[msg.sender].patientAddress == msg.sender, "Unregistered Patient.")
        return(patientDetails[msg.sender]);
    }
}
