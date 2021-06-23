CREATE TABLE Employees (
	emp_id INT ,
	first_name VARCHAR(40),
	last_name VARCHAR(40),
	CONSTRAINT PK_Employees PRIMARY KEY (emp_id)
);

CREATE TABLE Recipes (
	recipe_id INT,
	recipe_name VARCHAR(40),
	CONSTRAINT PK_Recipes PRIMARY KEY (recipe_id)
);

CREATE TABLE Ingredients (
	ing_id INT,
	unit_of_measurement VARCHAR(10),
	current_amount INT,
	CONSTRAINT PK_Ingredients PRIMARY KEY (ing_id)
);

CREATE TABLE Courses(
	course_id INT,
	recipe_id INT,
	name VARCHAR(40),
	description VARCHAR(50),
	photo IMAGE,
	price MONEY,
	CONSTRAINT PK_Courses PRIMARY KEY (course_id),
	CONSTRAINT FK_Courses_Recipes FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id),
)

CREATE TABLE Categories (
	cat_id INT,
	name VARCHAR(40),
	description VARCHAR(50),
	emp_id INT,
	CONSTRAINT PK_Categories PRIMARY KEY (cat_id),
	CONSTRAINT FK_Categories_Employees FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
)

CREATE TABLE CourseCategories(
	course_id INT ,
	cat_id INT ,
	CONSTRAINT PK_CourseCategories PRIMARY KEY (course_id, cat_id),
	CONSTRAINT FK_CourseCategories_Courses FOREIGN KEY (course_id) REFERENCES Courses(course_id),
	CONSTRAINT FK_CourseCategories_Categories FOREIGN KEY (cat_id) REFERENCES Categories(cat_id),
)

CREATE TABLE RecipeIngredients (
	recipe_id INT,
	ing_id INT,
	quantity INT,
	CONSTRAINT PK_RecipeIngredients PRIMARY KEY (recipe_id, ing_id),
	CONSTRAINT FK_RecipeIngredients_Ingredients FOREIGN KEY (ing_id) REFERENCES Ingredients(ing_id),
	CONSTRAINT FK_RecipeIngredients_Recipes FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id),
);

/* 
DROP TABLE IF EXISTS RecipeIngredients;
DROP TABLE IF EXISTS CourseCategories;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Recipes;
DROP TABLE IF EXISTS Employees;
*/

