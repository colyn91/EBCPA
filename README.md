
# Our EBCPA protocol

Source codes of solidity-based smart contract, NS, VanetMobiSim in our proposed EBCPA.


## 1. Solidity-based Smart Contract

### 1.1 Environment
Remix:
http://remix.ethereum.org

Compiler:
0.4.23+commit.124ca40d

Language:
Solidity

EVM Version:
compiler default

Deployment Environment:
Javascript VM

Featured Plugins:
1) Debugger
2) Deploy & Run Transactions
3) Solidity Compilier
4) Solidity Static Analysis
5) Solidity Unit Testing

Gas limit
3000000 

===================================================================================================================

### 1.2 Steps

1) Open: http://remix.ethereum.org
2) File explorer: APKList.sol
3) Choose: Environment(Solidity), Compiler (0.4.23+commit.124ca40d), EVM Version (0.4.23+commit.124ca40d)
4) Compile
5) Deploy 
6) Invoke


===================================================================================================================
### 1.3 Related Test data and results

Address
manager: 0xca35b7d915458ef540ade6068dfe2f44e8fa733c  (balance: 100 ether)

vehicle: 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c  (balance: 100 ether)

APK1: ["0xd4035d529c0d00f2a7eaf99b9a52279057c71ac238f3e5c04d984cd1532ce064","0x4a9bc21d0dfe3040fa3c116008f57599a93da506bec58314f7854ae049be16fa"]

APK2:
["0x22b23d1e1e6881ff7fae736fbdb1eaf6de14e0b2ea3dbadfec36ba8aaa60cb43", "0x014b821f48622deb93cc6ab9af5084e3204e7591fe136a355abb944371220c94"]

Contract address:
0x692a70d2e424a56d2c6c27aa97d1a86395877b3a


===================================================================================================================
### 1.4 On basis of the above testing data, we run the algorithms of Submit, Check and Revoke in sequence. The running results are showed as follows.

Deploy
transaction cost: 707821 gas
execution cost: 495377 gas

Submit
transaction cost: 113404 gas
execution cost: 83492 gas


Check
transaction cost: 32639 gas
execution cost: 2727 gas

Revoke
transaction cost: 27130 gas
execution cost: 24348 gas

## 2. Go-based Chaincode

### 2.1 Environment
Ubuntu: v19.04

Fabric: v2.1

Caliper: v0.4.0

Dependencies:
1) docker: v19.03.6
2) docker-compose: v2.0.1
3) go: v1.17
4) Node.js: v10.22.1
5) npm: v6.14.6
6) npx: v10.2.2

### 2.2 Steps
1) Chaincode design, details are shown in folder: chaincode-go
2) Deploy the chaincode in the test-network, details of builiding test-network could be referred to https://github.com/hyperledger/fabric-samples
3) Prepare the benchmark materias, details are shown in folder: caliper-workspace
4) Use npx caliper to execute the benchmark and obtain the final report.html

===================================================================================================================

## 3. NS + VanetMobiSim
### 3.1 VanetMobiSim Related File
These files include some map source data of format .RT (the used map in our simulation is TGR11001.RT1), the setting of vehicles's speed and scenario generation test file.

### 3.2 NS Related File
The test files are <awk_average_delay_RSU.awk> and <awk_Packet_Loss_RSU.awk> for testing average delay and packet loss, respectively.

### 3.3 How to use these files
#### 3.3.1 Dependency:
1) ns 2.35, avaiable at: http://nchc.dl.sourceforge.net/project/nsnam/allinone/ns-allinone-2.35/ns-allinone-2.35.tar.gz

2) JDK, avaiable at: http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html

3) Ant, avaiable at: http://ant.apache.org/bindownload.cgi

4) VanetMobiSim, avaiable at:http://vanet.eurecom.fr/

#### 3.3.2 Setps
1) Use vms_get_scen.xml to generate the simualtion scenario file:
order: java -jar VanetMobiSim.jar vms_get_scen.xml

output: vms_scen_file

2) Use the file of vms_scen_file to genrate .tcl file, that is, importing the scenario file <vms_scen_file> in ns.tcl:
order: ns ns.tcl

output: ns_trace.tr and ns_nam.nam

3) Analyse the average delay:
order: gawk -f awk_average_delay_RSU.awk ns_trace.tr

output: the final average delay

4) Analyse the packet loss:
order: gawk -f awk_Packet_Loss_RSU.awk ns_trace.tr

output: the final packet loss
