/*1. Elenco dei proprietari che hanno pagato in ritardo.*/

/*2. Fornire i dati del proprietario che ha fatto più pagamenti.*/
select proprietari.CodPro, count(pagamenti.CodPro) as numeroPagamenti
from proprietari
inner join pagamenti on pagamenti.CodPro = proprietari.CodPro
group by proprietari.CodPro
having count(pagamenti.CodPro) = (	select max(conta.numeroPagamenti)
									from (	select count(pagamenti.CodPro) as numeroPagamenti
											from pagamenti 
											group by CodPro) as conta);

/*3. Il Proprietario che nel 2020 ha effettuato il pagamento con importo maggiore*/
select proprietari.CodPro, pagamenti.Importo
from proprietari
inner join pagamenti on pagamenti.CodPro = proprietari.CodPro
where pagamenti.Importo = (	select max(pagamenti.Importo)
							from pagamenti
							where pagamenti.DataPagam like "2019%");
                        
/*4. La data in cui l’importo totale delle spese è maggiore*/
select pagamenti.DataPagam
from pagamenti 
group by pagamenti.DataPagam
having sum(pagamenti.Importo) = (	select max(importoSum.sommaImporti)
									from (	select sum(Importo) as sommaImporti
											from pagamenti
											group by DataPagam) as importoSum);
                                            
/*5. I tre proprietari che hanno fatto più pagamenti (importo non quantità) nell’ultimo anno*/
select sum(pagamenti.Importo) as totImporti, pagamenti.CodPro
from pagamenti
where pagamenti.DataPagam like "2019%"
group by pagamenti.CodPro
order by sum(pagamenti.Importo) desc
limit 3;

/*6. Il proprietario che possiede il minor totale di superficie di appartamenti e
appartamento più piccolo posseduto*/

/*7. I proprietari che hanno il nome che inizia con L e il loro appartamento in cui hanno investito di più su spese speciali*/
select proprietari.CodPro
from proprietari
where proprietari.Proprietario like "L%" and (	select count(spese.Importo)
												from spese
                                                inner join spesaspeciale on spesaspeciale.NSpesa = spesaspeciale.NSpesa);






