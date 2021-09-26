from flask import send_from_directory
from flask import request
from . import app
from .api import helpers_insurance
from .api import helpers_bank
from .config import Config
import json





@app.route('/massLoad/')
def massLoad():
    return send_from_directory(Config.FRONTEND_DIST, 'massLoad.html')


@app.route('/viewer/')
def viewer():
    return send_from_directory(Config.FRONTEND_DIST, 'viewer.html')

@app.route('/checkBankNum/', methods=['POST'])
def check_bank_num():
    num = dict(request.form)['value']
    return str(num in [ct['contractNumber'] for ct in helpers_insurance.registry_check()])


# TODO: implement
@app.route('/bulkLoad/', methods=['GET'])
def bulkLoad():
    return str(len(helpers_insurance.read_contracts()))


@app.route('/')
def index():
    """
    Index route – render HTML
    """
    return send_from_directory(Config.FRONTEND_DIST, 'index.html')

@app.route('/handle_data/', methods=['POST'])
def handle_data():
    client = dict(request.form)

    print(client)
    assert handle_test_client(client)
    key = helpers_insurance.add_contract(client)

    return {'key': key}

@app.route('/index_bank')
def index_bank():
    """
    Index route – render HTML
    """
    return send_from_directory(Config.FRONTEND_DIST, 'index_bank.html')


# TODO: implement check
def handle_test_client(client):
    return True



@app.route('/handle_data_bank/', methods=['POST'])
def handle_data_bank():
    bank_contract = dict(request.form)

    key = helpers_bank.add_contract(bank_contract)

    return "Успех!"
