from flask_restplus import Namespace, Resource, fields
from flask_restplus.reqparse import RequestParser

from .helpers import read_movies, add_movie


# Define namespace
ns_movies = Namespace('movies')

# Define response models
model_author = ns_movies.model('Author', {
    'fullname': fields.String,
})

model_movie = ns_movies.model('Movie', {
    'name': fields.String,
    'author': fields.Nested(model_author),
})

# Define request parser
movie_parser = RequestParser()
movie_parser.add_argument('movie', type=str)
movie_parser.add_argument('author', type=str)


@ns_movies.route('/')
class MovieList(Resource):
    """
    Resource for working with movies
    """
    @ns_movies.marshal_list_with(model_movie)
    def get(self):
        """
        Get list of movies
        """
        return read_movies()

    def post(self):
        """
        Add a new movie
        """
        args = movie_parser.parse_args()
        add_movie(**args)
        return 'ok'
