-- LABORATOR 2 - SAPTAMANA 3

SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY')
FROM DUAL;

SELECT TO_DATE('18-MAR-2025','dd-mon-yyyy')
FROM DUAL;

SELECT LTRIM ('     info')
FROM DUAL;

SELECT RTRIM ('infoXXXX', 'X')  
FROM DUAL;

SELECT TRIM (BOTH 'X' FROM 'XinfoXxX')
FROM DUAL;

SELECT RTRIM ('XinfoXxXabc', 'bacX')
FROM DUAL;

SELECT TRANSLATE('$a$aaa','$a','b')
FROM DUAL;

SELECT TRANSLATE('$a$aaa','$a','bac')
FROM DUAL;

SELECT TRANSLATE('cerc','ce','d')
FROM DUAL;

SELECT TRANSLATE('$a$aaa','aa','bc')
FROM DUAL;

SELECT TRANSLATE('$a$aaa','ac','cd')
FROM DUAL;

SELECT TO_DATE('07-03-2023', 'DD-MM-YYYY') + 3
FROM dual; 

SELECT ROUND(SYSDATE - TO_DATE ('10-07-2000', 'DD-MM-YYYY'))
FROM dual; 

SELECT NVL (1, 'a')
FROM dual; 

-- EXERCITII - FUNCTII PE SIRURI DE CARACTERE

1.	Scrieti o cerere care are urmatorul rezultat pentru fiecare angajat: 

<prenume angajat> <nume angajat> castiga <salariu> lunar dar doreste 
<salariu de 3 ori mai mare>. Etichetati coloana “Salariu ideal”. 


SELECT concat(first_name,' ') || last_name || ' castiga ' || salary 
                              || ' lunar dar doreste ' || salary * 3 "Salariu ideal"
FROM employees;


2.	Scrieti o cerere prin care sa se afiseze prenumele salariatului 
cu prima litera majuscula si toate celelalte litere minuscule, 
numele acestuia cu majuscule si lungimea numelui, 
pentru angajatii al caror nume începe cu J sau M sau care au a treia litera din nume A. 
Rezultatul va fi ordonat descrescator dupa lungimea numelui. 
Se vor eticheta coloanele corespunzator. 
Se cer 2 solutii (cu operatorul LIKE si functia SUBSTR).

--LIKE
SELECT INITCAP(first_name) "Prenume", UPPER(last_name) "Nume", LENGTH(last_name) "Lungime Nume"
FROM employees
WHERE (last_name LIKE 'J%' OR last_name LIKE 'M%' OR UPPER(last_name) LIKE '__A%')
ORDER BY LENGTH(last_name) DESC;

--SUBSTR
--SUBSTR(string, start [,n])
SELECT INITCAP(first_name) "Prenume", UPPER(last_name) "Nume", LENGTH(last_name) "Lungime Nume"
FROM employees
WHERE (SUBSTR(UPPER(last_name), 1, 1) = 'J' OR SUBSTR(UPPER(last_name), 1, 1) = 'M' OR SUBSTR(UPPER(last_name), 3, 1) = 'A')
ORDER BY LENGTH(last_name) DESC;

3.	Sa se afiseze, pentru angajatii cu prenumele „Steven”, 
codul si numele acestora, precum si codul departamentului în care lucreaza. 
Cautarea trebuie sa nu fie case-sensitive, iar eventualele blank-uri care preced 
sau urmeaza numelui trebuie ignorate.

--Varianta 1:
SELECT employee_id, last_name, department_id
FROM employees
WHERE LTRIM(RTRIM(UPPER(first_name)))='STEVEN';

--Varianta 2:
SELECT employee_id, last_name, department_id
FROM employees
WHERE TRIM(BOTH FROM UPPER(first_name))='STEVEN';


4. Sa se afiseze pentru toti angajatii al caror nume se termina cu litera 'e', 
codul, numele, lungimea numelui si pozitia din nume în care apare 
prima data litera 'A'. 
Utilizati alias-uri corespunzatoare pentru coloane;

SELECT employee_id "Id Ang", last_name "Nume", length(last_name) "Lung Nume",
       instr(upper(last_name),'A',1,1) "Pozitie litera in nume"
FROM employees
WHERE substr(lower(last_name), -1) = 'e';


-- FUNCTII ARITMETICE

5.	Sa se afiseze detalii despre salariatii care au lucrat un numar 
întreg de saptamâni pâna la data curenta. 
Obs: Solutia necesita rotunjirea diferentei celor doua date calendaristice. 

