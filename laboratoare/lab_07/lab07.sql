-- LABORATOR 7 

create table grupare (id number(5) primary key,
                      nume varchar2(10) not null,
                      salariu number(10) not null,
                      manager_id number(5) not null
                      );
                      
select * from grupare;

insert into grupare values (1, 'user1', 1000, 1);
insert into grupare values (2, 'user2', 1400, 1);
insert into grupare values (3, 'user3', 700, 2);
insert into grupare values (4, 'user4', 300, 2);
insert into grupare values (5, 'user5', 1600, 2);
insert into grupare values (6, 'user6', 1200, 2);

commit;

--exemplu folosind clauza where
select *
from grupare
where salariu < 1100;

--exemplu folosind where si grupare
select manager_id, salariu
from grupare
where salariu < 1100
group by manager_id, salariu;

--exemplu folosind where, iar gruparea realizata doar dupa coloana manager_id
select manager_id
from grupare
where salariu < 1100
group by manager_id;

--exemplu folosind having
select max(salariu)
from grupare
having max(salariu) < 10000;

--group by si having
select manager_id, min(salariu)
from grupare
group by manager_id
having min(salariu) <= 1000;

------------------------------------------------
--exemplu folosind having
select max(salariu)
from grupare
having max(salariu) < 10000;

--group by si having
select manager_id, min(salariu)
from grupare
group by manager_id
having min(salariu) <= 1000;

------------------------------------------------
1. 
a) Functiile grup includ valorile NULL in calcule?
b) Care este deosebirea dintre clauzele WHERE ?i HAVING? 




2.	S? se afi?eze cel mai mare salariu, cel mai mic salariu, suma ?i media salariilor tuturor angaja?ilor. 
Eticheta?i coloanele Maxim, Minim, Suma, respectiv Media. 
Sa se rotunjeasca media salariilor. 

SELECT MAX(salary) Maxim, MIN(salary) Minim, SUM(salary) Suma, ROUND(AVG(salary)) Media 
FROM employees;

3.	S? se modifice problema 2 pentru a se afi?a minimul, maximul, suma ?i media salariilor pentru FIECARE job. 

SELECT job_id Cod, MAX(salary) Maxim, MIN(salary) Minim, SUM(salary) Suma, ROUND(AVG(salary)) Media 
FROM employees
GROUP BY job_id;

4.	S? se afi?eze num?rul de angaja?i pentru FIECARE  departament.

SELECT COUNT(employee_id), department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id;


5.	S? se determine num?rul de angaja?i care sunt ?efi. 
Etichetati coloana “Nr. manageri”.

SELECT COUNT(employee_id)
FROM employees
WHERE employee_id;


6.	S? se afi?eze diferen?a dintre cel mai mare si cel mai mic salariu. 
Etichetati coloana “Diferenta”.

SELECT max(salary)-min(salary) Diferenta
FROM employees;

7.	Scrie?i o cerere pentru a se afi?a numele departamentului, loca?ia, num?rul de angaja?i 
?i salariul mediu pentru angaja?ii din acel departament. 
Coloanele vor fi etichetate corespunz?tor.
Se vor afisa si angajatii care nu au departament

!!!Obs: În clauza GROUP BY se trec obligatoriu toate coloanele prezente în clauza SELECT, 
cu exceptia functiilor de agregare

SELECT department_name, location_id, ____, ____
FROM ____;




8.	Pentru fiecare ?ef, s? se afi?eze codul s?u ?i salariul celui mai prost platit subordonat. 
Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile în care salariul minim este mai mic de 1000$. 
Sorta?i rezultatul în ordine descresc?toare a salariilor.


________




9.	Pentru departamentele in care salariul maxim dep??e?te 3000$, s? se ob?in? codul, 
numele acestor departamente ?i salariul maxim pe departament.

SELECT department_id, department_name, MAX(salary)
FROM departments JOIN employees USING(department_id)
GROUP BY department_id,department_name
HAVING MAX(salary) >= 3000;




10.	Care este salariul mediu minim al job-urilor existente? 
Salariul mediu al unui job va fi considerat drept media aritmetic? a salariilor celor care îl practic?.

SELECT ____
FROM employees ____;




11.	S? se afi?eze maximul salariilor medii pe departamente.

SELECT ____;




12.	Sa se obtina codul, titlul ?i salariul mediu al job-ului pentru care salariul mediu este minim. 

-- Rezolvati

_____




13.	S? se afi?eze salariul mediu din firm? doar dac? acesta este mai mare decât 2500.

SELECT AVG(salary)
FROM employees
____;




14.	S? se afi?eze suma salariilor pe departamente ?i, în cadrul acestora, pe job-uri.

SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY department_id, job_id; 



