'use strict';

const {Contract} = require('fabric-contract-api');

class ViewLifecycleContract extends Contract{
    constructor(){
        super('pharmanet.viewlifecycle');
    }

    async instantiate(ctx) {
		console.log('View Lifecycle smart contract instantiated');
	}

    /**
     * Fetch the entire history of drug (drug lifecycle)
     * @param {*} ctx 
     * @param {*} drugName name of drug
     * @param {*} serialNo serial number of drug
     * @returns 
     */
    async viewHistory(ctx, drugName, serialNo){
        const drugKey = ctx.stub.createCompositeKey('pharmanet.drug', [drugName, serialNo]);
        const historyResultIterator = await ctx.stub.getHistoryForKey(drugKey).catch(err => console.log(err));

        if(historyResultIterator){
            return await this.#iterateResults(historyResultIterator);
        }
        else {
            return 'Asset with key ' + drugKey + ' does not exist on the network';
        }
    }

    /**
     * Used to check the current state of drug
     * @param {*} ctx 
     * @param {*} drugName name of drug
     * @param {*} serialNo serial number of drug
     * @returns 
     */
    async viewDrugCurrentState(ctx, drugName, serialNo){
        const drugKey = ctx.stub.createCompositeKey('pharmanet.drug', [drugName, serialNo]);
        const drugBuffer = await ctx.stub.getState(drugKey);

        if(!drugBuffer){
            return 'Drug does not exist in the network. Cannot process the request';  
        }

        return JSON.parse(drugBuffer.toString());
    }

    /**
     * iterate the results fetched from history
     * @param {*} iterator 
     * @returns 
     */
    async #iterateResults(iterator){
        let allResults = [];
        while(true){
            let result = await iterator.next();

            if(result.value && result.value.value.toString()){
                let jsonRes = {};
                jsonRes.Key = result.value.key;

                try{
                    jsonRes.Record = JSON.parse(result.value.value.toString());
                }
                catch(err){
                    jsonRes.Record = result.value.value.toString();
                }

                allResults.push(jsonRes.Record);
            }

            if(result.done){
                await iterator.close();
                return allResults;
            }
        }
    }
}

module.exports = ViewLifecycleContract;