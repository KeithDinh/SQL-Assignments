CREATE TABLE Employee (
	emp_id INT,
	office_id INT,
);

CREATE TABLE Office (
	office_id INT ,
	office_name VARCHAR(40) UNIQUE,
	address VARCHAR(40),
	city VARCHAR(40),
	country VARCHAR(40),
	phone_number VARCHAR(11),
	director_id INT,
);

CREATE TABLE Project (
	project_id INT,
	office_id INT,
	title VARCHAR(40),
	budget MONEY,
	start_date DATETIME,
	end_date DATETIME,
	project_manager_id INT,
)

CREATE TABLE Operations (
	operation_id INT,
	description VARCHAR(40),
)