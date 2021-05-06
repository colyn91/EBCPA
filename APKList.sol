pragma solidity ^0.4.23;

contract APKList {
     
	address public manager;
	struct APKlist{
		uint256[2] APK1;
		uint256[2] APK2;
	}
	
    mapping(bytes32 => APKlist) internal apk;
 
 
	event _Submit(address indexed requester);
	event _Check(address indexed requester);
    event _Revoke(address indexed requester);
    function APKList() public {
		manager = msg.sender;
    }
	
	function Submit(uint256[2] APK1, uint256[2] APK2) public returns (address addr){
		require(msg.sender == manager);
		bytes32 index = keccak256(APK1,APK2);
        apk[index].APK1 = APK1;
		apk[index].APK2 = APK2;
		_Submit(msg.sender);
        return msg.sender;
    }	

    function Check(uint256[2] APK1, uint256[2] APK2) public view returns (bool result) {
		bytes32 index = keccak256(APK1,APK2);
		if(apk[index].APK1[0] == APK1[0] && apk[index].APK1[1] == APK1[1] && apk[index].APK2[0] == APK2[0]  && apk[index].APK2[1] == APK2[1])
		{
			return true;
		}
		_Check(msg.sender);
        return false;
    }
	
	function Revoke(uint256[2] APK1, uint256[2] APK2) public{
		require(msg.sender == manager);		
        bytes32 index = keccak256(APK1,APK2);
		if(apk[index].APK1[0] == APK1[0] && apk[index].APK1[1] == APK1[1] && apk[index].APK2[0] == APK2[0]  && apk[index].APK2[1] == APK2[1])
		{
			delete apk[index];
		}
		_Revoke(msg.sender);
    }
    
}

