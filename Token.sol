// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20{
//Getters (não altera variável, apenas lê e retorna)    
    // Retorna a quantidade de tokens que há
    function totalSupply() external view returns(uint256);
    // Retorna a quantidade de tokens na carteira
    function balanceOf(address tokenOwner) external view returns(uint256);
    //Permite gastar os tokens
    function allowance(address owner, address spender)  external view returns(uint256); 
    
//Functions
    // Função para transferir tokens
    function transfer(address recipient, uint256 amount) external returns(bool);
    // Função para ver se foi autorizado ou não a transferência/gasto
    function approve(address spender, uint256 amount) external returns(bool);
    //Função de Transferir Para
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
//ab

contract Token is IERC20{
    string public constant name = "It's the Coin";
    string public constant symbol = "THECOIN";
    uint8 public constant decimals = 18;

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;

    uint256 public constant totalSupply_ = 1 ether;

    constructor() {
        balances[msg.sender] = totalSupply_;
    } 

    function totalSupply() public override pure returns (uint256){
        return totalSupply_;

    }

    function balanceOf(address tokenOwner) public override view returns(uint256){
        return balances[tokenOwner]; 
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool){
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address spender, uint256 numTokens) public override returns (bool){
        allowed[msg.sender][spender] = numTokens;
        emit Approval(msg.sender, spender, numTokens);
        return true;
    }

    function allowance(address owner, address spender) public override view returns (uint256){
        return allowed[owner][spender];
    }

    function transferFrom(address sender, address recipient, uint256 numTokens) public override returns(bool){
        require(numTokens <= balances[sender], "Insufficient balance");
        require(numTokens <= allowed[sender][msg.sender], "Allowance exceeded");

        balances[sender] = balances[sender]-numTokens;
        allowed[sender][msg.sender] = allowed[sender][msg.sender]-numTokens;
        balances[recipient] = balances[recipient]+numTokens;
        emit Transfer(sender, recipient, numTokens);
        return true;
    }

}