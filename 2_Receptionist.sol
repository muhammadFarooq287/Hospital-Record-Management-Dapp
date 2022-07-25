// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./1_HospitalOwner.sol";

/*
*@Author Muhammad Farooq
*@Date 22 JULY 2022
*@title Decentralized Hospital Management System
*@dev
*/

contract Receptionist is HospitalOwner
{
    /**
    *@dev Global Variables used in Mapping.
    *     TO store Patient's Total count and Addresses
    *     So that we can display all the data.
    */
    uint public patientCount;
    address[] patientAddresses;


    struct patientRegistry{
        address patientAddress;
        string name;
        uint Age;
        uint phoneNumber;
        string city;
        string state;
        string symptoms;
        address doctorAssigned;
        string treatment;
        bool registrationFeePaid;
    }

    mapping (address => patientRegistry) public patientDetails;

    /**
    *
    *@dev Events used to produce logs when Patients are Registered.
    *     When Registration Feee is paid by the User and Doctor is
    *     Assigned to Patient.
    *
    */

    event patientRegistered(address _patientAddress, string _Name);

    event _regsitrationFeePaid(address _patientAddress, string _Name);

    event _assignDoctor(address _patientAddress, address _drAddress);

    /**
    *
    *@dev Modifier used to check that the sender of function is 
    *     whether verified Receptionist or not.
    *
    */

    modifier isVerifiedReceptionist()
    {
        require(receptionistDetails[msg.sender].verified, "Only verified Receptionist can Register Patient.");
        _;
    }

    /*
    *@dev New Patient is registered.
    *
    *@Requirement Only the verified Receptionist can Register Patient's Details.
    *             Patient shouldn't be already registered.
    *
    *@param Patient's Address, Name, Age, Phone Number, City, State,
    *       Symptoms of Disease(According to these symptoms, Receptionist will assign Doctor to patient).
    */

    function registerPatient(
        address _patientAddress,
        string memory _name,
        uint _Age,
        uint _phoneNumber,
        string memory _city,
        string memory _state,
        string memory _symptoms) external
        isVerifiedReceptionist
    {      
        require(_patientAddress != address(0),"Enter Patient's Public Key");
        require(_patientAddress != patientDetails[_patientAddress].patientAddress,"Already Registered"); 
        patientDetails[_patientAddress].patientAddress = _patientAddress;
        patientDetails[_patientAddress].name = _name;
        patientDetails[_patientAddress].Age = _Age;
        patientDetails[_patientAddress].phoneNumber = _phoneNumber;
        patientDetails[_patientAddress].city = _city;
        patientDetails[_patientAddress].state = _state;
        patientDetails[_patientAddress].symptoms = _symptoms; 
    }

    /*
    *@dev To Get Patient's Details
    *
    *@requirement Only Verified Receptionist can view patient's details
    *
    *@param Patient's Address to get his details
    */

    function getPatientDetails(
        address _patientAddress)
        external isVerifiedReceptionist 
        view returns (
        patientRegistry memory)
    {
        return patientDetails[_patientAddress];
    }

    /*
    *@dev To Get All Patient's Details
    *
    *@requirement Only verified Receptionist can view Patient's Data
    *
    */

    function getAllPatientDetails() 
        external
        isVerifiedReceptionist view
        returns(
        patientRegistry[] memory)
    {
        patientRegistry[] memory patientArray = new patientRegistry[](patientCount);
        for (uint i =0; i<patientCount; i++)
        {
            patientArray[i] = patientDetails[patientAddresses[i]];
        }
        return (patientArray);
    }

    /*
    *@dev To Mark Registration Fee Paid as True. IF false, then Doctor will not Attend this Patient
    *
    *@requirement Only verified Receptionist can Mark Patient's registration Fee as True after receiving payment.
    *
    *@param Patient's Address who paid the Fee
    */

    function registrationFeePaid(
        address _patientAddress)
        external isVerifiedReceptionist
    {
        patientDetails[_patientAddress].registrationFeePaid = true;
        patientAddresses.push(_patientAddress);
        patientCount++;
        emit _regsitrationFeePaid(_patientAddress, patientDetails[_patientAddress].name);
    }

    /*
    *@dev To Assign Doctor's address to Patient, who will attend the Patient.
    *
    *@requirement Only verified Receptionist can Assign Doctor to Patient after reading Symptoms told by patient. 
    *
    *@param Patient's Address to whom Doctor will be Assigned and Doctor's Address who'll be Assigned.
    */

    function assignDoctor(
        address _patientAddress,
        address _drAddress)
        external isVerifiedReceptionist
    {
        patientDetails[_patientAddress].doctorAssigned = _drAddress;
        emit _assignDoctor(_patientAddress, _drAddress);
    }
    
}
