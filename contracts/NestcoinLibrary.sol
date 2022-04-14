// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

contract Filestorage {
    string public name;
    uint256 countPublic = 0;
    uint256 countPrivate = 0;

    enum Status {
        Public,
        Private
    }

    //struct for public file
    struct Publicfile {
        uint256 count;
        address owner;
        string ipfsHash;
        Status status;
    }

    //struct for private file
    struct Privatefile {
        uint256 count;
        string ipfsHash;
        Status status;
    }
    //struct for shared file
    struct SharedFile {
        address shared_by;
        string shared_hash;
    }
    //mapping of public files
    mapping(uint256 => Publicfile) public publicfiles;
    //mapping of internal private files
    mapping(uint256 => Privatefile) internal privatefiles; //address
    mapping(address => SharedFile) public shared_files;

    //an event for when a file is created by the owner
    event FileCreation(
        uint256 count,
        address owner,
        string Hash,
        Status status
    );

    //the FileStorage name is created using the constructor
    constructor(string memory _name) {
        name = _name;
    }

    //add files to FileStorage
    function addFile(string memory _hash, string memory _status) public {
        //check if status of file added is Public.
        if (
            keccak256(abi.encodePacked(_status)) ==
            keccak256(abi.encodePacked("public"))
        ) {
            //increment countPublic
            countPublic++;
            publicfiles[countPublic] = Publicfile(
                countPublic,
                msg.sender,
                _hash,
                Status.Public
            );
            //emit event FileCreation has been added to publicfile
            emit FileCreation(countPublic, msg.sender, _hash, Status.Public);
        } else {
            //increment countPrivate
            countPrivate++;
            privatefiles[countPrivate] = (
                Privatefile(countPrivate, _hash, Status.Private)
            );
            //emit event FileCreation has been added to privatefile
            emit FileCreation(countPrivate, msg.sender, _hash, Status.Private);
        }
    }

    // Retrieve public files
    function retrievePublicFile() public view returns (Publicfile[] memory) {
        Publicfile[] memory public_files = new Publicfile[](countPublic);
        for (uint256 i = 0; i < countPublic; i++) {
            Publicfile storage public_file = publicfiles[i];
            public_files[i] = public_file;
        }
        return public_files;
    }

    //retrieve private file
    function retrievePrivateFile(address _address)
        public
        view
        returns (Privatefile[] memory)
    {
        require(
            _address == msg.sender,
            "You do not have Access to retrieve this file"
        );

        Privatefile[] memory private_files = new Privatefile[](countPrivate);
        for (uint256 i = 0; i < countPrivate; i++) {
            Privatefile storage private_file = privatefiles[i];
            private_files[i] = private_file;
        }
        return private_files; //[msg.sender]
    }

    //share files to address not owned by the account(0)
    function shareFile(address _addressTo, string memory _hashed_file) public {
        require(_addressTo != address(0), "Actual address is required");
        require(_addressTo != msg.sender, "Actual address is required");
        shared_files.push(SharedFile(msg.sender, _hashed_file));
        //_share_to                     //_share_to
    }

    //fectch shared files
    function getSharedFile(address _address)
        public
        returns (SharedFile[] memory)
    {
        return shared_files[msg.sender];
    }
}
