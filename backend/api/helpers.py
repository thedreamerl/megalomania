import os
import json

from backend.config import Config

_MOVIES_JSON = os.path.join(Config.DATADIR, 'movies.json')


def read_movies():
    """
    Read movies from JSON file
    """
    with open(_MOVIES_JSON, 'rt') as file:
        return json.load(file)


def add_movie(movie, author):
    """
    Add a new movie to JSON file
    """
    movies = read_movies()
    movies.append({
        'name': movie,
        'author': {'fullname': author},
    })
    write_movies(movies)


def write_movies(movies):
    """
    Write given movies to JSON file
    """
    with open(_MOVIES_JSON, 'wt') as file:
        json.dump(movies, file)
