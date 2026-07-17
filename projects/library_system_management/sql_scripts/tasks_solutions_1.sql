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

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts AS
    SELECT isbn, book_title, COUNT(issued_id) AS no_issued
    FROM books JOIN issued_status ON issued_book_isbn = isbn
    GROUP BY 1, 2;

SELECT * FROM book_cnts;


-- Task 7. Retrieve All Books in a Specific Category

SELECT * FROM books
WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category

SELECT category, SUM(rental_price), COUNT(*) AS nber
FROM books JOIN issued_status ON issued_book_isbn = isbn
GROUP BY 1;


-- Task 10 List Members Who Registered in the Last 180 Days

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES ('C120', 'Sam', '145 Main St', '2026-06-01'), ('C121', 'John', '133 Main St', '2026-05-01');

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- task 10 List Employees with Their Branch Manager's Name and their branch details

SELECT e1.*, b.manager_id, e2.emp_name AS manager
FROM employees AS e1 JOIN branch AS b ON b.branch_id = e1.branch_id
    JOIN employees AS e2 ON b.manager_id = e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD

CREATE TABLE books_price_greater_than_seven AS
SELECT * FROM Books WHERE rental_price > 7;

SELECT * FROM books_price_greater_than_seven;


-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT DISTINCT ist.issued_book_name
FROM issued_status AS ist LEFT JOIN return_status AS rs ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL