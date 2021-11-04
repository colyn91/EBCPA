'use strict';

let apk1s = ['0x68ac7361879fa3eac3e7e97744f4078d0420beaa54c9933e9298ecb8c1552632', '0xc3e61879fa397744f4078d068aea70beaa54155298ecec7342933eb8c326c992', '0xf9afa483e765629a05a2cc88f838a89cbc2cf79dc55d338b4654f197f56e873c', '0x245529b20d085f7a7c1cafba3029869bd857b468213193a317f127037bea08fc', '0xae6b3d878ea7702e7b5a6559ce21a628da126dbfb047784b3ff63c6890091ef6', '0x622728706082abd0410f26f1edc199143d220e2c75b4ecfd00f0f3ac1266021a', '0x23b4b212ce48618cc4989a80813d091147872fa1dadb69b28235e72a1ae34716', '0x2b2f54f21f92a9306a447c68b99056be911021782a331015b06c799bc402f112', '0x4a9ce75d23decc47840f6170dacb5a36bb445f48d441523f57348e0ee4890cce', '0x06c2b2f54f6be911021782a331015b21f92a9306a447c68b9905799bc402f112'];
let apk2s = ['0x61879fa3eac3e7e97744f4078d068ac7342933e0beaa5415526c99298ecb8c32', '0x61879fa3eac3e7e97744f4078d068ac7342933e0beaa5415526c99298ecb8c32', '0xaff9a483e738a865629a05a2c55cc88f89cbc2cfb4679dd33854873cf197f56e', '0x0da552302249b2085f7a7c1cafb213193a319869bd857b4687f12bea08f7037c', '0xa3d878eae6b7702e7b5a6559ce21a628da121ef6db4b3ff63c689009fb047786', '0x082abd0410622728706f26f1edc199143d220e2c75b4ecf1266021ad00f0f3ac', '0x212ce486123b4b8cc4989fa1dadb69b28235e72a1ae34716a80813d091147872', '0x782a6be911021331015b054f21f92a9306a447c68b9905799bc402f1126c2b2f', '0xce4a975840f6170dacb5ad23decc47368d44152bb445f43f57348e0cce0ee489', '0x6be911021782a331015b06c2b2f54f21f92a9306a447c68b9905799bc402f112'];


let apkHash;
let apk1;
let apk2;
let txIndex = 0;

module.exports.submitAPK = async function (bc, workerIndex, args) {
   
    while (txIndex < args.assets) {
        txIndex++;
        apkHash = 'Hash' + this.workerIndex + '_APK' + this.txIndex.toString();
        apk1 = apk1s[Math.floor(Math.random() * apk1s.length)];
        apk2 = apk2s[Math.floor(Math.random() * apk2s.length)];

        let myArgs = {
            contractId: 'apklist',
            contractFunction: 'submit',
            contractArguments: [apkHash, apk1, apk2],
            timeout: 30
        };

        await bc.sendRequests(myArgs);
    }

};