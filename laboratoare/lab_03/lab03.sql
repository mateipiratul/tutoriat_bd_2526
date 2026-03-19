-- Ex. 15

-- continuare lab. 2
-- CASE VARIANTA 1:
SELECT last_name, job_id, salary,
    CASE job_id WHEN 'IT_PROG' THEN salary * 1.1
    WHEN 'ST_CLERK' THEN salary * 1.15
    WHEN 'SA_REP' THEN salary * 1.2
    ELSE salary
    END "Salariu renegociat"
FROM employees;

-- CASE VARIANTA 2:
SELECT last_name, job_id, salary,
    CASE WHEN job_id = 'IT_PROG' THEN salary * 1.1
    WHEN job_id ='ST_CLERK' THEN salary * 1.15
    WHEN job_id ='SA_REP' THEN salary*1.2
    ELSE salary
    END "Salariu renegociat"
FROM employees;

-- DECODE:
SELECT last_name, job_id, salary,
 DECODE(job_id, 'IT_PROG', salary * 1.1,
 'ST_CLERK', salary * 1.15,
 'SA_REP', salary * 1.2,
 salary ) "Salariu renegociat"
FROM employees;

-- Ex. 16
-- JOIN written in WHERE clause
SELECT employee_id, department_name FROM
employees e, departments d
WHERE e.department_id = d.department_id;

-- JOIN written in FROM (utilising ON)
SELECT employee_id, department_name
FROM employees e JOIN departments d 
ON (e.department_id = d.department_id);

-- JOIN written in FROM (utilising USING)
SELECT employee_id, department_name
FROM employees e JOIN departments d USING(department_id);

-- Ex. 17
SELECT job_id "coduri", job_title "denumiri"
FROM jobs, departments d WHERE
d.department_id = 30;

-- Ex. 18
SELECT last_name "Nume", department_name "Nume departament", location_id "ID-ul locatiei"
FROM employees e, departments d
WHERE (e.department_id = d.department_id) AND (commission_pct IS NOT NULL);

-- lab. 3 --

-- Ex. 1
SELECT job_id "coduri", job_title "denumiri"
FROM jobs, departments d WHERE
d.department_id = 30;

-- Ex. 2
SELECT e.last_name, d.department_name, d.location_id
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
WHERE e.commission_pct IS NOT NULL;

-- Ex. 3
SELECT e.last_name, j.job_title, d.department_name
FROM employees e
JOIN departments d ON (e.department_id = d.department_id)
JOIN jobs j ON (e.job_id = j.job_id)
JOIN locations l ON (d.location_id = l.location_id)
WHERE UPPER(l.city) = 'OXFORD';

- Ex. 4
SELECT e.employee_id "Cod Angajat", e.last_name "Nume Angajat",
        m.employee_id "Cod Manager", m.last_name "Nume Manager"
FROM employees e JOIN employees m ON (e.manager_id = m.employee_id);

-- Ex. 5
SELECT e.employee_id "Cod Angajat", e.last_name "Nume Angajat",
        m.employee_id "Cod Manager", m.last_name "Nume Manager"
FROM employees e LEFT JOIN employees m ON (e.manager_id = m.employee_id);

-- Ex. 6
SELECT e.last_name "Cod Angajat", e.department_id "Departament Angajat", c.last_name "Colegi Angajat"
FROM employees e JOIN employees c ON (e.department_id = c.department_id);

-- Ex. 7
SELECT last_name, j.job_id, job_title, department_name, salary
FROM employees e JOIN jobs j ON (e.job_id = j.job_id)
                 JOIN departments d ON (d.department_id = e.department_id);
-----------------
-- toti angajatii, chiar si cei care nu au departament
SELECT last_name, j.job_id, job_title, department_name, salary
FROM employees e JOIN jobs j ON (e.job_id = j.job_id)
                 LEFT JOIN departments d ON (d.department_id = e.department_id);
                 
-- Ex. 8
SELECT e.last_name "Nume angajat", e.hire_date "Data angajare",
       gates.last_name "Nume Gates", gates.hire_date "Data angajare Gates"
FROM employees e JOIN employees gates ON (e.hire_date > gates.hire_date)
WHERE UPPER(gates.last_name) LIKE 'GATES' ORDER BY e.hire_date;

-- Ex. 9
SELECT e.last_name "Nume angajat", TO_CHAR(e.hire_date, 'month') "Luna angajarii", TO_CHAR(e.hire_date, 'YYYY') "Anul angajarii",
       e.department_id "Departament Angajat", NVL(TO_CHAR(e.commission_pct), 'Nu castiga comision') "Comisionul castigat"
FROM employees e JOIN employees gates ON (e.department_id = gates.department_id)
WHERE UPPER(gates.last_name) = 'GATES' AND (INITCAP(e.last_name) LIKE '_%a%' OR INITCAP(e.last_name) LIKE 'A%')
AND INITCAP(e.last_name) != 'Gates' ORDER BY e.last_name;

-- Ex. 10
SELECT e.last_name "Nume angajat", e.salary "Salariu", j.job_title "Titlu Job",
       l.city "Orasul angajatului", c.country_name "Tara angajatului"
FROM employees e JOIN jobs j ON (e.job_id = j.job_id)
                 JOIN departments d ON (e.department_id = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id)
                 JOIN countries c ON (l.country_id = c.country_id)
                 JOIN employees king ON (e.manager_id = king.employee_id)
WHERE UPPER(king.last_name) LIKE 'KING';

-- Ex. 11
SELECT d.department_id, department_name, job_id, last_name,
to_char(salary,'$99,999.00')
FROM employees e JOIN departments d ON (e.department_id =
d.department_id)
WHERE lower(department_name) like '%ti%'
ORDER BY department_name, last_name;

-- lab. 4 --

-- Ex. 1
-- var. 1
SELECT department_id
FROM departments
WHERE lower(department_name) LIKE '%re%'
UNION
SELECT department_id
FROM employees
WHERE upper(job_id) = 'SA_REP';

-- var. 2
SELECT department_id
FROM employees e RIGHT JOIN departments d ON (e.department_id = d.department_id)
WHERE lower(department_name) LIKE '%re%' OR
      upper(job_id) = 'SA_REP';
      
-- Ex. 2
-- var. 1
SELECT department_id 
FROM departments
MINUS
SELECT department_id
FROM employees;

-- var. 2
SELECT d.department_id, last_name, email, employee_id
FROM departments d LEFT JOIN employees e ON (d.department_id = e.department_id)
WHERE employee_id IS NULL;

