-- LABORATOR 8 - SAPTAMANA 11

1. 

a) Sa se afiseze informatii (numele, salariul si codul departamentului) 
despre angajatii al caror salariu depaseste valoarea medie a salariilor 
tuturor colegilor din companie.

SELECT last_name, salary, department_id
FROM employees
WHERE salary > (SELECT avg(salary)
                FROM employees
                );


b) Sa se afiseze informatii (numele, salariul si codul departamentului) 
despre angajatii al caror salariu depaseste valoarea medie a salariilor 
colegilor sai de departament.

SELECT last_name, salary, department_id
FROM employees e
WHERE salary > (SELECT avg(salary)
                FROM employees
                WHERE department_id = e.department_id
                );

c) Analog cu cererea precedenta, afisându-se si numele departamentului 
si media salariilor acestuia si numarul de angajati.

SELECT
    e.first_name "Prenume", e.last_name "Nume", e.salary "Salariu",
    d.department_id "Cod departament", d.department_name "Nume departament",
    esal.avgsal "Med. sal. per dep.", ecard.carde "Nr. ang. per dep."
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN (SELECT 
        department_id, ROUND(AVG(salary)) avgsal
        FROM employees
        GROUP BY department_id
    ) esal ON esal.department_id = d.department_id
JOIN (SELECT
        department_id, COUNT(employee_id) carde
        FROM employees
        GROUP BY department_id
        ) ecard ON ecard.department_id = d.department_id
WHERE e.salary > esal.avgsal
ORDER BY e.salary, e.last_name;
                
-- De ce varianta aceasta este gresita?
-- Argumentati: gruparea este facuta pe o singura linie
select last_name, salary, e.department_id, department_name, 
       round(avg(salary)), count(employee_id)
from employees e join departments d on (e.department_id = d.department_id)
group by last_name, salary, e.department_id, department_name;  



2.	Sa se afiseze numele si salariul angajatilor al caror salariu 
este mai mare decât salariile medii din toate departamentele. 
Se cer 2 variante de rezolvare: cu operatorul ALL sau cu functia MAX.

-- Varianta cu ALL
SELECT last_name, salary 
FROM employees 
WHERE salary > all (select round(avg(salary))
                    from employees 
                    group by department_id
                    ); -- subcererea calculeaza salariul mediu pentru fiecare departament

-- Varianta cu functia MAX
SELECT last_name, salary 
FROM employees 
WHERE salary > (select ROUND(max(avg(salary)))
                from employees 
                group by department_id
                );



3.	Sa se afiseze numele si salariul celor mai prost platiti angajati 
din fiecare departament.

-- Solutia 1 (cu sincronizare):
SELECT
    e.last_name "Nume", e.salary "Salariu", d.department_id "Cod departament"
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary = (  SELECT
                    MIN(mini.salary)
                    FROM employees mini
                    WHERE mini.department_id = e.department_id
) AND e.department_id IS NOT NULL
ORDER BY e.salary, e.last_name;

-- Solutia 2 (fara sincronizare):
SELECT last_name, salary, department_id  
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, MIN(salary) 
                                  FROM employees 
                                  GROUP BY department_id
                                  );

-- Solutia 3: Subcerere în clauza FROM       
SELECT e.last_name, e.salary, d.department_id  
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN (  SELECT
        department_id, MIN(salary) salmindep
        FROM employees 
        WHERE department_id IS NOT NULL
        GROUP BY department_id
) min_sal ON e.department_id = min_sal.department_id
AND e.salary = min_sal.salmindep
ORDER BY e.salary, d.department_id;



4.	Sa se obtina numele si salariul salariatilor care lucreaza intr-un departament 
in care exista cel putin 1 angajat cu salariul egal cu 
salariul maxim din departamentul 30.

-- METODA 1 - IN
SELECT last_name, salary, department_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        WHERE salary = (SELECT MAX(salary)
                                        FROM employees
                                        WHERE department_id = 30
                                        )
                        );                  

-- METODA 2 - EXISTS
SELECT last_name, salary, department_id
FROM employees e
WHERE EXISTS (SELECT 1
                FROM employees
                WHERE e.department_id = department_id
                AND salary = (SELECT MAX(salary)
                                FROM employees
                                WHERE department_id = 30
                                )
                );                  


-- LABORATOR 8 - SAPTAMANA 12

-- DISCUTIE EXERCITIUL 8

-- EX 9

9. Sa se afiseze codul, prenumele, numele si data_angajarii, pentru angajatii condusi de Steven King 
care au cea mai mare vechime dintre subordonatii lui Steven King. 
Rezultatul nu va contine angajatii din anul 1970. 

WITH subord AS (SELECT employee_id empid, hire_date dat_ang
                FROM employees
                WHERE manager_id = (SELECT employee_id FROM employees WHERE LOWER(first_name || last_name) = 'stevenking')
                ),
     vechime AS (SELECT empid
                 FROM subord
                 WHERE dat_ang = (SELECT MIN(dat_ang) FROM subord)
                 )
                 
