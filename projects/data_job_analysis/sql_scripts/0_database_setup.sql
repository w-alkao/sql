-- DATABASE CREATION
-- Create the database

CREATE SCHEMA job_analysis;

-- TABLE CREATION
-- Create company_dim table with primary key

DROP TABLE IF EXISTS company_dim;
CREATE TABLE job_analysis.company_dim
(
    company_id INT PRIMARY KEY,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

-- Create skills_dim table with primary key

DROP TABLE IF EXISTS skills_dim;
CREATE TABLE job_analysis.skills_dim
(
    skill_id INT PRIMARY KEY,
    skills TEXT,
    type TEXT
);

-- Create job_postings_fact table with primary key

DROP TABLE IF EXISTS job_postings_fact;
CREATE TABLE job_analysis.job_postings_fact
(
    job_id INT PRIMARY KEY,
    company_id INT,
    job_title_short VARCHAR(255),
    job_title TEXT,
    job_location TEXT,
    job_via TEXT,
    job_schedule_type TEXT,
    job_work_from_home BOOLEAN,
    search_location TEXT,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country TEXT,
    salary_rate TEXT,
    salary_year_avg NUMERIC,
    salary_hour_avg NUMERIC,
    FOREIGN KEY (company_id) REFERENCES job_analysis.company_dim (company_id)
);

-- Create skills_job_dim table with a composite primary key and foreign keys

DROP TABLE IF EXISTS skills_job_dim;
CREATE TABLE job_analysis.skills_job_dim
(
    job_id INT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES job_analysis.job_postings_fact (job_id),
    FOREIGN KEY (skill_id) REFERENCES job_analysis.skills_dim (skill_id)
);


-- Create indexes on foreign key columns for better performance

CREATE INDEX idx_company_id ON job_analysis.job_postings_fact (company_id);
CREATE INDEX idx_skill_id ON job_analysis.skills_job_dim (skill_id);
CREATE INDEX idx_job_id ON job_analysis.skills_job_dim (job_id);


-- DATA LOADING
-- Load data into company_dim table

\copy job_analysis.company_dim FROM 'C:\Users\walka\MyGit\sql\projects\data_job_analysis\data\company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Load data into skills_dim table

\copy job_analysis.skills_dim FROM 'C:\Users\walka\MyGit\sql\projects\data_job_analysis\data\skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Load data into job_postings_fact table

\copy job_analysis.job_postings_fact FROM 'C:\Users\walka\MyGit\sql\projects\data_job_analysis\data\job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Load data into skills_job_dim table

\copy job_analysis.skills_job_dim FROM 'C:\Users\walka\MyGit\sql\projects\data_job_analysis\data\skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

