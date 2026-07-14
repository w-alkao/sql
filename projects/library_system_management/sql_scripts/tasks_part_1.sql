SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;


-- Project Task

-- Task 1 Insert new entry

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippicott & Co.');

-- Task 2 Update an entry

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

-- Task 3 Delete a Record from the Issued Status Table

DELETE FROM issued_status
WHERE issued_id = 'IS121'

-- Task 4 Retrieve All books Issued by a specific Employee

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5 List Members Who Have Issued More than one Book

SELECT issued_emp_id, emp_name, COUNT(*) AS nb
FROM issued_status JOIN employees ON emp_id = issued_emp_id
GROUP BY 1, 2
