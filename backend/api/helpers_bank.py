import os
import json
import uuid
from backend.config import Config

_CONTRACTS_JSON = os.path.join(Config.DATADIR, 'bank_contracts.json')
_BANK_KEY = 'd42f0f47-4cf5-441f-8ce8-f5f7832f13cb'


def read_contracts():
    with open(_CONTRACTS_JSON, 'rt') as file:
        return json.load(file)


def write_contracts(contracts):
    with open(_CONTRACTS_JSON, 'wt') as file:
        json.dump(contracts, file)


def add_contract(contract):
    contracts = read_contracts()
    contract['bank_key'] = _BANK_KEY

    contracts.append(contract)
    write_contracts(contracts)
