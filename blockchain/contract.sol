// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Insurance
 * @dev Store & update information about mortgage insurances
 */
contract MortgageInsuranceTransactions {

    struct Insurance {
        string insuranceNumber;
        uint insuranceStartDate;
        uint insuranceEndDate;
    }

    struct MortgageInsuranceTransaction {
        string bank;
        string insuranceCompany;
        string mortgageContractNumber;
        Insurance propertyInsurance;
        Insurance lifeInsurance;
        Insurance titleInsurance;
        uint remainingDept;
        uint timestamp;
        bool isValid;
    }

    MortgageInsuranceTransaction[] public mortgageInsuranceTransactions;

    event PropertyInsuranceAdded(string mortgageContractNumber, string insuranceNumber, uint insuranceStartDate, uint insuranceEndDate);
    event LifeInsuranceAdded(string mortgageContractNumber, string insuranceNumber, uint insuranceStartDate, uint insuranceEndDate);
    event TitleInsuranceAdded(string mortgageContractNumber, string insuranceNumber, uint insuranceStartDate, uint insuranceEndDate);
    event RemainingDeptUpdated(string mortgageContractNumber, uint remainingDept);

    function checkIfEmptyMortgageInsuranceTransaction(MortgageInsuranceTransaction memory _mortgageInsuranceTransaction) private pure returns (bool isEmpty) {
        if (bytes(_mortgageInsuranceTransaction.mortgageContractNumber).length == 0) {
            return true;
        }
        return false;
    }

    function createInsurance(string memory _insuranceNumber, uint _insuranceStartDate, uint _insuranceEndDate) private pure returns (Insurance memory) {
        Insurance memory insurance = Insurance({
            insuranceNumber: _insuranceNumber,
            insuranceStartDate: _insuranceStartDate,
            insuranceEndDate: _insuranceEndDate
        });
        return insurance;
    }

    function createMortgageInsuranceTransaction(string memory _bank, string memory _mortgageContractNumber, uint _remainingDept, uint _timestamp) private pure returns (MortgageInsuranceTransaction memory) {
        MortgageInsuranceTransaction memory mortgageInsuranceTransaction;
        mortgageInsuranceTransaction.bank = _bank;
        mortgageInsuranceTransaction.mortgageContractNumber = _mortgageContractNumber;
        mortgageInsuranceTransaction.remainingDept = _remainingDept;
        mortgageInsuranceTransaction.timestamp = _timestamp;
        return mortgageInsuranceTransaction;
    }

    function findLastMortgageInsuranceTransaction(string memory _mortgageContractNumber) public view returns (MortgageInsuranceTransaction memory) {
        for (uint i = mortgageInsuranceTransactions.length - 1; i >= 0; i--) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].mortgageContractNumber)) == keccak256(bytes(_mortgageContractNumber))) {
                return mortgageInsuranceTransactions[i];
            }
        }
        MortgageInsuranceTransaction memory emptyMortgageInsuranceTransaction;
        return emptyMortgageInsuranceTransaction;
    }

    function addMortgage(string memory _bank, string memory _mortgageContractNumber,  uint _remainingDept, uint _timestamp) public {
        MortgageInsuranceTransaction memory mortgageInsuranceTransaction = createMortgageInsuranceTransaction(_bank, _mortgageContractNumber, _remainingDept, _timestamp);
        mortgageInsuranceTransactions.push(mortgageInsuranceTransaction);
    }

    function addInsurance(string memory _insuranceCompany, string memory _mortgageContractNumber, string memory _insuranceNumber, uint8 _insuranceType,  uint _insuranceStartDate, uint _insuranceEndDate, uint _timestamp) public {
        MortgageInsuranceTransaction memory lastMortgageInsuranceTransaction = findLastMortgageInsuranceTransaction(_mortgageContractNumber);
        require(!checkIfEmptyMortgageInsuranceTransaction(lastMortgageInsuranceTransaction), "Insurance needs to be added to existed mortgage");
        Insurance memory insurance = createInsurance(_insuranceNumber, _insuranceStartDate, _insuranceEndDate);
        if (_insuranceType == 1) {
            lastMortgageInsuranceTransaction.propertyInsurance = insurance;
            lastMortgageInsuranceTransaction.isValid = true;
            emit PropertyInsuranceAdded(_mortgageContractNumber, _insuranceNumber, _insuranceStartDate, _insuranceEndDate);
        } else if (_insuranceType == 2) {
            lastMortgageInsuranceTransaction.lifeInsurance = insurance;
            emit LifeInsuranceAdded(_mortgageContractNumber, _insuranceNumber, _insuranceStartDate, _insuranceEndDate);
        } else if (_insuranceType == 3) {
            lastMortgageInsuranceTransaction.titleInsurance = insurance;
            emit TitleInsuranceAdded(_mortgageContractNumber, _insuranceNumber, _insuranceStartDate, _insuranceEndDate);
        }
        lastMortgageInsuranceTransaction.insuranceCompany = _insuranceCompany;
        lastMortgageInsuranceTransaction.timestamp = _timestamp;
        mortgageInsuranceTransactions.push(lastMortgageInsuranceTransaction);
    }

    function updateRemainingDept(string memory _mortgageContractNumber, uint _remainingDept, uint _timestamp) public {
        MortgageInsuranceTransaction memory lastMortgageInsuranceTransaction = findLastMortgageInsuranceTransaction(_mortgageContractNumber);
        require(!checkIfEmptyMortgageInsuranceTransaction(lastMortgageInsuranceTransaction), "Mortgage does not exist in the registry");
        lastMortgageInsuranceTransaction.remainingDept = _remainingDept;
        lastMortgageInsuranceTransaction.timestamp = _timestamp;
        mortgageInsuranceTransactions.push(lastMortgageInsuranceTransaction);
        emit RemainingDeptUpdated(_mortgageContractNumber, _remainingDept);
    }

    function getMortgages(string memory _bank) public view returns (MortgageInsuranceTransaction[] memory) {
        uint counter = 0;
        for (uint i = 0; i < mortgageInsuranceTransactions.length; i++) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].bank)) == keccak256(bytes(_bank)) && mortgageInsuranceTransactions[i].timestamp == findLastMortgageInsuranceTransaction(mortgageInsuranceTransactions[i].mortgageContractNumber).timestamp) {
                counter += 1;
            }
        }
        MortgageInsuranceTransaction[] memory result = new MortgageInsuranceTransaction[](counter);
        counter = 0;
        for (uint i = 0; i < mortgageInsuranceTransactions.length; i++) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].bank)) == keccak256(bytes(_bank)) && mortgageInsuranceTransactions[i].timestamp == findLastMortgageInsuranceTransaction(mortgageInsuranceTransactions[i].mortgageContractNumber).timestamp) {
                result[counter] = mortgageInsuranceTransactions[i];
                counter += 1;
            }
        }
        return result;
    }

    function getMortgageInsurance(string memory _mortgageContractNumber, uint8 _insuranceType) public view returns (Insurance memory) {
        MortgageInsuranceTransaction memory mortgageInsuranceTransaction = findLastMortgageInsuranceTransaction(_mortgageContractNumber);
        Insurance memory insurance;
        if (_insuranceType == 1) {
            insurance = mortgageInsuranceTransaction.propertyInsurance;
        } else if (_insuranceType == 2) {
            insurance = mortgageInsuranceTransaction.lifeInsurance;
        } else if (_insuranceType == 3) {
            insurance = mortgageInsuranceTransaction.titleInsurance;
        }
        return insurance;
    }

    function getPropertyInsurances(string memory _insuranceCompany) public view returns (Insurance[] memory) {
        uint counter = 0;
        for (uint i = 0; i < mortgageInsuranceTransactions.length; i++) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].insuranceCompany)) == keccak256(bytes(_insuranceCompany)) && mortgageInsuranceTransactions[i].timestamp == findLastMortgageInsuranceTransaction(mortgageInsuranceTransactions[i].mortgageContractNumber).timestamp) {
                counter += 1;
            }
        }
        Insurance[] memory result = new Insurance[](counter);
        counter = 0;
        for (uint i = 0; i < mortgageInsuranceTransactions.length; i++) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].insuranceCompany)) == keccak256(bytes(_insuranceCompany)) && mortgageInsuranceTransactions[i].timestamp == findLastMortgageInsuranceTransaction(mortgageInsuranceTransactions[i].mortgageContractNumber).timestamp) {
                result[counter] = mortgageInsuranceTransactions[i].propertyInsurance;
                counter += 1;
            }
        }
        return result;
    }

    function getLifeInsurances(string memory _insuranceCompany) view public returns (Insurance[] memory) {
        uint counter = 0;
        for (uint i = 0; i < mortgageInsuranceTransactions.length; i++) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].insuranceCompany)) == keccak256(bytes(_insuranceCompany)) && mortgageInsuranceTransactions[i].timestamp == findLastMortgageInsuranceTransaction(mortgageInsuranceTransactions[i].mortgageContractNumber).timestamp) {
                counter += 1;
            }
        }
        Insurance[] memory result = new Insurance[](counter);
        counter = 0;
        for (uint i = 0; i < mortgageInsuranceTransactions.length; i++) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].insuranceCompany)) == keccak256(bytes(_insuranceCompany)) && mortgageInsuranceTransactions[i].timestamp == findLastMortgageInsuranceTransaction(mortgageInsuranceTransactions[i].mortgageContractNumber).timestamp) {
                result[counter] = mortgageInsuranceTransactions[i].lifeInsurance;
                counter += 1;
            }
        }
        return result;
    }

    function getTitleInsurances(string memory _insuranceCompany) view public returns (Insurance[] memory) {
        uint counter = 0;
        for (uint i = 0; i < mortgageInsuranceTransactions.length; i++) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].insuranceCompany)) == keccak256(bytes(_insuranceCompany)) && mortgageInsuranceTransactions[i].timestamp == findLastMortgageInsuranceTransaction(mortgageInsuranceTransactions[i].mortgageContractNumber).timestamp) {
                counter += 1;
            }
        }
        Insurance[] memory result = new Insurance[](counter);
        counter = 0;
        for (uint i = 0; i < mortgageInsuranceTransactions.length; i++) {
            if (keccak256(bytes(mortgageInsuranceTransactions[i].insuranceCompany)) == keccak256(bytes(_insuranceCompany)) && mortgageInsuranceTransactions[i].timestamp == findLastMortgageInsuranceTransaction(mortgageInsuranceTransactions[i].mortgageContractNumber).timestamp) {
                result[counter] = mortgageInsuranceTransactions[i].titleInsurance;
                counter += 1;
            }
        }
        return result;
    }
}