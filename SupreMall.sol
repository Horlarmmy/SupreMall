// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract SupreMall {

    uint internal productsLength = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Product {
        address payable owner;
        string name;
        string image;
        string description;
        string location;
        uint price;
        uint sold;
    }

    struct ProductBought {
        Product products;
        uint product_id;
    }

    mapping (uint => Product) internal products;
    mapping (address => ProductBought[]) public product_bought;

    function writeProduct(
        string memory _name,
        string memory _image,
        string memory _description, 
        string memory _location, 
        uint _price
    ) public {
        uint _sold = 0;
        products[productsLength] = Product(
            payable(msg.sender),
            _name,
            _image,
            _description,
            _location,
            _price,
            _sold
        );
        productsLength++;
    }

    function readProduct(uint _index) public view returns (
        address payable,
        string memory, 
        string memory, 
        string memory, 
        string memory, 
        uint, 
        uint
    ) {
        return (
            products[_index].owner,
            products[_index].name, 
            products[_index].image, 
            products[_index].description, 
            products[_index].location, 
            products[_index].price,
            products[_index].sold
        );
    }

    function buyProduct(uint _index) public  {
        ProductBought memory new_product = ProductBought(products[_index], _index);
        products[_index].sold++;
        product_bought[msg.sender].push(new_product);
    }

   function returnProduct(uint _index) public returns (bool) {
        for (uint i=0; i<product_bought[msg.sender].length; i++) {
            if (_index == product_bought[msg.sender][i].product_id) {
                products[_index].sold--;
                //struct element = product_bought[msg.sender][i];
                product_bought[msg.sender][i] = product_bought[msg.sender][product_bought[msg.sender].length - 1];
                delete product_bought[msg.sender][product_bought[msg.sender].length - 1];
            } else {
                return false;
            }
        }

    }
    
    function getProductsLength() public view returns (uint) {
        return (productsLength);
    }
}