SELECT employee_id "ID", last_name "Nume", first_name "Prenume"
FROM employees
WHERE MOD(TRUNC(SYSDATE) - TRUNC(hire_date), 7) = 0
ORDER BY hire_date;


6.	Sa se afiseze codul salariatului, numele, salariul, salariul marit cu 15%, 
exprimat cu doua zecimale si numarul de sute al salariului nou 
rotunjit la 2 zecimale. 
Etichetati ultimele doua coloane “Salariu nou”, respectiv “Numar sute”. 
Se vor lua în considerare salariatii al caror salariu nu este divizibil cu 1000. 

SELECT employee_id, last_name, salary, 
       round(salary + 0.15 * salary, 2)  "Salariu Nou",  
       round((salary + 0.15 * salary) / 100, 2)  "Numar sute" 
FROM employees
WHERE MOD(salary, 1000) != 0;  


7.	Sa se listeze numele si data angajarii salariatilor care câ?tig? comision. 
S? se eticheteze coloanele „Nume angajat”, „Data angajarii”. 
Utilizati functia RPAD pentru a determina ca data angaj?rii s? aib? 
lungimea de 20 de caractere.

SELECT last_name  AS "Nume angajat" , RPAD(to_char(hire_date),20,'X')  "Data angajarii"
FROM employees
WHERE  commission_pct IS NOT NULL;


-- FUNCTII SI OPERATII CU DATE CALENDARISTICE

8. S? se afi?eze data (numele lunii, ziua, anul, ora, minutul si secunda) 
de peste 30 zile.

SELECT TO_CHAR(SYSDATE + 30, 'MONTH DD YYYY HH24:MI:SS') "Data"
FROM DUAL;

9. S? se afi?eze num?rul de zile r?mase pân? la sfâr?itul anului.

SELECT to_date('31-12-2025','dd-mm-yyyy') - sysdate
FROM dual;

10. a) S? se afi?eze data de peste 12 ore.

SELECT TO_CHAR(SYSDATE + 12/24, 'DD/MM HH24:MI:SS') "Data"
FROM DUAL;

b) S? se afi?eze data de peste 5 minute
Obs: Cât reprezint? 5 minute dintr-o zi?

SELECT TO_CHAR(SYSDATE + 5/1440, 'DD/MM HH24:MI:SS') "Data"
FROM DUAL;


11.	S? se afi?eze numele ?i prenumele angajatului (într-o singur? coloan?), 
data angaj?rii ?i data negocierii salariului, care este prima zi de Luni 
dup? 6 luni de serviciu. Eticheta?i aceast? coloan? “Negociere”.

SELECT concat(last_name, first_name), hire_date,
       NEXT_DAY(ADD_MONTHS(hire_date, 6), 'monday') "Negociere"
FROM employees;


12.	Pentru fiecare angajat s? se afi?eze numele ?i num?rul de luni 
de la data angaj?rii. Eticheta?i coloana “Luni lucrate”. 
S? se ordoneze rezultatul dup? num?rul de luni lucrate. 
Se va rotunji num?rul de luni la cel mai apropiat num?r întreg.

 -- prima varianta de ordonare

SELECT last_name, round(months_between(sysdate, hire_date)) "Luni lucrate"
FROM employees
ORDER BY MONTHS_BETWEEN(SYSDATE, hire_date);


-- a doua varianta de ordonare

SELECT last_name, round(months_between(sysdate, hire_date)) "Luni lucrate"
FROM employees
ORDER BY 2;


-- a treia varianta de ordonare

SELECT last_name, round(months_between(sysdate, hire_date)) "Luni lucrate"
FROM employees
ORDER BY "Luni lucrate";


-- FUNCTII DIVERSE

13.	S? se afi?eze numele angaja?ilor ?i comisionul. Dac? un angajat 
nu câ?tig? comision, s? se scrie “Fara comision”. Eticheta?i coloana “Comision”.

SELECT last_name "Nume", NVL(TO_CHAR(commission_pct), 'Fara comision') "Comision"
FROM employees;


14.	S? se listeze numele, salariul ?i comisionul tuturor angaja?ilor 
al c?ror venit lunar (salariu + valoare comision) dep??e?te 10 000. 

SELECT  last_name, salary, commission_pct,
        salary + NVL(commission_pct * salary, 0) "Venit lunar"
FROM  employees 
WHERE salary + NVL(commission_pct * salary, 0) > 10000;




