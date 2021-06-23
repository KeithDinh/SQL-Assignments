CREATE TABLE Lenders(
	lender_id INT,
	name VARCHAR(40),
	finance MONEY,
	CONSTRAINT PK_Lenders PRIMARY KEY (lender_id)
);

CREATE TABLE Borrowers (
	borrower_id INT,
	name VARCHAR(40),
	risk_value MONEY,
	CONSTRAINT PK_Borrowers PRIMARY KEY (borrower_id)
);

CREATE TABLE Loans(
	loan_id INT,
	borrower_id INT,
	load_code VARCHAR(10),
	amount MONEY,
	deadline DATETIME,
	interest DECIMAL(2,2),
	purpose VARCHAR(50),
	CONSTRAINT PK_Loans PRIMARY KEY (loan_id),
	CONSTRAINT FK_Loans_Borrowers FOREIGN KEY (borrower_id) REFERENCES Borrowers(borrower_id),
);

CREATE TABLE LenderLoans (
	lender_id INT,
	loan_id INT,
	amount MONEY,
	CONSTRAINT PK_LenderLoans PRIMARY KEY (lender_id, loan_id),
	CONSTRAINT FK_LenderLoans_Lenders FOREIGN KEY (lender_id) REFERENCES Lenders(lender_id),
	CONSTRAINT FK_LenderLoans_Loans FOREIGN KEY (loan_id) REFERENCES Loans(loan_id),
);

/* 
DROP TABLE IF EXISTS LenderLoans;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Borrowers;
DROP TABLE IF EXISTS Lenders;
*/