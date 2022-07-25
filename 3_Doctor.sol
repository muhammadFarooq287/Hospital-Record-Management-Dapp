// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./2_Receptionist.sol";

/*
*@Author Muhammad Farooq
*@Date 22 JULY 2022
*@title Decentralized Hospital Management System
*@dev
*/

contract Doctor is Receptionist
{
    /**
    *
    *@dev Modifier used to check that the sender of function is 
    *     whether verified Doctor or not.
    *
    */

    modifier isVerifiedDoctor()
    {
        require(drDetails[msg.sender].verified, "Unregistered Doctor");
        _;
    }

    /*
    *@dev To attend a patient and update its treatment.
    *
    *@requirement Only verified and assigned Doctor can attend the patient.
    *
    *@param Patient's Address who has to be attended and Treatment Suggested by Doctor.
    */

    function attendedPatient(
        address _patientAddress,
        string memory _treatment
        ) external
        isVerifiedDoctor
    {    
        require((patientDetails[_patientAddress].registrationFeePaid)&&(patientDetails[_patientAddress].doctorAssigned == msg.sender),"Outstanding Dues or Unassigned Dr.");
        patientDetails[_patientAddress].treatment = _treatment; 

    }

    /*
    *@dev To Refer a patient to other Doctor.
    *
    *@requirement Only verified and assigned Doctor can Refer the patient.
    *
    *@param Patient's Address who has to be Referred and address of Doctor who'll attend him.
    */

    function referPatient(
        address _patientAddress,
        address _toDoctoraddress)
        external isVerifiedDoctor
    {
        require((_toDoctoraddress == drDetails[_toDoctoraddress].drAddress)&&(patientDetails[_patientAddress].doctorAssigned == msg.sender),"No such Dr or Unassigned Dr");
        patientDetails[_patientAddress].doctorAssigned = _toDoctoraddress;
    }

    /*
    *@dev To View Patient's Details
    *
    *@requirement Only verified Doctor can view Patient's Data
    *
    *@param Patient's address
    */

    function viewPatientDetails(
        address _patientAddress
    ) external view isVerifiedDoctor
    returns(patientRegistry memory)
    {
        return(patientDetails[_patientAddress]);
    }
}
