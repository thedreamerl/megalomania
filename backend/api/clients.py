from flask_restx import Namespace, Resource, fields
from flask_restx.reqparse import RequestParser

from .helpers_insurance import read_contracts, add_contract


# Define namespace
ns_clients = Namespace('clients')


model_client = ns_clients.model('Client', {

        "phone": fields.String,
        "firstName": fields.String,
        "lastName": fields.String,
        "patronymic": fields.String,
        "insurance_type": fields.Integer,
        "startDate": fields.String,
        "endDate": fields.String,
        "key": fields.String,
        "insurance_key": fields.String



})

# Define request parser
client_parser = RequestParser()
client_parser.add_argument('client', type=str)


@ns_clients.route('/')
class ClientsList(Resource):
    """
    Resource for working with clients
    """
    @ns_clients.marshal_list_with(model_client)
    def get(self):
        """
        Get list of clients
        """
        return read_contracts()

    def post(self):
        """
        Add a client manually
        """
        args = client_parser.parse_args()
        add_contract(**args)
        return 'ok'
