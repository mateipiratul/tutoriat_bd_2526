-- TEST DE LABORATOR --
-- Cocu Matei-Iulian --
-- Grupa 152 --
-- Nr. 34 -- 
-- Subiect nr. 2 --


-- Ex. 1
-- Sa se afiseze o lista cu toti studentii (nume si prenume concatenate), alaturi de detaliile cursurilor la care sunt inscrisi: codul si denumirea institutiei, codul cursului, data inscrierii si tariful cursului. Pentru studentii care nu sunt inscrisi la niciun curs, se vor afisa doar detaiile studentului (numele si prenumele), restul coloanelor avand valoarea NULL.

SELECT DISTINCT insti.id "Cod institutie", insti.denumire "Denumire institutie",
       stud.nume||' '||stud.prenume "Nume Student",
       c.id "Cod curs",
       inscr.data_inscriere "Data inscriere",
       ta_cu.tarif "Tarif Curs"
FROM student stud LEFT JOIN student_inscriere st_in ON (stud.id = st_in.id_student)
                  JOIN inscriere inscr ON (st_in.id_inscriere = inscr.id)
                  JOIN curs c ON (inscr.id_curs = c.id)
                  JOIN institutie insti ON (insti.id = c.id_institutie)
                  JOIN tarif_curs ta_cu ON (c.id = ta_cu.id_curs)
-- union cu multimea studentilor care nu sunt inscrisi la nici un curs (cam fortat, dar corect)
-- nu imi ieseau join-urile cum trebuie
UNION
    SELECT NULL, NULL, stud.nume||' '||stud.prenume "Nume Student", NULL, NULL, NULL
        FROM student stud WHERE stud.id NOT IN (
        SELECT DISTINCT id FROM student stud
        JOIN student_inscriere st_in ON (st_in.id_student = stud.id));


-- Ex. 2
-- Pentru fiecare curs care are studenti inscrisi, sa se afiseze detalii despre institutie (ID, denumire, localitate) si curs (ID, denumire), impreuna cu numarul de inscrieri la cursul respectiv, dar numarand doar studentii care au domiciliul in aceeasi localitate cu institutia care organizeaza cursul.

SELECT insti.id "Id institutie", insti.denumire "Denumire Institutie", c.id "Id Curs", c.denumire "Denumirea Cursului",
    insti.localitate "Localitate Institutie", aux.nr_inscrieri "Numarul de inscrieri la cursul cerut"
FROM institutie insti JOIN curs c ON (insti.id = c.id_institutie)
                      JOIN (SELECT inscri.id_curs, COUNT(inscri.id) nr_inscrieri
                                FROM inscriere inscri JOIN student_inscriere st_in ON (inscri.id = st_in.id_inscriere)
                                                      JOIN student stud ON (st_in.id_student = stud.id)
                                                      JOIN curs c ON (inscri.id_curs = c.id)
                                                      JOIN institutie insti ON (c.id_institutie = insti.id)
                                                      WHERE stud.localitate_domiciliu = insti.localitate
                                GROUP BY inscri.id_curs) aux ON (c.id = aux.id_curs);

             
-- Ex. 3
-- Sa se afiseze institutiile (ID si denumire) care ofera exact aceleasi facilitati (sau a caror lista de facilitati este inclusa in lista de facilitati) pe care le ofera institutia cu cel mai mic numar total de studenti inscrisi la cursurile sale.

WITH nr_stud_insti AS (
        SELECT SUM(aux.nr_stud) numar_stude
        FROM institutie insti JOIN curs c ON (insti.id = c.id_institutie)
                              JOIN (
                                    SELECT c.id id_curs, COUNT(stud.id) nr_stud
                                    FROM curs c JOIN inscriere inscr ON (c.id = inscr.id_curs)
                                                JOIN student_inscriere st_in ON (inscr.id = st_in.id_inscriere)
                                                JOIN student stud ON (st_in.id_student = stud.id)
                                        GROUP BY c.id
                                    ) aux ON (aux.id_curs = c.id)
            GROUP BY insti.id, insti.denumire), -- nr. studenti inscrisi la toate cursurile pentru fiecare institutie
-- SELECT min(nr_stud_insti.numar_stude) FROM nr_stud_insti;
institutii_cu_studenti AS (
                    SELECT insti.id id_institutie, insti.denumire denumire_institutie, SUM(aux.nr_stud) numar_studenti
                    FROM institutie insti JOIN curs c ON (insti.id = c.id_institutie)
                                          JOIN (
                                                SELECT c.id id_curs, COUNT(stud.id) nr_stud
                                                FROM curs c JOIN inscriere inscr ON (c.id = inscr.id_curs)
                                                            JOIN student_inscriere st_in ON (inscr.id = st_in.id_inscriere)
                                                            JOIN student stud ON (st_in.id_student = stud.id)
                                                    GROUP BY c.id
                                                ) aux ON (aux.id_curs = c.id)
                        GROUP BY insti.id, insti.denumire),
institutia_nr_min_stud AS (SELECT * FROM institutii_cu_studenti
                            WHERE numar_studenti = (SELECT min(nr_stud_insti.numar_stude) FROM nr_stud_insti)),
facilitati_institutii AS (SELECT insti.id id_institutie, insti.denumire denumire_institutie, fac.denumire denumire_facilitate
                        FROM institutie insti JOIN institutie_facilitate inst_fac ON (inst_fac.id_institutie = insti.id)
                                              JOIN facilitate fac ON (fac.id = inst_fac.id_facilitate)),
facilitati_institutia_nr_min_stud AS ( SELECT denumire_facilitate FROM facilitati_institutii
                                        WHERE id_institutie = (SELECT id_institutie FROM institutia_nr_min_stud)
                                    )
-- un division folosind minus
SELECT id_institutie, denumire_institutie
    FROM facilitati_institutii
    WHERE denumire_facilitate IN (SELECT * FROM facilitati_institutia_nr_min_stud)
MINUS
SELECT id_institutie, denumire_institutie
    FROM facilitati_institutii
    WHERE denumire_facilitate NOT IN (SELECT * FROM facilitati_institutia_nr_min_stud);
                                    

-- Ex. 4
-- Creati un tabel nou numit NUMAR_FACILITATI_INSTITUTIE care sa contina codul institutiei, denumirea acesteia si numarul total de facilitati pe care le ofera. Inserati in acest tabel datele corespunzatoare calculate din tabelele existente. Afisati continutul noului tabel pentru a verifica inserarea, iar la final stergeti tabelul creat.

CREATE TABLE NUMAR_FACILITATI_INSTITUTIE(
    COD_INSTITUTIE NUMBER(5),
    NUME_INSTITUTIE VARCHAR2(100),
    NUMAR_FACILITATI NUMBER(5)
); -- crearea tabelului
DESC NUMAR_FACILITATI_INSTITUTIE; -- verificare tabel

-- inserarea datelor in tabel
INSERT INTO NUMAR_FACILITATI_INSTITUTIE (cod_institutie, nume_institutie, numar_facilitati)
SELECT insti.id, insti.denumire, nr_facilitati
    FROM institutie insti JOIN (SELECT id_institutie, COUNT(id_facilitate) nr_facilitati
    FROM institutie_facilitate GROUP BY id_institutie) aux ON (aux.id_institutie = insti.id);

SELECT * FROM NUMAR_FACILITATI_INSTITUTIE; -- verificare tabel
DROP TABLE NUMAR_FACILITATI_INSTITUTIE; -- stergerea tabelului
