from flask_restx import Namespace, Resource, fields
from flask_restx.reqparse import RequestParser

from .helpers_insurance import read_clients, add_client


# Define namespace
ns_clients = Namespace('clients')

# Define response models
# model_author = ns_movies.model('Author', {
#     'fullname': fields.String,
# })

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


   # author: fields.Nested(model_author),
})

# Define request parser
client_parser = RequestParser()
client_parser.add_argument('client', type=str)
# movie_parser.add_argument('author', type=str)


@ns_clients.route('/')
class ClientsList(Resource):
    """
    Resource for working with movies
    """
    @ns_clients.marshal_list_with(model_client)
    def get(self):
        """
        Get list of clients
        """
        return read_clients()

    def post(self):
        """
        Add a client manually
        """
        args = client_parser.parse_args()
        add_client(**args)
        return 'ok'
