// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.5;

contract Filestorage {
    string public name;
    uint countPublic = 0;
    uint countPrivate = 0;
    
    enum Status { Public, Private }
    
    struct Publicfile {
        uint count;
        address owner;
        string ipfsHash;
        Status status;
    }
     struct Privatefile {
        uint count;
        string ipfsHash;
        Status status;
    }

    struct sharedFile {
        address shared_by;
        string shared_hash;
    }

    mapping (uint => Publicfile) public publicfiles;
    mapping (address => Privatefile[]) public privatefiles;
    mapping (address => sharedFile[]) public shared_files;

    event FileCreation ( uint count, address owner, string Hash, Status status);

    constructor (string memory _name) {
        name = _name;
    }

    function addFile ( string memory _hash, string memory _status ) public {
      if(keccak256(abi.encodePacked(_status)) == keccak256(abi.encodePacked("public"))) {
            countPublic ++;
            publicfiles[countPublic] = Publicfile( countPublic, msg.sender, _hash, Status.Public);
            emit FileCreation(countPublic, msg.sender, _hash, Status.Public );
        }
    else {
        countPrivate ++;
        privatefiles[msg.sender].push(Privatefile(countPrivate, _hash, Status.Private ));
        emit FileCreation(countPrivate, msg.sender, _hash, Status.Private );
    }
    }
    
    // Retrieve files
    function retrievePublicFile () public view returns(Publicfile[] memory) {
      Publicfile[] memory public_files = new Publicfile[] (countPublic);
      for(uint i=0; i<countPublic; i++) {
        Publicfile storage public_file = publicfiles[i];
            public_files[i] = public_file;
      }
      return public_files;
  }

  function retrievePrivateFile (address _address) public view returns (Privatefile[] memory) {
      require (address = msg.sender, "You do not have Access to retrieve this file");
      return privatefiles[msg.sender];
  }

  function shareFile ( address _share_to, string memory _hashed_file ) public {
      require( _share_to != address(0), "Actual address is required");
      shared_files[_share_to].push(sharedFile(msg.sender, _hashed_file));
  }

  function getSharedFile(address _address) public returns (sharedFile[] memory) {
      return shared_files[msg.sender];
  }
}