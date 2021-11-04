'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

const helper = require('./helper');

/**
 * Workload module for the benchmark round.
 */
class CheckAPKWorkload extends WorkloadModuleBase {
    /**
     * Initializes the workload module instance.
     */
    constructor() {
        super();
        this.txIndex = 0;
        this.limitIndex = 0;
    }

    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);

        this.limitIndex = this.roundArguments.assets;
        await helper.createCar(this.sutAdapter, this.workerIndex, this.roundArguments);
    }

    /**
     * Assemble TXs for the round.
     * @return {Promise<TxStatus[]>}
     */
    async submitTransaction() {
        this.txIndex++;
        let hash = 'Client' + this.workerIndex + '_CAR' + this.txIndex.toString();

        let args = {
            contractId: 'apkList2',
            contractVersion: 'v1',
            contractFunction: 'Revoke',
            contractArguments: [hash],
            timeout: 30,
            readOnly: true
        };

        if (this.txIndex === this.limitIndex) {
            this.txIndex = 0;
        }

        await this.sutAdapter.sendRequests(args);
    }
}

/**
 * Create a new instance of the workload module.
 * @return {WorkloadModuleInterface}
 */
function createWorkloadModule() {
    return new CheckAPKWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;