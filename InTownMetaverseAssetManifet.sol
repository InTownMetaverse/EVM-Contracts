/**
 *Submitted for verification at Etherscan.io on 2023-07-07
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IInTownMetaverseLand {
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract InTownMetaverseAssetManifest{
    
    struct Asset {
        string integrity;
        string filename;
        string cid;
        string experienceId;
        address owner;
        string[] categories;
        string[] tags;
        bool exists;
    }

    struct BuildingAsset {
        uint256 asset;
        string positionx;
        string positiony;
        string positionz;
        string rotationx;
        string rotationy;
        string rotationz;
        string scale;
        string[] components;
        bool exists;
    }

    struct GameAsset {
        uint256 asset;
        address owner;
        string experienceId;
        bool exists;
    }

    struct Building {
        address owner;
        string experienceId;
        BuildingAsset[] buildingAssets;
        bool exists;
    }

    struct Plot {
        uint256 interiorBuilding;
        uint256 exteriorBuilding;
        uint256 plotId;
        address owner;
    }

    address private landContractAddr;

    address payable public Owner;

    uint256 private minRequired = 0.000000001 * 1 ether;

    // set the owner to the msg.sender 
    constructor () { 
        Owner = payable(msg.sender);
    }

    Asset[] private assetManifest;
    GameAsset[] private gameAssetManifest;
    Building[] private buildingManifest;
    Plot[] private plotManifest;


    function setLandContractAddr(address _landContractAddr) public onlyOwner {
       landContractAddr = _landContractAddr;
    }

    function registerAsset(Asset calldata asset) payable external {

        uint256 amount = msg.value;
        
        require(amount > minRequired, "1");

        assetManifest.push(
            asset
        );
    }

    function getAllAssets() public view returns (Asset[] memory){
          Asset[] memory assetArray = new Asset[](assetManifest.length);

            for (uint i = 0; i < assetManifest.length; i++) {
                assetArray[i] = assetManifest[i];
            }

        return assetArray;
    }

    function getAssetById(uint256 id) public view returns (Asset memory){
        return assetManifest[id];
    }

    function updateAssetById(uint256 assetId, Asset memory newAsset) public payable {
        uint256 amount = msg.value;
            
        require(amount > minRequired, "1");

        require(assetManifest[assetId].exists, "2");

        if (msg.sender != assetManifest[assetId].owner) {
            revert("3");
        }

        assetManifest[assetId] = newAsset;
    }

    function deleteAssetById(uint256 assetId) public payable {
        uint256 amount = msg.value;
                
        require(amount > minRequired, "1");

        require(assetManifest[assetId].exists, "2");

        if (msg.sender != assetManifest[assetId].owner) {
            revert("3");
        }

        delete assetManifest[assetId];
    }

    function assignBuildingToPlot(uint256 plotId, uint256 interior, uint256 exterior) payable public {
        uint256 amount = msg.value;

        require(amount > minRequired, "1");

        require(buildingManifest[interior].exists, "4");
        require(buildingManifest[exterior].exists, "4");

        require(buildingManifest[interior].owner == msg.sender, "5");
        require(buildingManifest[exterior].owner == msg.sender, "5");

        
        address plotOwner = IInTownMetaverseLand(landContractAddr).ownerOf(plotId);

        require(msg.sender == plotOwner, "6");

        plotManifest.push(
            Plot(interior, exterior, plotId, plotOwner)
        );
    }

    function getAllPlots() public view returns (Plot[] memory){
          Plot[] memory plotArray = new Plot[](plotManifest.length);

            for (uint i = 0; i < plotManifest.length; i++) {
                plotArray[i] = plotManifest[i];
            }

        return plotArray;
    }

    function getPlotById(uint256 id) public view returns (Plot memory){
        return plotManifest[id];
    }

    function registerBuilding(Building calldata building) payable public {
        uint256 amount = msg.value;
        
        require(amount > minRequired, "1");

        buildingManifest.push(
            building
        );
    }

    function getAllBuildings() public view returns (Building[] memory){
          Building[] memory buildingArray = new Building[](buildingManifest.length);

            for (uint i = 0; i < buildingManifest.length; i++) {
                buildingArray[i] = buildingManifest[i];
            }

        return buildingArray;
    }

    function getBuildingById(uint256 id) public view returns (Building memory){
        return buildingManifest[id];
    }

    function updateBuildingById(uint256 buildingId, Building calldata newBuilding) public payable {
        uint256 amount = msg.value;
        
        require(amount > minRequired, "1");
        
        require(buildingManifest[buildingId].exists, "4");

        if (msg.sender != buildingManifest[buildingId].owner) {
            revert("7");
        }

        buildingManifest[buildingId] = newBuilding;
    }

    function deleteBuildingById(uint256 buildingId) public payable {
        uint256 amount = msg.value;
        
        require(amount > minRequired, "1");
        
        require(buildingManifest[buildingId].exists, "4");

        if (msg.sender != buildingManifest[buildingId].owner) {
            revert("7");
        }

        delete buildingManifest[buildingId];
    }


    function registerGameAsset(GameAsset calldata gameAsset) public {
        gameAssetManifest.push(
            gameAsset
        );
    }

    function getAllGameAssets() public view returns (GameAsset[] memory){
          GameAsset[] memory gameAssetArray = new GameAsset[](gameAssetManifest.length);

            for (uint i = 0; i < assetManifest.length; i++) {
                gameAssetArray[i] = gameAssetManifest[i];
            }

        return gameAssetArray;
    }

    function updateGameAssetById(uint256 gameAssetId, GameAsset memory newGameAsset) public payable {
    
        require(gameAssetManifest[gameAssetId].exists, "11");

        if (msg.sender != gameAssetManifest[gameAssetId].owner) {
            revert("12");
        }

        gameAssetManifest[gameAssetId] = newGameAsset;
    }

    function deleteGameAssetById(uint256 gameAssetId) public {
    
        require(gameAssetManifest[gameAssetId].exists, "11");

        if (msg.sender != gameAssetManifest[gameAssetId].owner) {
            revert("12");
        }

        delete gameAssetManifest[gameAssetId];
    }

    modifier onlyOwner () {
        require(msg.sender == Owner, "13"); 
        _;
    }

    function withdraw (uint _amount) public onlyOwner { 
        Owner.transfer(_amount); 
    }
}