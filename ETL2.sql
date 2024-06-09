-- Load dblink extension
CREATE EXTENSION IF NOT EXISTS dblink;

-- Function to transfer data from OLTP (Porsche) to OLAP (DimPorsche)
DO $$
DECLARE
    source_record RECORD;
BEGIN
    -- Transfer modelLine data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM modelLine') 
        AS t1(modelLineId int, modelLineName text)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimModelLine WHERE modelLineId = source_record.modelLineId) THEN
            INSERT INTO DimModelLine VALUES (source_record.modelLineId, source_record.modelLineName);
        END IF;
    END LOOP;

    -- Transfer bodyStyle data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM bodyStyle') 
        AS t1(bodyStyleId int, bodyStyleName text, modelLineId int)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimBodyStyle WHERE bodyStyleId = source_record.bodyStyleId) THEN
            INSERT INTO DimBodyStyle VALUES (source_record.bodyStyleId, source_record.bodyStyleName, source_record.modelLineId);
        END IF;
    END LOOP;

    -- Transfer transmissionType data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM transmissionType') 
        AS t1(transmissionTypeId int, transmissionTypeName text, isAutomatic boolean)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimTransmissionType WHERE transmissionTypeId = source_record.transmissionTypeId) THEN
            INSERT INTO DimTransmissionType VALUES (source_record.transmissionTypeId, source_record.transmissionTypeName, source_record.isAutomatic);
        END IF;
    END LOOP;
	
	FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM transmissionType') 
        AS t1(transmissionTypeId int, transmissionTypeName text, isAutomatic boolean)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimTransmissionModelType WHERE transmissionModelTypeId = source_record.transmissionTypeId) THEN
            INSERT INTO DimTransmissionModelType VALUES (source_record.transmissionTypeId, source_record.transmissionTypeName, source_record.isAutomatic);
        END IF;
    END LOOP;

    -- Transfer transmission data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM transmission') 
        AS t1(transmissionId int, transmissionName text, numberOfGears int, transmissionTypeId int)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimTransmission WHERE transmissionId = source_record.transmissionId) THEN
            INSERT INTO DimTransmission VALUES (source_record.transmissionId, source_record.transmissionName, source_record.numberOfGears, source_record.transmissionTypeId);
        END IF;
    END LOOP;

    -- Transfer driveTrain data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM driveTrain') 
        AS t1(driveTrainId int, driveTrainName text)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimDriveTrain WHERE driveTrainId = source_record.driveTrainId) THEN
            INSERT INTO DimDriveTrain VALUES (source_record.driveTrainId, source_record.driveTrainName);
        END IF;
    END LOOP;

    -- Transfer fuelType data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM fuelType') 
        AS t1(fuelTypeId int, fuelTypeName text)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimFuelType WHERE fuelTypeId = source_record.fuelTypeId) THEN
            INSERT INTO DimFuelType VALUES (source_record.fuelTypeId, source_record.fuelTypeName);
        END IF;
    END LOOP;

    -- Transfer typeOfColor data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM typeOfColor') 
        AS t1(typeOfColorId int, typeOfColorName text)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimTypeColorOfExterior WHERE typeColorOfExteriorId = source_record.typeOfColorId) THEN
            INSERT INTO DimTypeColorOfExterior VALUES (source_record.typeOfColorId, source_record.typeOfColorName);
        END IF;
    END LOOP;

     FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM typeOfColor') 
        AS t1(typeOfColorId int, typeOfColorName text)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimTypeColorOfWheels WHERE typeColorOfWheelsId = source_record.typeOfColorId) THEN
            INSERT INTO DimTypeColorOfWheels VALUES (source_record.typeOfColorId, source_record.typeOfColorName);
        END IF;
    END LOOP;
	
    -- Transfer color data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM color') 
        AS t1(colorId int, colorName text, colorHex varchar, typeOfColorId int)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimColorOfWheels WHERE colorOfWheelsId = source_record.colorId) THEN
            INSERT INTO DimColorOfWheels(colorOfWheelsId, colorOfWheelsName, colorOfWheelsHex, typeColorOfWheelsId, startDate, endDate, isCurrent)
            VALUES (source_record.colorId, source_record.colorName, source_record.colorHex, source_record.typeOfColorId, CURRENT_DATE, NULL, TRUE);
        END IF;
    END LOOP;

    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM color') 
        AS t1(colorId int, colorName text, colorHex varchar, typeOfColorId int)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimColorOfExterior WHERE colorOfExteriorId = source_record.colorId) THEN
            INSERT INTO DimColorOfExterior(colorOfExteriorId, colorOfExteriorName, colorHex,   typeColorOfExteriorId , startDate, endDate, isCurrent)
            VALUES (source_record.colorId, source_record.colorName, source_record.colorHex, source_record.typeOfColorId, CURRENT_DATE, NULL, TRUE);
        END IF;
    END LOOP;

    -- Transfer exterior data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM exteriorColor') 
        AS t1(exteriorColorId int, colorId int, cost money)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimExterior WHERE exteriorId = source_record.exteriorColorId) THEN
            INSERT INTO DimExterior VALUES (source_record.exteriorColorId, source_record.colorId, source_record.cost);
        END IF;
    END LOOP;

    -- Transfer wheels data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM wheels') 
        AS t1(wheelsId int, wheelsName text, wheelsDiameter int, wheelsWidth int, wheelsWeight int, colorId int, cost money)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimWheels WHERE wheelsId = source_record.wheelsId) THEN
            INSERT INTO DimWheels VALUES (source_record.wheelsId, source_record.wheelsName, source_record.wheelsDiameter, source_record.wheelsWidth, source_record.wheelsWeight, source_record.colorId, source_record.cost);
        END IF;
    END LOOP;

    -- Transfer seats data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM seats') 
        AS t1(seatsId int, seatsName text, cost money)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimSeats WHERE seatsId = source_record.seatsId) THEN
            INSERT INTO DimSeats VALUES (source_record.seatsId, source_record.seatsName, source_record.cost);
        END IF;
    END LOOP;

    -- Transfer interiorColorAndMaterial data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM interiorColorAndMaterial') 
        AS t1(interiorColorAndMaterialId int, interiorColorHex varchar, additionalInteriorColorHex varchar, interiorColorName text, interiorMaterialName text, cost money)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM DimInteriorColorAndMaterial WHERE interiorColorAndMaterialId = source_record.interiorColorAndMaterialId) THEN
            INSERT INTO DimInteriorColorAndMaterial VALUES (source_record.interiorColorAndMaterialId, source_record.interiorColorHex, source_record.additionalInteriorColorHex, source_record.interiorColorName, source_record.interiorMaterialName, source_record.cost);
        END IF;
    END LOOP;
	
	 -- Transfer model data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM model') 
        AS t1(modelId int, modelName text, bodyStyleId int, power int, transmissionTypeId int, driveTrainId int, fuelTypeId int, costFrom money)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM ModelFact WHERE modelId = source_record.modelId) THEN
            INSERT INTO ModelFact VALUES (source_record.modelId, source_record.modelName, source_record.bodyStyleId, source_record.power, source_record.transmissionTypeId, source_record.driveTrainId, source_record.fuelTypeId, source_record.costFrom);
        END IF;
    END LOOP;

    -- Transfer userConfiguration data
    FOR source_record IN SELECT * FROM dblink('dbname=Porsche port=5432 user=postgres password=password', 'SELECT * FROM userConfiguration') 
        AS t1(configurationId int, modelId int, transmissionId int, exteriorColorId int, interiorColorAndMaterialId int, seatsId int, wheelsId int, cost money)
    LOOP
        IF NOT EXISTS (SELECT 1 FROM UserConfigurationFact WHERE configurationId = source_record.configurationId) THEN
            INSERT INTO UserConfigurationFact VALUES (source_record.configurationId, source_record.modelId, source_record.transmissionId, source_record.exteriorColorId, source_record.interiorColorAndMaterialId, source_record.seatsId, source_record.wheelsId, source_record.cost);
        END IF;
    END LOOP;
END $$;