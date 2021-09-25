import os
import json
import uuid
from backend.config import Config

_CLIENTS_JSON = os.path.join(Config.DATADIR, 'clients.json')
_INSURANCE_KEY = 'a4421025-e1a2-4e63-8b2b-5ac48269d4a8'

def read_clients():
    with open(_CLIENTS_JSON, 'rt') as file:
        return json.load(file)


def write_clients(clients):
    with open(_CLIENTS_JSON, 'wt') as file:
        json.dump(clients, file)


def generate_key(clients):
    key = str(uuid.uuid4())
    keys = [c['key'] for c in clients]
    while key in keys:
        key = str(uuid.uuid4())
    return key


def add_client(client):
    clients = read_clients()
    # adding key of client and insurance key
    key = generate_key(clients)
    client['key'] = key
    client['insurance_key'] = _INSURANCE_KEY

    clients.append(client)
    write_clients(clients)
    return key
