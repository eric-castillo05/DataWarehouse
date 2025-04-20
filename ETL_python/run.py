import pandas as pd
from classes.extract import Extract
from classes.db import DatabaseConnection
from classes.transform import Transform
from classes.load import Load

if __name__ == "__main__":
    db = DatabaseConnection()
    conn = db.get_connection()

    extractor = Extract(conn=conn)

    # client - genero
    h, data = extractor.extract('client', ['gender'])
    df = pd.DataFrame(data, columns=h)
    print(df)


    transformer = Transform(df)
    df_result = transformer.gender()
    print(df_result)

    db_url = "postgresql+psycopg2://root:root@localhost:5433/bodegaDeDatos"

    loader = Load(db_url)
    # loader.to_database(df, "genero_dimension")

    # card - card
    h, data = extractor.extract('card', ['card'])
    df = pd.DataFrame(data, columns=h)
    # loader.to_database(df, "card_dimension")

    h, data = extractor.extract('client', ['country'])
    df = pd.DataFrame(data, columns=h)
    # print(df)
    transformer = Transform(df)
    df_result = transformer.transform_country()
    print(df_result)
    loader.to_database(df, "country_dimension")




