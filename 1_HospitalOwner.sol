// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
*@Author Muhammad Farooq
*@Date 22 JULY 2022
*@title Decentralized Hospital Management System
*@dev
*/

contract HospitalOwner
{
    /**
    *@dev Global Variables used in Mapping.
    *     TO store Doctor's and Recptionist's Total count and Addresses
    *     So that we can display all the data.
    */

    address public owner;
    uint public drCount;
    uint public receptionistCount;
    address[] drAddresses;
    address[] receptionistAddresses;

    struct drRegistry{
        address drAddress;
        string name;
        uint phoneNumber;
        string qualification;
        string specialization;
        string experience;
        string dutyTiming;
        string wardNo;
        bool verified;
    }
  
    struct receptionistRegistry{
        address receptionistAddress;
        string name;
        uint phoneNumber;
        bool verified;
    }

    /**
    *
    *@dev Mapping Used to store DOctor's details, Receptionis's details.
    *
    */

    mapping (address => drRegistry) public drDetails;
    mapping (address => receptionistRegistry) public receptionistDetails;

    /**
    *
    *@dev Events used to produce logs when Doctor or Receptionists are Hired or Removed.
    *
    */ 

    event drHired(address _drAddress, string _Name);

    event drRemoved(address _drAddress, string _Name);

    event receptionistHired(address _receptionistAddress, string _Name);

    event receptionistRemoved(address _receptionistAddress, string _Name);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    /*
    *@dev New Doctor is registered.
    *
    *@Requirement Only the owner of contract can Register Doctor's Details.
    *
    *@param Doctor's Address, Name, Phone Number, Qualification, Specialization,
    *                Experience, Duty Timing, Ward No and Verification (If True,
    *                then He can  perform his operations or functions otherwise Not)
    */

    function registerDoctor(
        address _drAddress,
        string memory _name,
        uint _phoneNumber,
        string memory _qualification,
        string memory _specialization,
        string memory _experience,
        string memory _dutyTiming,
        string memory _wardNo,
        bool _verified)
        external onlyOwner
    {       
        require(_drAddress != address(0),"Enter Dr Public Key");
        require(_drAddress != drDetails[_drAddress].drAddress,"Already Registered");
        drCount++;
        drDetails[_drAddress]=drRegistry(_drAddress, _name, _phoneNumber, _qualification, _specialization, _experience, _dutyTiming, _wardNo, _verified);
        drAddresses.push(_drAddress);
        emit drHired(_drAddress, _name);
    }

    /*
    *@dev Doctor is removed.
    *
    *@Requirement Only the owner of contract can remove Doctor's Details.
    *
    *@param Doctor's Address to be Removed
    */

    function removeDoctor(
        address _drAddress
        ) external onlyOwner
    {       
        drCount--;
        drDetails[_drAddress]=drRegistry(address(0), "", 0, "", "", "", "", "", false);
        emit drRemoved(_drAddress, drDetails[_drAddress].name);
    }

    /*
    *@dev To Get Doctor's Details
    *
    *@param Doctor's Address to get his details
    */

    function getDrDetails(
        address _drAddress)
        external onlyOwner view returns (
        drRegistry memory)
    {
        return drDetails[_drAddress];
    }

    /*
    *@dev To Get All Doctor's Details
    *
    */

    function getAllDrDetails() 
        external view onlyOwner
        returns(
        drRegistry[] memory)
    {
        drRegistry[] memory drArray = new drRegistry[](drCount);
        for (uint i =0; i<drCount; i++)
        {
            drArray[i] = drDetails[drAddresses[i]];
        }
        return (drArray);
    }

    /*
    *@dev New Receptionist will be registered or Hired.
    *
    *@Requirement Only the owner of contract can Register Receptionist's Details.
    *
    *@param Receptionist's Address, Name, Phone Number, Verification (If True, then
    *                      He can  perform his operations or functions otherwise Not)
    */

    function registerReceptionist(
        address _receptionistAddress,
        string memory _name,
        uint _phoneNumber,
        bool _verified) external onlyOwner
    {       
        require(_receptionistAddress != address(0),"Enter receptionist's Public Key");
        require(_receptionistAddress != receptionistDetails[_receptionistAddress].receptionistAddress,"Already Registered");
        receptionistCount++;
        receptionistDetails[_receptionistAddress] = receptionistRegistry(_receptionistAddress, _name, _phoneNumber, _verified);
        receptionistAddresses.push(_receptionistAddress);
        emit receptionistHired(_receptionistAddress, _name);
    }

    /*
    *@dev Receptionist will be removed.
    *
    *@Requirement Only the owner of contract can remove Receptionist's Details.
    *
    *@param Receptionist's Address to be removed
    */

    function removeReceptionist(
        address _receptionistAddress
        ) external onlyOwner
    {       
        receptionistCount--;
        receptionistDetails[_receptionistAddress] = receptionistRegistry(address(0), "", 0, false);
        emit receptionistRemoved(_receptionistAddress, receptionistDetails[_receptionistAddress].name);
    }

    /*
    *@dev To Get Receptionist's Details
    *
    *@param Receptionist's Address to get his details
    */

    function getReceptionistDetails(
        address _receptionistAddress)
        external onlyOwner view returns (
        receptionistRegistry memory)
    {
        return receptionistDetails[_receptionistAddress];
    }

    /*
    *@dev To Get All Receptionists' Details
    *
    */

    function getAllReceptionistDetails() 
        external view onlyOwner
        returns(
        receptionistRegistry[] memory)
    {
        receptionistRegistry[] memory receptionistArray = new receptionistRegistry[](receptionistCount);
        for (uint i =0; i<receptionistCount; i++)
        {
            receptionistArray[i] = receptionistDetails[receptionistAddresses[i]];
        }
        return (receptionistArray);
    }

}
