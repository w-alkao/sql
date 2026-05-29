/*
Question: What are the most in-demand skills for data analysts ?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/;

SELECT 
    skills,
    COUNT(sjd.job_id) AS demand_count
FROM
	job_analysis.job_postings_fact As jpf
	INNER JOIN job_analysis.skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
	INNER JOIN job_analysis.skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 10;

/*
Here's the breakdown of the most demanded skills for data analysts in 2023
SQL and Excel remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
Programming and Visualization Tools like Python, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.
*/