const express = require('express');

const enrollBankAdmin = require('./app/EnrollAdmin');
const registerUser = require('./app/RegisterUser');
const createCustomerDetail = require('./app/CreateCustomerDetail');
const getCustomerDetail = require('./app/GetCustomerDetail');
const updateCustomerDetail = require('./app/UpdateCustomerDetail');


const app = express();
app.use(express.json());

app.post('/api/:org/enroll/admin', async (req, res) => {
    let response;
    let bank = req.params.org;
    console.log('bank is : ' + bank);
    
    response = await enrollBankAdmin(bank);
    if (response && response.success) {

        console.log(`Enroll was Success: ${response.message}`);
        res.status(200).json(response);

    } else {
        console.log(`Enroll was Failure: ${response.message}`);
        res.status(401).json(response);
        return;
    }

});

app.post('/api/register/:org', async (req, res) => {
    let response;
    
    response = await registerUser(req.params.org, req.body.userId, req.body.userAffiliation);

    if (response && response.success) {

        console.log(`Enroll was Success: ${response.message}`);
        res.status(200).json(response);

    } else {
        console.log(`Enroll was Failure: ${response.message}`);
        res.status(401).json(response);
        return;
    }
});

app.post('/api/kyc/:org', async (req, res) => {
    let response;
   
    response = await createCustomerDetail(req.params.org, req.body.userId, req.body.aadhar, req.body.name, req.body.dob);
    res.status(201).json(response);
    return;
});

app.put('/api/kyc/:org', async (req, res) => {
    let response;

    response = await updateCustomerDetail(req.params.org, req.body.userId, req.body.aadhar, req.body.name, req.body.dob);
    res.status(201).json(response);
    return;
});

app.get('/api/:org/getkycdetail', async (req, res) => {
    let response;
    response = await getCustomerDetail(req.params.org, req.body.userId, req.body.aadhar);
    res.status(201).json(response);
    return;
});

let port = process.env.PORT || 3000;
app.listen(port, () => console.log(`server listening on port ${port}....`));