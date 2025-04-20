import pandas as pd
from sqlalchemy import create_engine

class Load:
    def __init__(self, db_url: str):
        self.engine = create_engine(db_url)

    def to_database(self, df: pd.DataFrame, table_name: str):
        """
        Load the dataframe to the databse.

        :param df: DataFrame to load the data.
        :param table_name: Name of the table to load.
        """
        if df is None or df.empty:
            raise ValueError("El DataFrame no puede ser None o estar vacío.")
        if not table_name:
            raise ValueError("El nombre de la tabla no puede estar vacío.")

        try:
            df.to_sql(table_name, self.engine, if_exists='append', index=False)
            print(f"Datos cargados exitosamente en la tabla '{table_name}'.")
        except Exception as e:
            print(f"Error al cargar los datos: {e}")