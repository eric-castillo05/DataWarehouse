import psycopg2
class DatabaseConnection:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DatabaseConnection, cls).__new__(cls)
            cls._instance._connect()
        return cls._instance

    def _connect(self):
        self.conn = psycopg2.connect(
            database="tienda",
            user="root",
            host="localhost",
            password="root",
            port=5433
        )

    def get_connection(self):
        return self.conn