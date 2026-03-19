SELECT * FROM clienti; 
SELECT * FROM meniu;
SELECT * FROM produse_alimentare;
SELECT * FROM comenzi;
SELECT * FROM produs_comanda;
SELECT * FROM recenzie_produs;

-- Ex. 1
SELECT co.id_comanda, co.id_client, co.data, cli.nume, pa.nume, pa.pret
FROM comenzi co RIGHT JOIN clienti cli ON (co.id_client = cli.id_client)
                LEFT JOIN produs_comanda prc ON (co.id_comanda = prc.id_comanda)
                LEFT JOIN produse_alimentare pa ON (prc.id_produs = pa.id_produs)
ORDER BY co.id_comanda, pa.pret DESC; 

-- Ex. 2
SELECT co.id_comanda, co.data, co.ora, co.pret_total, aux.nr_produse
FROM comenzi co JOIN
    (SELECT id_comanda, COUNT(id_produs) nr_produse FROM produs_comanda GROUP BY id_comanda) aux
    ON (co.id_comanda = aux.id_comanda)
WHERE nr_produse > 1;

-- Ex. 3
SELECT DISTINCT cli.id_client, cli.nume, cli.prenume, interim.sum_tot_un_prod
FROM clienti cli JOIN comenzi co ON (cli.id_client = co.id_client)
                 JOIN (SELECT id_client, COUNT(id_comanda) nr_prod
                        FROM comenzi GROUP BY id_client) cl_com
                ON (cl_com.id_client = cli.id_client)
                JOIN (SELECT c.id_client idcl, SUM(c.pret_total) sum_tot_un_prod
                        FROM comenzi c JOIN (SELECT id_comanda, COUNT(id_produs) nr_produse
                        FROM produs_comanda
                        GROUP BY id_comanda) aux
                        ON (c.id_comanda = aux.id_comanda)
                        WHERE aux.nr_produse = 1
                        GROUP BY c.id_client) interim
                ON (interim.idcl = cli.id_client)
                WHERE cl_com.nr_prod = (SELECT MAX(COUNT(id_comanda)) FROM comenzi GROUP BY id_client);

-- Ex. 4
SELECT DISTINCT c.ID_CLIENT
FROM COMENZI c JOIN PRODUS_COMANDA pc ON c.ID_COMANDA = pc.ID_COMANDA
               JOIN PRODUSE_ALIMENTARE p ON pc.ID_PRODUS = p.ID_PRODUS
WHERE p.ID_MENIU = (SELECT ID_MENIU
                    FROM MENIU
                    WHERE UPPER(TITLU) = 'MIC DEJUN CLASIC'
                    )
MINUS SELECT DISTINCT c.ID_CLIENT
FROM COMENZI c JOIN PRODUS_COMANDA pc ON c.ID_COMANDA = pc.ID_COMANDA
               JOIN PRODUSE_ALIMENTARE p ON pc.ID_PRODUS = p.ID_PRODUS
WHERE p.ID_MENIU != (SELECT ID_MENIU
                    FROM MENIU
                    WHERE UPPER(TITLU) = 'MIC DEJUN CLASIC'
                    );

-- Ex. 5
CREATE TABLE COMENZI_CLIENTI_PREMIUM (
id_comanda NUMBER,
data DATE,
ora VARCHAR2(8),
pret_total NUMBER(7,2),
id_client NUMBER,
nume_client VARCHAR2(50),
prenume_client VARCHAR2(50),
nume_produs VARCHAR2(100)
);

INSERT INTO COMENZI_CLIENTI_PREMIUM (
id_comanda, data, ora, pret_total,
id_client, nume_client, prenume_client,
nume_produs
) SELECT DISTINCT co.id_comanda, co.data, co.ora, co.pret_total,
        cli.id_client, cli.nume nume_client, cli.prenume prenume_client,
        alim.nume nume_produs
FROM comenzi co JOIN clienti cli ON (co.id_client = cli.id_client)
                JOIN produs_comanda prod ON (prod.id_comanda = co.id_comanda)
                JOIN produse_alimentare alim ON (alim.id_produs = prod.id_produs)
WHERE co.pret_total IN (SELECT pret_total
                        FROM comenzi
                        ORDER BY pret_total DESC
                        FETCH FIRST 3 ROWS ONLY
                        );
                        
-- Ex. 6
SELECT cl.ID_CLIENT, cl.NUME, cl.PRENUME, t2.NUMAR_TOTAL_PRODUSE, t1.SUMA_TOTALA, t2.MENIURI_DISTINCTE
FROM (SELECT ID_CLIENT, SUM(PRET_TOTAL) AS SUMA_TOTALA, COUNT(*) AS NR_COMENZI
        FROM COMENZI GROUP BY ID_CLIENT HAVING COUNT(*) >= 2) t1
JOIN
(SELECT c.ID_CLIENT, SUM(pc.CANTITATE) AS NUMAR_TOTAL_PRODUSE, COUNT(DISTINCT pa.ID_MENIU) AS MENIURI_DISTINCTE
    FROM COMENZI c JOIN PRODUS_COMANDA pc ON (c.ID_COMANDA = pc.ID_COMANDA)
    JOIN PRODUSE_ALIMENTARE pa ON (pc.ID_PRODUS = pa.ID_PRODUS)
    GROUP BY c.ID_CLIENT) t2
ON t1.ID_CLIENT = t2.ID_CLIENT
JOIN CLIENTI cl ON cl.ID_CLIENT = t1.ID_CLIENT
WHERE t1.SUMA_TOTALA > (SELECT AVG(PRET_TOTAL) FROM COMENZI)
ORDER BY t1.SUMA_TOTALA DESC;
