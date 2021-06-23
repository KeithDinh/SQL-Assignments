BEGIN TRY 	
	BEGIN TRAN
	CREATE TABLE Employees (
		emp_id INT,
		office_id INT,
		last_name VARCHAR(40),
		first_name VARCHAR(40),
		CONSTRAINT PK_Employees PRIMARY KEY(emp_id),
	);

	CREATE TABLE Offices (
		office_id INT ,
		office_name VARCHAR(40) UNIQUE,
		address VARCHAR(40),
		city VARCHAR(40),
		country VARCHAR(40),
		phone_number VARCHAR(11),
		director_id INT,

		CONSTRAINT PK_Offices PRIMARY KEY(office_id)
	);

	CREATE TABLE Projects (
		project_id INT,
		office_id INT,
		project_code VARCHAR(10),
		title VARCHAR(40),
		start_date DATETIME,
		end_date DATETIME,
		budget MONEY,
		project_manager_id INT,

		CONSTRAINT PK_Projects PRIMARY KEY(project_id),
		CONSTRAINT FK_Projects_Offices FOREIGN KEY(office_id) REFERENCES Offices(office_id),
		CONSTRAINT FK_Projects_Employees FOREIGN KEY(project_manager_id) REFERENCES Employees(emp_id),
	);

	CREATE TABLE Operations (
		operation_id INT,
		description VARCHAR(40),
		CONSTRAINT PK_Operations PRIMARY KEY(operation_id)
	);

	CREATE TABLE OperationProjectCities (
		operation_id INT,
		city VARCHAR(40),
		project_id INT,
		CONSTRAINT PK_OperationProjectCities PRIMARY KEY(operation_id, project_id, city),
		CONSTRAINT FK_OperationProjectCities_Projects FOREIGN KEY(project_id) REFERENCES Projects(project_id),
		CONSTRAINT FK_OperationProjectCities_Operations FOREIGN KEY(operation_id) REFERENCES Operations(operation_id),
	);

	-- Employees and Offices are circular references
	ALTER TABLE Employees ADD CONSTRAINT FK_Employees_Offices 
		FOREIGN KEY (office_id) REFERENCES Offices(office_id);
	ALTER TABLE Offices ADD CONSTRAINT FK_Offices_Employees
		FOREIGN KEY (director_id) REFERENCES Employees(emp_id);

	COMMIT TRAN
END TRY  
BEGIN CATCH  
       ROLLBACK TRAN  
END CATCH 

/*
ALTER TABLE Employees DROP CONSTRAINT FK_Employees_Offices;
ALTER TABLE Offices DROP CONSTRAINT FK_Offices_Employees;
DROP TABLE IF EXISTS OperationProjectCities;
DROP TABLE IF EXISTS Operations;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Offices;
DROP TABLE IF EXISTS Employees;
*/

