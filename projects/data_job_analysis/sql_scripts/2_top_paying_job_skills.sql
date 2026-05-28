/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/;

WITH top_paying_jobs AS (
    SELECT	
        job_id,
		job_title_short,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_analysis.job_postings_fact AS jpf
    	LEFT JOIN job_analysis.company_dim AS cd ON jpf.company_id = cd.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM
	top_paying_jobs
	INNER JOIN job_analysis.skills_job_dim  AS sjd ON top_paying_jobs.job_id = sjd.job_id
	INNER JOIN job_analysis.skills_dim AS sd ON sjd.skill_id = sd.skill_id
ORDER BY
    salary_year_avg DESC;

/*
Here's the breakdown of the most demanded skills for data analysts in 2023, based on job postings:
SQL is leading with a bold count of 8.
Python follows closely with a bold count of 7.
Tableau is also highly sought after, with a bold count of 6.
Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.


  

