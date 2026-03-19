-- LABORATOR 9 - SAPTAMANA 13


EX: Sa se obtina codurile salariatilor atasati tuturor proiectelor 
pentru care s-a alocat un buget egal cu 10000.

SELECT * FROM project; -- p2 si p3 proiecte cu buget de 10k
SELECT * FROM works_on; -- 101, 145, 148, 200 
                   --> angajatii care lucreaza la TOATE proiectele cu buget de 10k

!!! Toate proiectele inseamna ca angajatii sa lucreze OBLIGATORIU 
la TOATE proiectele cu buget de 10k (la toate - p2 si p3), 
dar si la alte proiecte cu un alt buget.

--Metoda 1 (utilizând de 2 ori NOT EXISTS):

SELECT	DISTINCT employee_id
FROM works_on a -- preluam toti employee_id din tabela works_on, 
                -- dar numai pe aceia pentru care NU exista niciun proiect             
                -- cu buget de 10 000 la care să nu lucreze
                
WHERE NOT EXISTS   -- primul NOT EXISTS (relatia universala)
                   -- aceasta conditie filtreaza toti angajatii care lucreaza 
                   -- la toate proiectele cu buget de 10000
                   -- Daca exista macar un proiect cu buget 10000 
                   -- la care angajatul nu lucreaza, acel angajat este exclus
         (SELECT 1
          FROM	project p
          WHERE	budget = 10000
          AND NOT EXISTS   -- are loc verificarea efectiva
                           -- se verifica daca angajatul curent a.employee_id 
                           -- este atasat proiectului p.project_id
                           -- Daca nu este, inseamna ca acel proiecti il descalifica 
                           -- deci excludem acel angajat din afisare
                (SELECT	'x'
                 FROM works_on b
                 WHERE p.project_id = b.project_id
                 AND b.employee_id = a.employee_id
                 ) 
          ); 
          
---------------------------------------------------
DIVISION - succesiune de 2 operatori not exists => 
         => Impartim in doua relatii:

angajati lucreaza la proiecte
proiectele au buget de 10k
----------------------------------------------------


   
--Metoda 2 (simularea diviziunii cu ajutorul functiei COUNT):

SELECT employee_id
FROM works_on
WHERE project_id IN
                (SELECT	project_id
                 FROM  	project
                 WHERE	budget = 10000
                 )
GROUP BY employee_id
HAVING COUNT(project_id)=
                (SELECT COUNT(*)
                 FROM project
                 WHERE budget = 10000
                 );
 
                 
-- EXERCITII DIVISION:
  
                 
8.	Sa se afiseze lista angajatilor care au lucrat numai pe proiecte 
conduse de managerul de proiect avand codul 102.

select * from project;  -- managerul 102 conduce doua proiecte => p1 si p3
select * from works_on; -- angajatii care lucreaza NUMAI pe proiecte coduse de 102 => 
                        -- 136, 140, 150, 162, 176

SELECT employee_id
FROM works_on
WHERE project_id IN ( SELECT project_id
                        FROM project
                        WHERE project_manager = 102
                    )              
MINUS
SELECT employee_id
FROM works_on
WHERE project_id NOT IN ( SELECT project_id
                        FROM project
                        WHERE project_manager = 102
                    );

9.	a) Sa se obtina numele angajatilor care au lucrat 
cel putin pe aceleasi proiecte ca si angajatul avand codul 200.

select * from works_on; -- ang 200 lucreaza la p2 si p3

SELECT project_id FROM works_on WHERE employee_id = 200;

SELECT w.employee_id, last_name
FROM works_on w JOIN employees e ON (w.employee_id = e.employee_id)
WHERE project_id IN (SELECT project_id
                        FROM works_on
                        WHERE employee_id = 200
                    )
        AND w.employee_id != 200
GROUP BY w.employee_id, last_name
HAVING COUNT(*) = ( SELECT COUNT(project_id)
                    FROM works_on
                    WHERE employee_id = 200
                    );


b) Sa se obtina numele angajatilor care au lucrat cel mult pe aceleasi proiecte 
ca si angajatul avand codul 200.

select * from works_on; -- ang 200 lucreaza la p2 si p3

=> 101 (la ambele)
   145 (la ambele) 
   148 (la ambele)
   150 (doar p3)
   162 (doar p3)
   176 (doar p3)



10. Sa se obtina angajatii care au lucrat exact pe aceleasi proiecte 
ca si angajatul avand codul 200.




-- EXERCITII DIVERSE:


1. Sa se listeze informaţii despre angajatii care au lucrat in toate proiectele 
demarate in primele 6 luni ale anului 2006.

_____ 


2.	Sa se listeze informatii despre proiectele la care au participat toti angajatii 
care au detinut alte 2 posturi in firma.




3.	Sa se obtina numarul de angajati care au avut cel putin trei job-uri, 
luandu-se in considerare si job-ul curent.

-- cel putin 3 joburi cu jobul curent inseamna ca in job_history sa aiba cel putin doua 
-- acolo este istoricul joburilor trecute

_____


4.	Pentru fiecare ţară, sa se afiseze numarul de angajati din cadrul acesteia.

_____
   

5.	Sa se listeze codurile angajatilor si codurile proiectelor pe care au lucrat. 
Listarea va cuprinde si angajaţii care nu au lucrat pe niciun proiect.

______


6.	Sa se afiseze angajatii care lucreaza in acelasi departament 
cu cel putin un manager de proiect.


_____


7.	Sa se afiseze angajatii care nu lucreaza in acelasi departament 
cu niciun manager de proiect.

_____







