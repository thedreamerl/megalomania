import os


class Config:
    """
    App configuration class
    """
    BASEDIR = os.path.abspath(os.path.dirname(__name__))
    DATADIR = os.path.join(BASEDIR, 'data')
    FRONTEND_DIST = os.path.join(BASEDIR, 'frontend', 'dist')
    SECRET_KEY = os.getenv('SECRET_KEY') or 'secret-key'
