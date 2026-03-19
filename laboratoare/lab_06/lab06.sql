-- SAPTAMANA 9 - LABORATOR 6 - Subcereri Necorelate


1.	Folosind subcereri, s? se afi?eze numele ?i data angaj?rii pentru salaria?ii 
care au fost angaja?i dup? Gates.

SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date
                   FROM employees
                   WHERE INITCAP(last_name)= 'Gates'
                   );


2.	Folosind subcereri, scrie?i o cerere pentru a afi?a numele ?i salariul 
pentru to?i colegii (din acela?i departament) lui Gates. Se va exclude Gates. 

SELECT last_name, salary
FROM employees
WHERE department_id = (
                        SELECT department_id
                        FROM employees
                        WHERE INITCAP(last_name) = 'Gates'
                        )
      AND INITCAP(last_name) != 'Gates';

--Se va inlocui Gates cu King;
SELECT last_name, salary
FROM employees
WHERE department_id IN (
                        SELECT department_id
                        FROM employees
                        WHERE INITCAP(last_name) = 'King'
                        )
       AND INITCAP(last_name) != 'King';


3.	Scrie?i o cerere pentru a afi?a numele, codul departamentului ?i salariul angaja?ilor 
al c?ror cod de departament ?i salariu coincid cu codul departamentului ?i salariul 
unui angajat care câ?tig? comision. 

SELECT last_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, salary
                               FROM employees
                               WHERE commission_pct IS NOT NULL
                               );
                                       
4.	S? se afi?eze codul, numele ?i salariul tuturor angaja?ilor al c?ror salariu 
este mai mare decât salariul mediu din companie.

SELECT employee_id, last_name, salary 
FROM employees 
WHERE salary > (SELECT AVG(salary) 
                FROM employees);

5.	Scrieti o cerere pentru a afi?a angaja?ii care câ?tig? 
(castiga = salariul plus comision din salariu) 
mai mult decât oricare func?ionar (job-ul functionarilor  con?ine ?irul "CLERK"). 
Sorta?i rezultatele dupa salariu, în ordine descresc?toare;

SELECT employee_id, last_name, first_name
FROM employees
WHERE (salary + NVL(commission_pct, 0) * salary) > ALL(
                                            SELECT (salary + NVL(commission_pct, 0))
                                            FROM employees
                                            WHERE job_id LIKE '%CLERK%'
                                            );




6.	Scrie?i o cerere pentru a afi?a numele angajatilor, numele departamentului 
?i salariul angaja?ilor care câ?tig? comision, dar al c?ror ?ef direct nu câ?tig? comision.	

SELECT e.last_name, e.department_id, salary
FROM employees e JOIN departments d on (e.department_id = d.department_id)
WHERE commission_pct IS NOT NULL AND e.manager_id IN (SELECT employee_id
                                                    FROM employees
                                                    WHERE commission_pct IS NULL
                                                    );

7. S? se afi?eze numele ?i salariul angaja?ilor care lucreaz? în departamente aflate în loca?ii din CANADA ?i care ocup? joburi
 ce apar?in unei liste de job_id-uri ce con?in cuvântul man. Se vor afi?a – numele, prenumele, salariul ?i id-ul jobului. 
Prima variant? – o s? utilizeze doar subcereri nesincronizate

SELECT last_name, salary
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM 
                        );


--VARIANTA 1
SELECT first_name, last_name, salary, job_id
FROM 



--VARIANTA 2
SELECT first_name, last_name, salary, job_id
FROM 




8.	S? se ob?in? codurile departamentelor în care nu lucreaza nimeni 
(nu este introdus nici un salariat în tabelul employees). Sa se utilizeze subcereri;





9. Sa se creeze tabelul SUBALTERNI care sa contina codul, numele si prenumele angajatilor 
care il au manager pe Steven King, alaturi de codul si numele lui King.
Coloanele se vor numi cod, nume, prenume, cod_manager, nume_manager.

DESC employees;

CREATE TABLE SUBALTERNI
    (
    );
     

INSERT INTO SUBALTERNI (cod, nume, prenume, cod_manager, nume_manager)
        (SELECT 
        
        );
