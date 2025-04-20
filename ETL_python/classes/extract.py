from typing import List
from psycopg2 import sql
import psycopg2

class Extract:
    def __init__(self, conn: psycopg2.extensions.connection):
        if conn is None:
            raise ValueError("A database connection must be provided")
        self.conn = conn

    def extract(self, table_name: str, columns: List[str]) -> List[tuple]:
        """Extracts specified columns from a table.

        Args:
            table_name (str): The name of the table.
            columns (List[str]): A list of column names to extract.

        Returns:
            List[tuple]: A list of tuples containing the extracted data.
        """

        if not table_name.isidentifier():
            raise ValueError("Invalid table name.")

        try:
            with self.conn.cursor() as cursor:
                column_identifiers = sql.SQL(", ").join(map(sql.Identifier, columns))
                query = sql.SQL("SELECT DISTINCT {} FROM {}").format(
                    column_identifiers,
                    sql.Identifier(table_name)
                )
                cursor.execute(query)
                results = cursor.fetchall()
                return columns, results
        except psycopg2.Error as e:
            raise psycopg2.Error(f"Ocurrió un error en la base de datos: {str(e)}")
