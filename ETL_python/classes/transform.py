import pandas as pd
import requests
    
class Transform:
    def __init__(self, df: pd.DataFrame):
        if df is None or df.empty:
            raise ValueError("DataFrame cannot be None or empty.")
        self.df = df
        self.api_url = "https://restcountries.com/v3.1/name/"

    def gender(self) -> pd.DataFrame:
        """Transforms the column gender to spanish."""
        translation = {"Male": "Hombre", "Female": "Mujer"}
        descriptions = {"Hombre": "Persona del sexo masculino", "Mujer": "Persona del sexo femenino"}

        self.df["gender"] = self.df["gender"].map(translation)
        self.df["description"] = self.df["gender"].map(descriptions)
        self.df = self.df.rename(columns={"gender": "genero"})
        return self.df[["genero", "description"]]

    def get_country_info(self, country_name: str) -> dict:
        """Obtiene información del país desde la API de restcountries.com."""
        try:
            response = requests.get(f"{self.api_url}{country_name}", timeout=5)
            if response.status_code == 200:
                data = response.json()
                if data and len(data) > 0:
                    print(f"Datos obtenidos para {country_name}: {data[0]['translations']['spa']['common']}")
                    return data[0]
            print(f"No se encontraron datos para {country_name}")
            return None
        except requests.RequestException as e:
            print(f"Error al consultar la API para {country_name}: {e}")
            return None

    def transform_country(self) -> pd.DataFrame:
        """Transforma la columna country obteniendo el nombre en español desde la API y devuelve un nuevo DataFrame.

        :Returns:
            pd.DataFrame: Un dataframe independiente con solo la columna pais (nombre en español).
        """
        print("DataFrame original:")
        print(self.df)

        # Lista para almacenar los resultados transformados
        transformed_data = []

        # Iterar sobre los países únicos en el DataFrame
        for country in self.df["country"].unique():
            print(f"Procesando país: {country}")
            country_data = self.get_country_info(country)
            if country_data:
                # Obtener el nombre en español desde las traducciones
                spanish_name = country_data.get("translations", {}).get("spa", {}).get("common", country)
                transformed_data.append({"pais": spanish_name})
            else:
                # Si no se encuentra en la API, usar el nombre original
                transformed_data.append({"pais": country})

        # Crear un nuevo DataFrame independiente con los datos transformados
        result_df = pd.DataFrame(transformed_data)
        print("DataFrame transformado:")
        print(result_df)

        return result_df[["pais"]]

    def transform_years(self) -> pd.DataFrame:
        """Returns the years DataFrame as is (no transformation needed)."""
        print("Transforming years DataFrame:")
        print(self.df)
        return self.df[["year"]]

    def transform_months(self) -> pd.DataFrame:
        """Transforms month numbers to Spanish month names."""
        print("Transforming months DataFrame:")
        print(self.df)

        month_names = {
            1: "Enero", 2: "Febrero", 3: "Marzo", 4: "Abril", 5: "Mayo", 6: "Junio",
            7: "Julio", 8: "Agosto", 9: "Septiembre", 10: "Octubre", 11: "Noviembre", 12: "Diciembre"
        }
        self.df["month_name"] = self.df["month"].map(month_names)
        result_df = self.df[["month_name"]]
        print("Transformed months DataFrame:")
        print(result_df)
        return result_df

    def transform_weekdays(self) -> pd.DataFrame:
        """Transforms dates to Spanish weekday names."""
        print("Transforming weekdays DataFrame:")
        print(self.df)

        weekday_names = {
            0: "Lunes", 1: "Martes", 2: "Miércoles", 3: "Jueves", 4: "Viernes",
            5: "Sábado", 6: "Domingo"
        }
        self.df["weekday_name"] = self.df["date"].apply(lambda x: weekday_names[x.weekday()])
        result_df = self.df[["weekday_name"]].drop_duplicates().sort_values(by="weekday_name")
        print("Transformed weekdays DataFrame:")
        print(result_df)
        return result_df