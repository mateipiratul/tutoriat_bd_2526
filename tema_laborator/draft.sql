-- TEMA LABORATOR 1 --

-- Ex. 1
-- Sa se afiseze numele, salariul, titlul jobului, codul si numele departamentului, id-ul locatiei, orasul si tara in
-- care lucreaza angajatii condusi direct de "hunoldalexander" si care au fost angajati intre 01-07-1991 si 28-02-1999;
-- pe ultima coloana se va afisa numele managerului, concatenat cu spatiu, concatenat cu prenumele sau
-- coloana o sa se numeasca "Nume si Prenume Manager"

SELECT -- selectia coloanelor
    e.first_name "Prenume", e.last_name "Nume", e.salary "Salariu",
    j.job_title "Titlu Job", d.department_id "Cod Departament", d.department_name "Nume Departament",
    l.location_id "Cod Locatie", l.city Oras, c.country_name "Nume Tara",
    m.last_name || ' ' || m.first_name "Nume si Prenume Manager"
    -- legaturile dintre tabele
FROM employees e -- pentru nume complet, salariu
JOIN jobs j ON e.job_id = j.job_id -- pentru titlul jobului
JOIN departments d ON e.department_id = d.department_id -- pentru codul departamentului
JOIN locations l ON d.location_id = l.location_id -- pentru locatie
JOIN countries c ON l.country_id = c.country_id -- pentru tara
JOIN employees m ON e.manager_id = m.employee_id -- pentru manager
WHERE LOWER(m.last_name || m.first_name) = 'hunoldalexander' -- daca pe manager il cheama astfel
      AND e.hire_date BETWEEN TO_DATE('01-07-1991', 'DD-MM-YYYY') AND TO_DATE('28-02-1999', 'DD-MM-YYYY');


-- Ex. 2
-- Sa se listeze codul departamentului, numele departamentului si codul managerului de departament.
-- In cazul in care un departament nu are manager, se va afisa pe coloana respectiva, in output, mesajul:
-- "Departamentul <department_id> nu are manager". Coloana se va numi "Manageri departamente". 
-- De asemenea, in cadrul aceleiasi cereri, sa se afiseze atat departamentele care au angajati,
-- cat si cele fara angajati. In cazul in care un departament are angajati, se va afisa si codul acestor
-- angajati (o coloana unde se vor afisa codurile de angajati pentru fiecare departament in parte).
-- Daca un departament nu are angajati, se va afisa pe coloana respectiva, in output, mesajul:
-- "Departamentul nu are angajati". Coloana se va numi "Angajati departamente". In final, se vor afisa 4 coloane:
-- department_id, department_name, angajati departamente, manageri departamente.

SELECT
    d.department_id, d.department_name,
    CASE
        WHEN d.manager_id IS NULL THEN 'Departamentul ' || d.department_id || ' nu are manager'
        ELSE TO_CHAR(d.manager_id)
    END "Manageri departamente",
    NVL(LISTAGG(e.employee_id, ', ') WITHIN GROUP (ORDER BY e.employee_id), -- listarea tuturor angajatilor
        'Departamentul nu are angajati') "Angajati departamente" -- sau cazul NULL
FROM departments d LEFT JOIN employees e ON d.department_id = e.department_id -- sunt incluse si departamentele fara angajati
GROUP BY d.department_id, d.department_name, d.manager_id -- manager_id inclus in GROUP BY utilizat in CASE
ORDER BY d.department_id; -- o sortare optionala


-- Ex. 3
-- Sa se afiseze codul si numele angajatilor, codul departamentului, salariul si codul job-ului tuturor angajatilor care 
-- lucreaza in departamente si al caror salariu si comision coincid cu salariul si comisionul unui angajat din "Oxford".

SELECT -- cerinta mi s-a parut ambigua, am ales sa folosesc ANY() pentru subcerere...
    e.employee_id, e.last_name, e.department_id, e.salary, e.job_id, d.location_id
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
WHERE (e.salary, e.commission_pct) = ANY(SELECT eox.salary, eox.commission_pct
                                         FROM employees eox
                                         JOIN departments dox ON (eox.department_id = dox.department_id)
                                         JOIN locations lox ON (dox.location_id = lox.location_id)
                                         WHERE lox.city = 'Oxford' AND eox.salary = e.salary AND
                                               NVL(eox.commission_pct, 0) = NVL(e.commission_pct, 0)
                                         );


