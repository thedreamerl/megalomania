from flask import send_from_directory
from flask import request
from . import app
from .api import helpers_insurance
from .config import Config
import json

@app.route('/massLoad/')
def massLoad():
    return send_from_directory(Config.FRONTEND_DIST, 'massLoad.html')

#TODO: implement
@app.route('/bulkLoad/', methods=['GET'])
def bulkLoad():
    return str(len(helpers_insurance.read_clients()))


@app.route('/')
def index():
    """
    Index route – render HTML
    """
    return send_from_directory(Config.FRONTEND_DIST, 'index.html')


# TODO: implement check
def handle_test_client(client):
    return True


@app.route('/handle_data', methods=['POST'])
def handle_data():
    testName = request.form['firstName'] + ' ' + request.form['lastName']
    print('*'*40)
    client = dict(request.form)

    print(client)
    assert handle_test_client(client)
    key = helpers_insurance.add_client(client)

    return {'key': key}
    # return json.dumps({'key': '1488-UXsad-HDKOS-Keiko'})

