import os
import json
import uuid
from backend.config import Config

_CONTRACTS_JSON = os.path.join(Config.DATADIR, 'insurance_contracts.json')
_REGISTRY_LOOKUP = os.path.join(Config.DATADIR, 'bank_contracts.json')
_INSURANCE_KEY = 'a4421025-e1a2-4e63-8b2b-5ac48269d4a8'


def registry_check():
    with open(_REGISTRY_LOOKUP, 'rt') as file:
        return json.load(file)


def read_contracts():
    with open(_CONTRACTS_JSON, 'rt') as file:
        return json.load(file)


def write_contracts(contracts):
    with open(_CONTRACTS_JSON, 'wt') as file:
        json.dump(contracts, file)


'''
generating contract key here
'''


def generate_key(contracts):
    key = str(uuid.uuid4())
    keys = [c['key'] for c in contracts]
    while key in keys:
        key = str(uuid.uuid4())
    return key


def add_contract(client):
    contracts = read_contracts()
    if client['contractNumber'] not in [ct['contractNumber'] for ct in registry_check()]:
        return '-1'
    # adding key of client and insurance key
    key = generate_key(contracts)
    client['key'] = key
    client['insurance_key'] = _INSURANCE_KEY

    contracts.append(client)
    write_contracts(contracts)
    return key
