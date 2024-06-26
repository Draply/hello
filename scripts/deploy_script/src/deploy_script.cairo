use sncast_std::{
    declare, deploy, invoke, call, DeclareResult, DeployResult, InvokeResult, CallResult, get_nonce, DisplayContractAddress, DisplayClassHash
};

// The example below uses a contract deployed to the Goerli testnet
fn main() {
    let max_fee = 99999999999999999;
    let salt = 0x3;

    let declare_result = declare("Map", Option::Some(max_fee), Option::None).expect('contract already declared');
    let nonce = get_nonce('latest');
    let class_hash = declare_result.class_hash;

    println!("Class hash of the declared contract: {}", declare_result.class_hash);

    let deploy_result = deploy(
        class_hash, ArrayTrait::new(), Option::Some(salt), true, Option::Some(max_fee), Option::Some(nonce)
    ).expect('deploy failed');

    println!("Deployed the contract to address: {}", deploy_result.contract_address);

    let invoke_nonce = get_nonce('pending');
    let invoke_result = invoke(
        deploy_result.contract_address, selector!("increase_balance"), array![0x42], Option::Some(max_fee), Option::Some(invoke_nonce)
    ).expect('invoke failed');
    println!("Invoke tx hash is: {}", invoke_result.transaction_hash);

    let call_result = call(deploy_result.contract_address, selector!("get_balance"), array![]).expect('call failed');

    println!("Call result: {}", call_result);
    assert(call_result.data == array![0x42], *call_result.data.at(0));
}
    
}