SELECT employee_id, first_name, last_name, hire_date
FROM employees
WHERE employee_id IN (SELECT empid from vechime)
AND TO_CHAR(hire_date, 'YYYY') != '1970';


10. Sa se obtina numele primilor 10 angajati avand salariul maxim. 
Rezultatul se va afi?a în ordine cresc?toare a salariilor. 

-- Solutia 1: subcerere sincronizat?

-- numaram cate salarii sunt mai mari decat linia la care a ajuns
select last_name, salary
from employees e
where 10 >
     (select count(salary) 
      from employees
      where e.salary < salary
     );

-- Solutia 2: analiza top-n 

select employee_id, last_name, salary
from (SELECT employee_id, last_name, salary
        FROM employees ORDER BY salary DESC)
FETCH FIRST 10 ROWS ONLY;

12.	Sa se afiseze informatii despre departamente, în formatul urmator: 
"Departamentul <department_name> este condus de {<manager_id> | nimeni} 
si {are numarul de salariati  <n> | nu are salariati}".

SELECT 'Departamentul '||d.department_name||' este condus de '||NVL(TO_CHAR(manager_id), 'nimeni')||' si ' ||
CASE 
    WHEN (SELECT COUNT(employee_id) FROM employees WHERE department_id = d.department_id)  != 0
    THEN 'are numarul de salariati '|| (SELECT COUNT(employee_id) FROM employees WHERE department_id = d.department_id) 
    ELSE 'nu are salariati'
END "Informatii angajati"
FROM departments d;


17. Sa se afiseze salariatii care au fost angajati în aceeasi zi a lunii 
în care cei mai multi dintre salariati au fost angajati (ziua lunii insemnand numarul zilei, indiferent de luna si an).

WITH angzile AS (SELECT COUNT(employee_id) numar, TO_CHAR(hire_date, 'DD') ziua
                    FROM employees
                    GROUP BY TO_CHAR(hire_date, 'DD'))
SELECT *
FROM employees
WHERE TO_CHAR(hire_date, 'DD') = (SELECT ziua FROM angzile WHERE numar = (SELECT MAX(numar) FROM angzile));

5.	Sa se afiseze codul, numele si prenumele angajatilor care au cel putin doi subalterni. 

a)
select employee_id, last_name, first_name
from employees mgr
where 1 < (select count(employee_id)
           from employees
           where mgr.employee_id = manager_id
          );

--SAU:
select employee_id, last_name, first_name
from employees e join (select manager_id, count(*) 
                       from employees 
                       group by manager_id
                       having count(*) >= 2
                       ) man
on e.employee_id = man.manager_id;


b) Cati subalterni are fiecare angajat? Se vor afisa codul, numele, prenumele si numarul de subalterni.
Daca un angajat nu are subalterni, o sa se afiseze 0 (zero). 

SELECT employee_id, last_name, first_name, NVL((SELECT COUNT(f.employee_id)
                                FROM employees f
                                WHERE manager_id = e.employee_id
                                GROUP BY manager_id
                                ), 0) "Numar subalterni"
FROM employees e;

-- SAU:
SELECT employee_id, last_name, first_name, nvl(NrSub, 0)
FROM employees e LEFT JOIN ( SELECT COUNT(employee_id) NrSub, manager_id
                                FROM employees
                                GROUP BY manager_id
                            ) sub
    ON(e.employee_id = sub.manager_id);

6.	Sa se determine locatiile în care se afla cel putin un departament.

-- REZOLVATI
-- CEREREA TREBUIE SA AFISEZE 7 LOCATII 
-- VEZI IMAGINEAZA ATASATA IN LABORATOR

-- METODA 1 - IN (care este echivalent cu  = ANY )         

SELECT l.location_id, l.city
FROM locations l
WHERE l.location_id IN (SELECT DISTINCT d.location_id
                        FROM departments d
                        WHERE d.location_id IS NOT NULL
                        );

-- METODA 2 - EXISTS
SELECT l.location_id, l.city
FROM locations l
WHERE EXISTS(SELECT 1
             FROM departments d
             WHERE d.location_id = l.location_id
            );


7.	Sa se determine departamentele în care nu exista niciun angajat.

-- REZOLVATI
-- CEREREA TREBUIE SA RETURNEZE 16 DEPARTAMENTE
-- VEZI IMAGINEAZA ATASATA IN LABORATOR

-- METODA 1 - UTILIZAND NOT IN 

SELECT department_id, department_name
FROM departments
WHERE department_id NOT IN (SELECT department_id
                            FROM employees
                            WHERE department_id IS NOT NULL
                            GROUP BY department_id
                            );


-- METODA 2 - UTILIZAND NOT EXISTS

SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS(SELECT 1 
                FROM employees e
                WHERE e.department_id = d.department_id
                );