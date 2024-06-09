DROP FUNCTION IF EXISTS load_data_from_csv;

CREATE OR REPLACE FUNCTION load_data_from_csv(
    color_file_path TEXT,
    user_configuration_file_path TEXT
)
RETURNS VOID AS $$
BEGIN
    -- Create temporary tables
    CREATE TEMP TABLE TempColor (
        colorId SERIAL PRIMARY KEY,
        colorName TEXT,
        colorHex VARCHAR(7),
        typeOfColorId INT
    );

    CREATE TEMP TABLE TempUserConfiguration (
        configurationId SERIAL PRIMARY KEY,
        modelId INT,
        transmissionId INT,
        exteriorColorId INT,
        interiorColorAndMaterialId INT,
        seatsId INT,
        wheelsId INT,
        cost MONEY
    );

    -- Load data into temporary tables
    EXECUTE format('COPY TempColor FROM %L DELIMITER '','' CSV HEADER', color_file_path);
    EXECUTE format('COPY TempUserConfiguration FROM %L DELIMITER '','' CSV HEADER', user_configuration_file_path);

    -- Insert data into main tables
    INSERT INTO color (colorId, colorName, colorHex, typeOfColorId)
    SELECT colorId, colorName, colorHex, typeOfColorId
    FROM TempColor
    ON CONFLICT (colorId) DO NOTHING;

    INSERT INTO userConfiguration (configurationId, modelId, transmissionId, exteriorColorId, interiorColorAndMaterialId, seatsId, wheelsId, cost)
    SELECT configurationId, modelId, transmissionId, exteriorColorId, interiorColorAndMaterialId, seatsId, wheelsId, cost
    FROM TempUserConfiguration
    ON CONFLICT (configurationId) DO NOTHING;

    -- Drop temporary tables
    DROP TABLE TempColor;
    DROP TABLE TempUserConfiguration;
END;
$$ LANGUAGE plpgsql;

-- Call the function with appropriate file paths
SELECT load_data_from_csv(
    'D:/Course/second_csv/color.csv',
    'D:/Course/second_csv/userConfiguration.csv'
);