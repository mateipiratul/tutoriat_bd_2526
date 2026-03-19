-- Ex. 2
DESC employees;

-- Ex. 3
SELECT * FROM jobs;

-- Ex. 4
SELECT employee_id, first_name, last_name, job_id, hire_date FROM employees;

-- Ex. 5
SELECT job_id FROM employees;
SELECT DISTINCT job_id FROM employees;

-- Ex. 6
SELECT last_name || ', ' || first_name FROM employees;

-- Ex. 7
SELECT last_name, salary FROM employees WHERE salary > 2850;

-- Ex. 8
SELECT last_name, department_id FROM employees WHERE employee_id = 104;

-- Ex. 9
SELECT last_name, salary FROM employees WHERE salary NOT BETWEEN 1400 AND 24000;

-- Ex. 9.1
SELECT last_name, first_name, salary FROM employees WHERE salary BETWEEN 3000 AND 7000;

-- Ex. 9.2
SELECT last_name, first_name, salary FROM employees WHERE salary > 2999 AND salary < 7001;

-- Ex. 10
SELECT last_name, job_id, hire_date FROM employees WHERE hire_date BETWEEN '20-FEB-1987' AND '01-MAY-1989' ORDER BY hire_date;
SELECT last_name, job_id, hire_date FROM employees WHERE hire_date BETWEEN TO_DATE('20-02-1987', 'dd-mm-yyyy') AND TO_DATE('01-05-1989', 'dd-mm-yyyy') ORDER BY hire_date;

-- Ex. 11
SELECT last_name, department_id FROM employees WHERE department_id IN (10, 30) ORDER BY last_name;

-- Ex. 12
SELECT last_name AS "Angajat", salary AS "Salariu lunar" FROM employees WHERE salary > 1500 AND department_id IN (10, 30);

-- Ex. 13
SELECT SYSDATE FROM dual;

-- Ex. 14
SELECT last_name, hire_date FROM employees WHERE hire_date LIKE ('%87%'); -- var. 1
SELECT last_name, hire_date FROM employees WHERE TO_CHAR(hire_date, 'YYYY')='1987'; -- var. 2

-- Ex. 15
SELECT last_name, job_id FROM employees WHERE manager_id IS NULL;

-- Ex. 16
SELECT last_name, salary, commission_pct FROM employees
WHERE commission_pct IS NOT NULL ORDER BY salary DESC, commission_pct DESC;

-- Ex. 17
SELECT last_name, salary, commission_pct FROM employees ORDER BY salary DESC, commission_pct DESC;
-- valorile nule sunt amplasate primele in lista, in functie de ordonarea descrescatoare dupa salariu si comision

-- Ex. 18
SELECT last_name FROM employees WHERE upper(last_name) LIKE '__A%';

-- Ex. 19
SELECT last_name FROM employees
WHERE (LENGTH(last_name) - LENGTH(REPLACE(UPPER(last_name), 'L', ''))) > 1
AND (department_id = 30 OR manager_id = 102);

-- Ex. 20.1
SELECT last_name, job_id, salary FROM employees
WHERE (job_id LIKE '%CLERK%' OR job_id LIKE '%REP%')
AND salary NOT IN (1000, 2000, 3000);

-- Ex. 20.2
SELECT last_name || ' ' || first_name, salary, hire_date FROM employees
WHERE (salary BETWEEN 5000 AND 9000)
AND (LOWER(first_name) LIKE 'a%' OR LOWER(first_name) LIKE 'm%')
AND MOD(TO_NUMBER(TO_CHAR(hire_date, 'YYYY'), '9999'), 2) = 1
AND TO_CHAR(hire_date, 'MM') = TO_CHAR(SYSDATE, 'MM');

-- Ex. 21
SELECT last_name, salary, job_id,
(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR(hire_date, 'YYYY'))) AS "Ani lucrati",
TO_CHAR(hire_date, 'YYYY') FROM employees
WHERE (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR(hire_date, 'YYYY'))) > 24
AND job_id LIKE '%CLERK%';

-- Ex. 22
SELECT first_name || last_name AS "Nume Complet",
    salary AS Salariu, hire_date,
    MOD(hire_date, 2) AS "Paritate An Angajare",
    TO_CHAR(hire_date, 'YYYY') - TO_CHAR(SYSDATE, 'YYYY') AS "Ani Lucrati"
FROM employees
WHERE salary BETWEEN 40000 AND 90000
AND first_name LIKE '_a%'
AND department_id IN (10, 20, 30)
ORDER BY hire_date DESC;