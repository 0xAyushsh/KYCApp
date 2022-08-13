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
    registerAndEnrollUser
} = require('../utils/CAUtil.js');
const {
    buildCCP,
    buildWallet
} = require('../utils/AppUtil.js');

const mspOrg1 = 'SBIBankMSP';
const mspOrg2 = 'ICICIBankMSP';
const mspOrg3 = 'CITIBankMSP';
const walletPath = path.join(__dirname, '../wallet');

async function registerUser(bankName, userId, affiliation) {

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

        // in a real application this would be done only when a new user was required to be added
        // and would be part of an administrative flow
        if(bankName == 'sbibank'){
            mspOrg = mspOrg1
        }else if(bankName == 'icicibank'){
            mspOrg = mspOrg2
        }else if(bankName == 'citibank'){
            mspOrg = mspOrg3
        }
        console.log('msp is ' + mspOrg);
        await registerAndEnrollUser(caClient, wallet, mspOrg, userId, affiliation);

        response = {
            success: true,
            message: `Successfully enrolled client user ${userId} and imported it into the wallet`
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

module.exports = registerUser;
//registerHDFCUser('calvin', 'hdfclife.department1');
//registerHDFCUser('operator1','hdfc.operator');