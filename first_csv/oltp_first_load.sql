DROP FUNCTION IF EXISTS load_data_from_csv;

CREATE OR REPLACE FUNCTION load_data_from_csv(
    seats_file_path TEXT,
    drive_train_file_path TEXT,
    transmission_type_file_path TEXT,
    transmission_file_path TEXT,
    fuel_type_file_path TEXT,
    type_of_color_file_path TEXT,
    color_file_path TEXT,
    exterior_color_file_path TEXT,
    wheels_file_path TEXT,
    interior_color_and_material_file_path TEXT,
    model_line_file_path TEXT,
    body_style_file_path TEXT,
    model_file_path TEXT,
    user_configuration_file_path TEXT
)
RETURNS VOID AS $$
BEGIN
    -- Create temporary tables
    CREATE TEMP TABLE TempSeats (
        seatsId SERIAL PRIMARY KEY,
        seatsName TEXT,
        cost MONEY
    );

    CREATE TEMP TABLE TempDriveTrain (
        driveTrainId SERIAL PRIMARY KEY,
        driveTrainName TEXT
    );

    CREATE TEMP TABLE TempTransmissionType (
        transmissionTypeId SERIAL PRIMARY KEY,
        transmissionTypeName TEXT,
        isAutomatic BOOLEAN
    );

    CREATE TEMP TABLE TempTransmission (
        transmissionId SERIAL PRIMARY KEY,
        transmissionName TEXT,
        numberOfGears INT,
        transmissionTypeId INT
    );

    CREATE TEMP TABLE TempFuelType (
        fuelTypeId SERIAL PRIMARY KEY,
        fuelTypeName TEXT
    );

    CREATE TEMP TABLE TempTypeOfColor (
        typeOfColorId SERIAL PRIMARY KEY,
        typeOfColorName TEXT
    );

    CREATE TEMP TABLE TempColor (
        colorId SERIAL PRIMARY KEY,
        colorName TEXT,
        colorHex VARCHAR(7),
        typeOfColorId INT
    );

    CREATE TEMP TABLE TempExteriorColor (
        exteriorColorId SERIAL PRIMARY KEY,
        colorId INT,
        cost MONEY
    );

    CREATE TEMP TABLE TempWheels (
        wheelsId SERIAL PRIMARY KEY,
        wheelsName TEXT,
        wheelsDiameter INT,
        wheelsWidth INT,
        wheelsWeight INT,
        colorId INT,
        cost MONEY
    );

    CREATE TEMP TABLE TempInteriorColorAndMaterial (
        interiorColorAndMaterialId SERIAL PRIMARY KEY,
        interiorColorHex VARCHAR(7),
        additionalInteriorColorHex VARCHAR(7),
        interiorColorName TEXT,
        interiorMaterialName TEXT,
        cost MONEY
    );

    CREATE TEMP TABLE TempModelLine (
        modelLineId SERIAL PRIMARY KEY,
        modelLineName TEXT
    );

    CREATE TEMP TABLE TempBodyStyle (
        bodyStyleId SERIAL PRIMARY KEY,
        bodyStyleName TEXT,
        modelLineId INT
    );

    CREATE TEMP TABLE TempModel (
        modelId SERIAL PRIMARY KEY,
        modelName TEXT,
        bodyStyleId INT,
        power INT,
        transmissionTypeId INT,
        driveTrainId INT,
        fuelTypeId INT,
        costFrom MONEY
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
    EXECUTE format('COPY TempSeats FROM %L DELIMITER '','' CSV HEADER', seats_file_path);
    EXECUTE format('COPY TempDriveTrain FROM %L DELIMITER '','' CSV HEADER', drive_train_file_path);
    EXECUTE format('COPY TempTransmissionType FROM %L DELIMITER '','' CSV HEADER', transmission_type_file_path);
    EXECUTE format('COPY TempTransmission FROM %L DELIMITER '','' CSV HEADER', transmission_file_path);
    EXECUTE format('COPY TempFuelType FROM %L DELIMITER '','' CSV HEADER', fuel_type_file_path);
    EXECUTE format('COPY TempTypeOfColor FROM %L DELIMITER '','' CSV HEADER', type_of_color_file_path);
    EXECUTE format('COPY TempColor FROM %L DELIMITER '','' CSV HEADER', color_file_path);
    EXECUTE format('COPY TempExteriorColor FROM %L DELIMITER '','' CSV HEADER', exterior_color_file_path);
    EXECUTE format('COPY TempWheels FROM %L DELIMITER '','' CSV HEADER', wheels_file_path);
    EXECUTE format('COPY TempInteriorColorAndMaterial FROM %L DELIMITER '','' CSV HEADER', interior_color_and_material_file_path);
    EXECUTE format('COPY TempModelLine FROM %L DELIMITER '','' CSV HEADER', model_line_file_path);
    EXECUTE format('COPY TempBodyStyle FROM %L DELIMITER '','' CSV HEADER', body_style_file_path);
    EXECUTE format('COPY TempModel FROM %L DELIMITER '','' CSV HEADER', model_file_path);
    EXECUTE format('COPY TempUserConfiguration FROM %L DELIMITER '','' CSV HEADER', user_configuration_file_path);

    -- Insert data into main tables
    INSERT INTO seats (seatsId, seatsName, cost)
    SELECT seatsId, seatsName, cost
    FROM TempSeats
    ON CONFLICT (seatsId) DO NOTHING;

    INSERT INTO driveTrain (driveTrainId, driveTrainName)
    SELECT driveTrainId, driveTrainName
    FROM TempDriveTrain
    ON CONFLICT (driveTrainId) DO NOTHING;

    INSERT INTO transmissionType (transmissionTypeId, transmissionTypeName, isAutomatic)
    SELECT transmissionTypeId, transmissionTypeName, isAutomatic
    FROM TempTransmissionType
    ON CONFLICT (transmissionTypeId) DO NOTHING;

    INSERT INTO transmission (transmissionId, transmissionName, numberOfGears, transmissionTypeId)
    SELECT transmissionId, transmissionName, numberOfGears, transmissionTypeId
    FROM TempTransmission
    ON CONFLICT (transmissionId) DO NOTHING;

    INSERT INTO fuelType (fuelTypeId, fuelTypeName)
    SELECT fuelTypeId, fuelTypeName
    FROM TempFuelType
    ON CONFLICT (fuelTypeId) DO NOTHING;

    INSERT INTO typeOfColor (typeOfColorId, typeOfColorName)
    SELECT typeOfColorId, typeOfColorName
    FROM TempTypeOfColor
    ON CONFLICT (typeOfColorId) DO NOTHING;

    INSERT INTO color (colorId, colorName, colorHex, typeOfColorId)
    SELECT colorId, colorName, colorHex, typeOfColorId
    FROM TempColor
    ON CONFLICT (colorId) DO NOTHING;

    INSERT INTO exteriorColor (exteriorColorId, colorId, cost)
    SELECT exteriorColorId, colorId, cost
    FROM TempExteriorColor
    ON CONFLICT (exteriorColorId) DO NOTHING;

    INSERT INTO wheels (wheelsId, wheelsName, wheelsDiameter, wheelsWidth, wheelsWeight, colorId, cost)
    SELECT wheelsId, wheelsName, wheelsDiameter, wheelsWidth, wheelsWeight, colorId, cost
    FROM TempWheels
    ON CONFLICT (wheelsId) DO NOTHING;

    INSERT INTO interiorColorAndMaterial (interiorColorAndMaterialId, interiorColorHex, additionalInteriorColorHex, interiorColorName, interiorMaterialName, cost)
    SELECT interiorColorAndMaterialId, interiorColorHex, additionalInteriorColorHex, interiorColorName, interiorMaterialName, cost
    FROM TempInteriorColorAndMaterial
    ON CONFLICT (interiorColorAndMaterialId) DO NOTHING;

    INSERT INTO modelLine (modelLineId, modelLineName)
    SELECT modelLineId, modelLineName
    FROM TempModelLine
    ON CONFLICT (modelLineId) DO NOTHING;

    INSERT INTO bodyStyle (bodyStyleId, bodyStyleName, modelLineId)
    SELECT bodyStyleId, bodyStyleName, modelLineId
    FROM TempBodyStyle
    ON CONFLICT (bodyStyleId) DO NOTHING;

    INSERT INTO model (modelId, modelName, bodyStyleId, power, transmissionTypeId, driveTrainId, fuelTypeId, costFrom)
    SELECT modelId, modelName, bodyStyleId, power, transmissionTypeId, driveTrainId, fuelTypeId, costFrom
    FROM TempModel
    ON CONFLICT (modelId) DO NOTHING;

    INSERT INTO userConfiguration (configurationId, modelId, transmissionId, exteriorColorId, interiorColorAndMaterialId, seatsId, wheelsId, cost)
    SELECT configurationId, modelId, transmissionId, exteriorColorId, interiorColorAndMaterialId, seatsId, wheelsId, cost
    FROM TempUserConfiguration
    ON CONFLICT (configurationId) DO NOTHING;

    -- Drop temporary tables
    DROP TABLE TempSeats;
    DROP TABLE TempDriveTrain;
    DROP TABLE TempTransmissionType;
    DROP TABLE TempTransmission;
    DROP TABLE TempFuelType;
    DROP TABLE TempTypeOfColor;
    DROP TABLE TempColor;
    DROP TABLE TempExteriorColor;
    DROP TABLE TempWheels;
    DROP TABLE TempInteriorColorAndMaterial;
    DROP TABLE TempModelLine;
    DROP TABLE TempBodyStyle;
    DROP TABLE TempModel;
    DROP TABLE TempUserConfiguration;
END;
$$ LANGUAGE plpgsql;

-- Call the function with appropriate file paths
SELECT load_data_from_csv(
    'D:/Course/first_csv/seats.csv',
    'D:/Course/first_csv/driveTrain.csv',
    'D:/Course/first_csv/transmissionType.csv',
    'D:/Course/first_csv/transmission.csv',
    'D:/Course/first_csv/fuelType.csv',
    'D:/Course/first_csv/typeOfColor.csv',
    'D:/Course/first_csv/color.csv',
    'D:/Course/first_csv/exteriorColor.csv',
    'D:/Course/first_csv/wheels.csv',
    'D:/Course/first_csv/interiorColorAndMaterial.csv',
    'D:/Course/first_csv/modelLine.csv',
    'D:/Course/first_csv/bodyStyle.csv',
    'D:/Course/first_csv/model.csv',
    'D:/Course/first_csv/userConfiguration.csv'
);