/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const {
    Wallets
} = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const path = require('path');
const {
    buildCAClient,
    enrollAdmin
} = require('../utils/CAUtil.js');
const {
    buildCCP,
    buildWallet
} = require('../utils/AppUtil.js');

const mspOrg1 = 'SBIBankMSP';
const mspOrg2 = 'ICICIBankMSP';
const mspOrg3 = 'CITIBankMSP';
const walletPath = path.join(__dirname, '../wallet');

async function enrollBankAdmin(bankName) {
    let response;
    let mspOrg;
    try {
        // build an in memory object with the network configuration (also known as a connection profile)
        const ccp = buildCCP(bankName);

        // build an instance of the fabric ca services client based on
        // the information in the network configuration
        const caClient = buildCAClient(FabricCAServices, ccp, `ca.${bankName}.example.com`);

        // setup the wallet to hold the credentials of the application user
        const wallet = await buildWallet(Wallets, walletPath);
        
        if(bankName == 'sbibank'){
            mspOrg = mspOrg1
        }else if(bankName == 'icicibank'){
            mspOrg = mspOrg2
        }else if(bankName == 'citibank'){
            mspOrg = mspOrg3
        }
        console.log('msp is ' + mspOrg);
        // in a real application this would be done on an administrative flow, and only once
        await enrollAdmin(caClient, wallet, mspOrg);

        response = {
            success: true,
            message: `Enrolled ${bankName}admin successfully`
        };

    } catch (error) {
        console.error(`******** FAILED to run the application: ${error}`);
        response = {
            success: false,
            message: `${error}`
        };
    }
    return response;
}

module.exports = enrollBankAdmin;
//enrollHDFCAdmin();