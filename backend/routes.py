from flask import send_from_directory

from . import app
from .config import Config


@app.route('/')
def index():
    """
    Index route – render HTML
    """
    return send_from_directory(Config.FRONTEND_DIST, 'index.html')