16.	S? se ob?in? num?rul departamentelor care au cel pu?in 15 angaja?i.

--REZOLVATI

_________________________________________________________________________




-- LABORATOR 7 (continuare) -> SAPTAMANA 11

15.	Sa se afiseze codul, numele departamentului si numarul de angajati care lucreaza in acel departament pentru:

a)	departamentele in care lucreaza mai putin de 4 angajati;

SELECT e.department_id, d.department_name, COUNT(employee_id)
FROM employees e JOIN departments d ON (d.department_id = e.department_id)
GROUP BY e.department_id, d.department_name
HAVING COUNT(*) < 4; 

b)	departamentul care are numarul maxim de angajati.

SELECT e.department_id, d.department_name, count(employee_id)
FROM employees e JOIN departments d ON (d.department_id = e.department_id)
GROUP BY e.department_id, d.department_name
HAVING COUNT(employee_id) = ( SELECT max(count(employee_id))
                              FROM employees
                              GROUP BY department_id); 

17.	S? se ob?in? codul departamentelor ?i suma salariilor angaja?ilor care lucreaz? în acestea, în ordine cresc?toare.
Se consider? departamentele care au mai mult de 10 angaja?i  ?i al c?ror cod este diferit de 30.

SELECT department_id, sum(salary)
FROM employees
WHERE department_id != 30
GROUP BY department_id
HAVING count(employee_id) > 10 
ORDER BY sum(salary) DESC;


18.	Care sunt angajatii care au mai avut cel putin doua j*buri?


select j.employee_id, e.last_name, e.first_name, salary
from job_history j join employees e on (j.employee_id = e.employee_id) 
group by j.employee_id, e.last_name, e.first_name, salary
having count(j.job_id)>=2;

19.	S? se calculeze comisionul mediu din firm?, luând în considerare toate liniile din tabel.

select round(avg(nvl(commission_pct, 0)), 3)
from employees;


20.	Scrie?i o cerere pentru a afi?a job-ul, salariul total pentru job-ul respectiv pe departamente 
si salariul total pentru job-ul respectiv pe departamentele 30, 50, 80. 
Se vor eticheta coloanele corespunz?tor. Rezultatul va ap?rea sub forma de mai jos:

Job	   Dep30   Dep50   Dep80	Total
---------------------------------------

--forma generala;
-- DECODE(value, if1, then1, if2, then2, … , ifN, thenN, else);

-- METODA 1
SELECT job_id, SUM(DECODE(department_id, 30, salary)) Dep30,
               SUM(DECODE(department_id, 50, salary)) Dep50,
               SUM(DECODE(department_id, 80, salary)) Dep80,
               SUM(salary) Total
FROM employees
GROUP BY job_id;

-- METODA 2: (cu subcereri corelate în clauza SELECT)
SELECT job_id, (SELECT SUM(salary)
                FROM employees
                WHERE department_id = 30
                AND job_id = e.job_id
               ) Dep30,
               
               (SELECT SUM(salary)
                FROM employees
                WHERE department_id = 50
                AND job_id = e.job_id
               ) Dep50,
                
               (SELECT SUM(salary)
                FROM employees
                WHERE department_id = 80
                AND job_id = e.job_id
               ) Dep80,
               
              SUM(salary) Total
              
FROM employees e
GROUP BY job_id;



22.	S? se afi?eze codul, numele departamentului ?i suma salariilor pe departamente.

-- Varianta fara subcerere
SELECT d.department_id, department_name, sum(salary)
FROM departments d join employees e ON (d.department_id = e.department_id)
GROUP BY d.department_id, department_name
ORDER BY d.department_id;


-- Varianta cu subcerere in from
SELECT d.department_id, department_name, a.suma
FROM departments d, (SELECT department_id ,SUM(salary) suma 
                     FROM employees
                     GROUP BY department_id) a
WHERE d.department_id = a.department_id; 
 


23.	S? se afi?eze numele, salariul, codul departamentului si salariul mediu din departamentul respectiv.

-- Varianta fara subcerere -> discutati rezultatul
select last_name, salary, department_id, avg(salary)
from employees join departments using(department_id)
group by department_id,salary,last_name;

-- VARIANTA 1 cu subcerere in FROM
SELECT last_name, salary, e.department_id, SalMed
FROM employees e join  (SELECT round(avg(salary)) SalMed, department_id
                        FROM employees
                        GROUP BY department_id
                         ) salmediu
                on (e.department_id = salmediu.department_id);

-- VARIANTA 2 cu subcerere in SELECT
SELECT last_name, salary, e.department_id, (SELECT round(avg(salary))
                                            FROM employees
                                            WHERE department_id = e.department_id
                                            ) SalMediu
FROM employees e;