-- Ex. 4
-- Sa se creeze tabelele urmatoare CAMPANIE_MCO si SPONSOR_MCO;
-- CAMPANIE_MCO (
-- cod_campanie -> cheie primara,
-- titlu -> titlul campaniei - nu poate fi null,
-- data_start -> data la care incepe campania - are implicit valoarea sysdate,
--      data la care se incheie campania - este o data inserata in momentul inserarii inregistrarii in baza de date;
--      aceasta data trebuie sa fie mai mare decat data_start,
-- valoare -> pretul campaniei - poate fi null,
-- cod_sponsor -> cheie externa
-- )
-- SPONSOR_MCO (
-- cod_sponsor - cheie primara,
-- nume -> denumirea sponsorului - nu poate fi null si trebuie sa aiba o valoare unica
-- email -> poate fi null si are o valoare unica
-- )
-- OBSERVATII:
-- Relatia dintre cele doua tabele este one-to-many: un sponsor poate sponsoriza mai multe campanii, iar o campanie
-- este sponsorizata doar de un singur sponsor.
-- Instructiunea commit se va rula doar unde este necesara stocarea datelor/modificarilor in baza de date sau doar acolo
-- unde cerinta specifica acest lucru.

CREATE TABLE SPONSOR_MCO (
    cod_sponsor NUMBER(10) CONSTRAINT pk_sponsor_mco PRIMARY KEY, -- cheie primara pentru sponsor
    nume VARCHAR2(100) CONSTRAINT nn_nume_sponsor_mco NOT NULL -- numele sponsorului nu poate fi null
                       CONSTRAINT uk_nume_sponsor_mco UNIQUE,   -- numele sponsorului trebuie sa fie unic
    email VARCHAR2(100) CONSTRAINT uk_email_sponsor_mco UNIQUE     -- adresa de email a sponsorului trebuie sa fie unica
);

CREATE TABLE CAMPANIE_MCO (
    cod_campanie NUMBER(10) CONSTRAINT pk_campanie_mco PRIMARY KEY, -- cheie primara pentru campanie
    titlu VARCHAR2(50) CONSTRAINT nn_titlu_campanie_mco NOT NULL, -- titlul campaniei nu poate fi NULL
    data_start DATE DEFAULT SYSDATE, -- default este setat la sysdate
    data_end DATE,
    valoare NUMBER(10),
    cod_sponsor NUMBER(10),
    CONSTRAINT fk_campanie_sponsor_mco FOREIGN KEY (cod_sponsor) REFERENCES SPONSOR_MCO(cod_sponsor), -- definirea cheii externe
    CONSTRAINT ck_date_campanie_mco CHECK (data_end > data_start) -- verificarea validitatii datelor 
);

DESC SPONSOR_MCO;
DESC CAMPANIE_MCO;

-- Ex. 5
-- Sa se insereze in baza de date urmatoarele inregistrari, folosind, la alegere,
-- metoda implicita sau explicita, precizand varianta aleasa.

-- metoda IMPLICITA este folosita pentru tabela SPONSORILOR
INSERT INTO SPONSOR_MCO VALUES (10, 'CISCO', 'cisco@gmail.com');
INSERT INTO SPONSOR_MCO VALUES (20, 'KFC', NULL);
INSERT INTO SPONSOR_MCO VALUES (30, 'ADOBE', 'adobe@adobe.com');
INSERT INTO SPONSOR_MCO VALUES (40, 'BRD', NULL);
INSERT INTO SPONSOR_MCO VALUES (50, 'VODAFONE', 'vdf@gmail.com');
INSERT INTO SPONSOR_MCO VALUES (60, 'BCR', NULL);
INSERT INTO SPONSOR_MCO VALUES (70, 'SAMSUNG', NULL);
INSERT INTO SPONSOR_MCO VALUES (80, 'IBM', 'ibm@ibm.com');
INSERT INTO SPONSOR_MCO VALUES (90, 'OMV', NULL);
INSERT INTO SPONSOR_MCO VALUES (100, 'ENEL', NULL);

