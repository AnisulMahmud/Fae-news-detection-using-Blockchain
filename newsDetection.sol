// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

contract newsDetection {
    address public admin;
    uint256 newsCount;
    uint256 peopleCount;
    bool start;
    bool end;

    constructor()  {
        // Initilizing default values
        admin = msg.sender;
        newsCount = 0;
        peopleCount = 0;
        start = false;
        end = false;
    }

    function getAdmin() public view returns (address) {
        // Returns account address used to deploy contract (i.e. admin)
        return admin;
    }

    modifier onlyAdmin() {
        // Modifier for only admin access
        require(msg.sender == admin);
        _;
    }
    // Modeling a news
    struct News{
        uint256 newsId;
        string header;
        uint256 voteCount;
    }
    mapping(uint256 => News) public newsDetails;

    // Adding new newss
    function addNews(string memory _header)
        public
        // Only admin can add
        onlyAdmin
    {
        News memory newNews=
            News({
                newsId: newsCount,
                header: _header,
                voteCount: 0
            });
        newsDetails[newsCount] = newNews;
        newsCount += 1;
    }

    // Modeling a newsDetection Details
    struct newsDetectionDetails {
        string adminName;
      //  string adminEmail;
      //  string adminTitle;
        string newsDetectionTitle;
       // string organizationTitle;
    }
    newsDetectionDetails newsdetectionDetails;

    function setnewsDetectionDetails(
        string memory _adminName,
       // string memory _adminEmail,
       // string memory _adminTitle,
        string memory _newsDetectionTitle
       // string memory _organizationTitle
    )
        public
        // Only admin can add
        onlyAdmin
    {
        newsdetectionDetails = newsDetectionDetails(
            _adminName,
         //   _adminEmail,
         //   _adminTitle,
            _newsDetectionTitle
         //   _organizationTitle
        );
        start = true;
        end = false;
    }

    // Get newsDetections details
    function getAdminName() public view returns (string memory) {
        return newsdetectionDetails.adminName;
    }

    function getnewsDetectionTitle() public view returns (string memory) {
        return newsdetectionDetails.newsDetectionTitle;
    }


    // Get newss count
    function getTotalnews() public view returns (uint256) {
        // Returns total number of newss
        return newsCount;
    }

    // Get Peoples count
    function getTotalPeople() public view returns (uint256) {
        // Returns total number of Peoples
        return peopleCount;
    }

    // Modeling a People
    struct People {
        address PeopleAddress;
        string name;
        string phone;
        bool isVerified;
        bool hasVoted;
        bool isRegistered;
    }
    address[] public Peoples; // Array of address to store address of Peoples
    mapping(address => People) public PeopleDetails;

    // Request to be added as People
    function registerAsPeople(string memory _name, string memory _phone) public {
        People memory newPeople =
            People({
                PeopleAddress: msg.sender,
                name: _name,
                phone: _phone,
                hasVoted: false,
                isVerified: false,
                isRegistered: true
            });
        PeopleDetails[msg.sender] = newPeople;
        Peoples.push(msg.sender);
        peopleCount += 1;
    }

    // Verify People
    function verifyPeople(bool _verifedStatus, address PeopleAddress)
        public
        // Only admin can verify
        onlyAdmin
    {
        PeopleDetails[PeopleAddress].isVerified = _verifedStatus;
    }

    // Vote
    function vote(uint256 newsId) public {
        require(PeopleDetails[msg.sender].hasVoted == false);
        require(PeopleDetails[msg.sender].isVerified == true);
        require(start == true);
        require(end == false);
        newsDetails[newsId].voteCount += 1;
        PeopleDetails[msg.sender].hasVoted = true;
    }

    // End newsDetection
    function endnewsDetection() public onlyAdmin {
        end = true;
        start = false;
    }

    // Get newsDetection start and end values
    function getStart() public view returns (bool) {
        return start;
    }

    function getEnd() public view returns (bool) {
        return end;
    }
}