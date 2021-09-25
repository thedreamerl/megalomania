from flask import Blueprint
from flask_restx import Api

# Create blueprint
api_blueprint = Blueprint('api', __name__)
# Connect REST
api = Api(api_blueprint)

# Import namespaces
from .clients import ns_clients

# Add namespaces to API
api.add_namespace(ns_clients)