-- metoda EXPLICITA este folosita pentru tabela CAMPANIILOR
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (1, 'CAMP1', sysdate, TO_DATE('20-06-2025', 'DD-MM-YYYY'), 1200, 10);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (2, 'CAMP2', sysdate, TO_DATE('25-07-2025', 'DD-MM-YYYY'), 3400, 20);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (3, 'CAMP3', sysdate, TO_DATE('10-06-2025', 'DD-MM-YYYY'), NULL, 30);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (4, 'CAMP4', sysdate, TO_DATE('20-06-2025', 'DD-MM-YYYY'), NULL, 40);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (5, 'CAMP5', sysdate, TO_DATE('05-06-2025', 'DD-MM-YYYY'), 2200, 50);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (6, 'CAMP6', sysdate, TO_DATE('15-08-2025', 'DD-MM-YYYY'), NULL, 60);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (7, 'CAMP7', sysdate, TO_DATE('02-09-2025', 'DD-MM-YYYY'), 5500, 70);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (8, 'CAMP8', sysdate, TO_DATE('10-10-2025', 'DD-MM-YYYY'), NULL, 20);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (9, 'CAMP9', sysdate, TO_DATE('10-06-2025', 'DD-MM-YYYY'), 4000, 30);
INSERT INTO CAMPANIE_MCO (cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor)
VALUES (10, 'CAMP10', sysdate, TO_DATE('25-09-2025', 'DD-MM-YYYY'), 3500, NULL);

COMMIT;
SELECT * FROM CAMPANIE_MCO;
SELECT * FROM SPONSOR_MCO;


-- Ex. 6
-- Sa se stearga campaniile care vor expira inainte de data 01-07-2025.
-- Se va adauga un print screen cu rezultatele ramase in urma stergerii, dupa care se vor anula modificarile.

DELETE FROM CAMPANIE_MCO
WHERE data_end < TO_DATE('01-07-2025', 'DD-MM-YYYY');

SELECT * FROM CAMPANIE_MCO;
ROLLBACK;

 
-- Ex. 7
-- Sa se modifice valoarea tuturor campaniilor, aplicandu-se o majorare cu 25%. Daca o campanie nu are valoare,
-- atunci ea este o campanie caritabila si se va completa cu textul "Campanie Caritabila".
-- Se va atasa in document un print cu valorile modificate (output-ul dupa rulare), dupa care se vor anula modificarile.

UPDATE CAMPANIE_MCO -- pasul initial, pentru valori nenule
SET valoare = valoare * 1.25
WHERE valoare IS NOT NULL;

UPDATE CAMPANIE_MCO -- pasul secundar, actualizam titlul 
SET titlu = titlu || ' - Campanie Caritabila'
WHERE valoare IS NULL;

SELECT * FROM CAMPANIE_MCO;
ROLLBACK;


-- Ex. 8
-- Sa se stearga sponsorul 20 din baza de date. Explicati, in cuvinte, pasii necesari pentru rezolvarea cu succes a cerintei.
-- Dupa stergere, anulati modificarile.

UPDATE CAMPANIE_MCO -- inainte de a fi sters sponsorul cu codul 20 din baza de date,
SET cod_sponsor = NULL -- trebuie sa fie sterse toate cheile straine din tabelul campaniilor
WHERE cod_sponsor = 20; -- sunt schimbate in NULL toate aparitiile codului 20
SELECT * FROM CAMPANIE_MCO; -- se pot observa schimbarile facute in tabelul campaniilor

DELETE FROM SPONSOR_MCO -- de abia acum putem sterge fara probleme
WHERE cod_sponsor = 20; -- sponsorul cu numarul de cod 20
SELECT * FROM SPONSOR_MCO; -- se poate observa stergerea in tabelul sponsorilor

ROLLBACK; -- anulam modificarile
SELECT * FROM CAMPANIE_MCO; -- verificam
SELECT * FROM SPONSOR_MCO; -- anularea modificarilor


-- Ex. 9 
-- Stergeti sponsorii care nu sponsorizeaza nicio campanie.
-- Dupa stergere, realizati un print screen al output-ului (SELECT * FROM sponsor), dupa care salvati modificarile.

SELECT cod_sponsor -- verificarea sponsorilor de sters
FROM SPONSOR_MCO -- 80, 90, 100
WHERE cod_sponsor NOT IN ( SELECT cod_sponsor
                            FROM CAMPANIE_MCO
                            WHERE cod_sponsor IS NOT NULL
                            );

DELETE FROM SPONSOR_MCO
WHERE cod_sponsor NOT IN (SELECT cod_sponsor
                          FROM CAMPANIE_MCO
                          WHERE cod_sponsor IS NOT NULL
                          );
                          
SELECT * FROM SPONSOR_MCO;
COMMIT;
