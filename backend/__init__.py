from flask import Flask

from .config import Config

# Init app
app = Flask(__name__)
# Define configuration
app.config.from_object(Config)

# Import base routes
from . import routes
# Import blueprints
from .api import api_blueprint

# Register blueprints
app.register_blueprint(api_blueprint, url_prefix='/api')
