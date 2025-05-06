from typing import List, Tuple
from psycopg2 import sql
import psycopg2
import pandas as pd

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

    def extract_date_components(self, table_name: str, date_column: str) -> Tuple[
        pd.DataFrame, pd.DataFrame, pd.DataFrame]:
        """Extracts distinct years, months, and weekdays from a date column.

        Args:
            table_name (str): The name of the table.
            date_column (str): The name of the date column (e.g., 'date_sale').

        Returns:
            Tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]: DataFrames for years, months, and weekdays.
        """
        if not table_name.isidentifier() or not date_column.isidentifier():
            raise ValueError("Invalid table or column name.")

        columns, results = self.extract(table_name, [date_column])
        dates = [result[0] for result in results]  # Lista de fechas

        years = pd.DataFrame({"year": sorted(set(date.year for date in dates))})
        months = pd.DataFrame({"month": sorted(set(date.month for date in dates))})
        weekdays = pd.DataFrame({"date": dates})  # Guarda

        return years, months, weekdays

    def extract_statistics(self, table_name: str) -> pd.DataFrame:
        """Extracts statistics from the sale table, joining with client, card, sale_product, and product,
        grouped by country, gender, product, and date components.

        Args:
            table_name (str): The name of the table (e.g., 'sale').

        Returns:
            pd.DataFrame: A DataFrame with grouped statistics.
        """
        if not table_name.isidentifier():
            raise ValueError("Invalid table name.")

        try:
            with self.conn.cursor() as cursor:
                query = sql.SQL("""
                    SELECT
                        cl.country,
                        cl.gender,
                        p.product,
                        EXTRACT(DAY FROM s.date_sale) AS day,
                        EXTRACT(YEAR FROM s.date_sale) AS year,
                        EXTRACT(MONTH FROM s.date_sale) AS month,
                        COUNT(s.sale_paid) AS count_sale_paid,
                        SUM(s.sale_paid) AS sum_sale_paid,
                        MIN(s.sale_paid) AS min_sale_paid,
                        MAX(s.sale_paid) AS max_sale_paid,
                        STDDEV(s.sale_paid) AS std_sale_paid,
                        AVG(s.sale_paid) AS mean_sale_paid
                    FROM sale s
                    JOIN card c ON s.id_card = c.id_card
                    JOIN client cl ON c.id_client = cl.id_client
                    JOIN sale_product sp ON s.id_sale = sp.id_sale
                    JOIN product p ON sp.id_product = p.id_product
                    GROUP BY cl.country, cl.gender, p.product, EXTRACT(DAY FROM s.date_sale), EXTRACT(YEAR FROM s.date_sale), EXTRACT(MONTH FROM s.date_sale)
                    ORDER BY cl.country, cl.gender, p.product, EXTRACT(DAY FROM s.date_sale), EXTRACT(YEAR FROM s.date_sale), EXTRACT(MONTH FROM s.date_sale)
                """)
                cursor.execute(query)
                results = cursor.fetchall()
                columns = ["country", "gender", "product", "day", "year", "month", "count_sale_paid", "sum_sale_paid", "min_sale_paid", "max_sale_paid", "std_sale_paid", "mean_sale_paid"]
                df = pd.DataFrame(results, columns=columns)
                return df
        except psycopg2.Error as e:
            raise psycopg2.Error(f"Ocurrió un error en la base de datos: {str(e)}")