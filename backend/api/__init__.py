from flask import Blueprint
from flask_restx import Api

# Create blueprint
api_blueprint = Blueprint('api', __name__)
# Connect REST
api = Api(api_blueprint)

# Import namespaces
from .movies import ns_movies

# Add namespaces to API
api.add_namespace(ns_movies)
