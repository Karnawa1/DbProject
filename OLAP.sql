DROP TABLE IF EXISTS UserConfigurationFact CASCADE;
DROP TABLE IF EXISTS ModelFact CASCADE;
DROP TABLE IF EXISTS DimModelLine CASCADE;
DROP TABLE IF EXISTS DimBodyStyle CASCADE;
DROP TABLE IF EXISTS DimTransmissionType CASCADE;
DROP TABLE IF EXISTS DimTransmissionModelType CASCADE;
DROP TABLE IF EXISTS DimTransmission CASCADE;
DROP TABLE IF EXISTS DimDriveTrain CASCADE;
DROP TABLE IF EXISTS DimFuelType CASCADE;
DROP TABLE IF EXISTS DimTypeColorOfExterior CASCADE;
DROP TABLE IF EXISTS DimTypeColorOfWheels CASCADE;
DROP TABLE IF EXISTS DimColorOfExterior CASCADE;
DROP TABLE IF EXISTS DimColorOfWheels CASCADE;
DROP TABLE IF EXISTS DimExteriorColor CASCADE;
DROP TABLE IF EXISTS DimWheels CASCADE;
DROP TABLE IF EXISTS DimInteriorColorAndMaterial CASCADE;
DROP TABLE IF EXISTS DimSeats CASCADE;

CREATE TABLE UserConfigurationFact (
  configurationId serial PRIMARY KEY,
  modelId int,
  transmissionId int,
  exteriorId int,
  interiorColorAndMaterialId int,
  seatsId int,
  wheelsId int,
  cost money
);

CREATE TABLE ModelFact (
  modelId serial PRIMARY KEY,
  modelName text,
  bodyStyleId int,
  power int,
  transmissionTypeId int,
  driveTrainId int,
  fuelTypeId int,
  costFrom money
);

CREATE TABLE DimModelLine (
  modelLineId serial PRIMARY KEY,
  modelLineName text
);

CREATE TABLE DimBodyStyle (
  bodyStyleId serial PRIMARY KEY,
  bodyStyleName text,
  modelLineId int
);

CREATE TABLE DimTransmissionType (
  transmissionTypeId serial PRIMARY KEY,
  transmissionTypeName text,
  isAutomatic boolean
);

CREATE TABLE DimTransmissionModelType (
  transmissionModelTypeId serial PRIMARY KEY,
  transmissionModelTypeName text,
  isAutomatic boolean
);

CREATE TABLE DimTransmission (
  transmissionId serial PRIMARY KEY,
  transmissionName text,
  numberOfGears int,
  transmissionTypeId int
);

CREATE TABLE DimDriveTrain (
  driveTrainId serial PRIMARY KEY,
  driveTrainName text
);

CREATE TABLE DimFuelType (
  fuelTypeId serial PRIMARY KEY,
  fuelTypeName text
);

CREATE TABLE DimTypeColorOfExterior (
  typeColorOfExteriorId serial PRIMARY KEY,
  typeColorOfExteriorName text
);

CREATE TABLE DimTypeColorOfWheels (
  typeColorOfWheelsId serial PRIMARY KEY,
  typeColorOfWheelsName text
);

CREATE TABLE DimColorOfExterior (
  colorOfExteriorId serial PRIMARY KEY,
  colorOfExteriorName text,
  colorHex varchar(7),
  typeColorOfExteriorId int,
  StartDate date,
  EndDate date,
  IsCurrent boolean
);

CREATE TABLE DimColorOfWheels (
  colorOfWheelsId serial PRIMARY KEY,
  colorOfWheelsName text,
  colorOfWheelsHex varchar(7),
  typeColorOfWheelsId int,
  StartDate date,
  EndDate date,
  IsCurrent boolean
);

CREATE TABLE DimExterior (
  exteriorId serial PRIMARY KEY,
  colorId int,
  cost money
);

CREATE TABLE DimWheels (
  wheelsId serial PRIMARY KEY,
  wheelsName text,
  wheelsDiameter int,
  wheelsWidth int,
  wheelsWeight int,
  colorOfWheelsId int,
  cost money
);

CREATE TABLE DimInteriorColorAndMaterial (
  interiorColorAndMaterialId serial PRIMARY KEY,
  interiorColorHex varchar(7),
  additionalInteriorColorHex varchar(7),
  interiorColorName text,
  interiorMaterialName text,
  cost money
);

CREATE TABLE DimSeats (
  seatsId serial PRIMARY KEY,
  seatsName text,
  cost money
);

ALTER TABLE UserConfigurationFact ADD FOREIGN KEY (modelId) REFERENCES ModelFact (modelId);

ALTER TABLE UserConfigurationFact ADD FOREIGN KEY (transmissionId) REFERENCES DimTransmission (transmissionId);

ALTER TABLE UserConfigurationFact ADD FOREIGN KEY (exteriorColorId) REFERENCES DimExteriorColor (exteriorColorId);

ALTER TABLE UserConfigurationFact ADD FOREIGN KEY (interiorColorAndMaterialId) REFERENCES DimInteriorColorAndMaterial (interiorColorAndMaterialId);

ALTER TABLE UserConfigurationFact ADD FOREIGN KEY (seatsId) REFERENCES DimSeats (seatsId);

ALTER TABLE UserConfigurationFact ADD FOREIGN KEY (wheelsId) REFERENCES DimWheels (wheelsId);

ALTER TABLE ModelFact ADD FOREIGN KEY (bodyStyleId) REFERENCES DimBodyStyle (bodyStyleId);

ALTER TABLE ModelFact ADD FOREIGN KEY (transmissionTypeId) REFERENCES DimTransmissionModelType (transmissionModelTypeId);

ALTER TABLE ModelFact ADD FOREIGN KEY (driveTrainId) REFERENCES DimDriveTrain (driveTrainId);

ALTER TABLE ModelFact ADD FOREIGN KEY (fuelTypeId) REFERENCES DimFuelType (fuelTypeId);

ALTER TABLE DimBodyStyle ADD FOREIGN KEY (modelLineId) REFERENCES DimModelLine (modelLineId);

ALTER TABLE DimTransmission ADD FOREIGN KEY (transmissionTypeId) REFERENCES DimTransmissionType (transmissionTypeId);

ALTER TABLE DimColorOfWheels ADD FOREIGN KEY (typeColorOfWheelsId) REFERENCES DimTypeColorOfWheels (typeColorOfWheelsId);

ALTER TABLE DimColorOfExterior ADD FOREIGN KEY (typeColorOfExteriorId) REFERENCES DimTypeColorOfExterior (typeColorOfExteriorId);

ALTER TABLE DimExterior ADD FOREIGN KEY (colorId) REFERENCES DimColorOfExterior (colorOfExteriorId);

ALTER TABLE DimWheels ADD FOREIGN KEY (colorOfWheelsId) REFERENCES DimColorOfWheels (colorOfWheelsId);
