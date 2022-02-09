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

/*6. Il proprietario che possiede il minor totale di superficie di appartamenti e appartamento più piccolo posseduto*/


/*7. I proprietari che hanno il nome che inizia con L e il loro appartamento in cui hanno investito di più su spese speciali*/
select sum(spese.Importo) as totPagato, proprietari.Proprietario
from spese
inner join spesaspeciale on spesaspeciale.NSpesa = spese.NSpesa
inner join appartamenti on appartamenti.codApp = spesaspeciale.CodApp
inner join proprietari on proprietari.CodPro = appartamenti.CodPro
where proprietari.Proprietario like "L%"
group by proprietari.CodPro
order by sum(spese.Importo) desc
limit 3;

/*8. Gli appartamenti ordinati in maniera decrescente per media di superficie delle stanze*/
select CodApp, avg(Superficie/NVani) as mediaSuperficePerVano
from appartamenti
group by CodApp
order by avg(Superficie/NVani) desc;

/*9. Anno in cui si è speso di più in spese non speciali*/
select date_format(spese.DataSpesa, "%Y") as annoMaggiorSpeseNonSpeciali
from spese 
where NSpesa not in (	select NSpesa 
						from spesaspeciale)
group by date_format(spese.DataSpesa, "%Y")
having sum(Importo) = ( select max(spe.imp)
						from ( 	select sum(spese.importo) as imp
								from spese
								where NSpesa not in (	select NSpesa 
														from spesaspeciale)
								group by date_format(spese.DataSpesa, "%Y")) as spe);
	
/*10.Elenco degli inquilini che non sono proprietari di un appartamento*/
select Inquilino
from appartamenti
where Inquilino not in (	select Proprietario
							from proprietari) and Inquilino like "_%"; /*Qui ho messo questa condizione siccome l'appartamento 444 come inquilino c'è uno spazio vuoto che conta*/
                            
/*11.Trovare proprietario con più appartamenti*/
select proprietari.Proprietario
from proprietari
inner join appartamenti on appartamenti.CodPro = proprietari.CodPro
group by appartamenti.CodPro
having count(CodApp) = 	(	select max(conta.NumAppartamenti)
							from (	select count(CodApp) as NumAppartamenti
									from appartamenti
									group by CodPro) as conta);

/*12.Dati degli appartamenti che hanno una spesa maggiore della spesa speciale minima di un qualsiasi appartamento*/

/*13.La superficie che supera la media delle superfici di tutti gli appartamenti in cui il proprietario non è "Link" o "Zelda"*/
select appartamenti.Superficie, proprietari.Proprietario
from appartamenti
inner join proprietari on proprietari.CodPro = appartamenti.CodPro
where proprietario <> "Link" and proprietario <> "Zelda" and appartamenti.Superficie > (select avg(appartamenti.Superficie)
																						from appartamenti);

/*14.Stampare l'importo totale dei pagamenti effettuati da ogni singolo proprietario che superano 400€.*/
select CodPro, sum(Importo) as totPagamenti
from pagamenti
group by CodPro
having sum(Importo) > 400;

/*15.Elenco dei proprietari che non hanno eseguito pagamenti*/
select proprietari.Proprietario
from proprietari 
where proprietari.CodPro not  in (	select CodPro
									from pagamenti);
                                    
/*16.Totale pagamenti dei proprietari di appartamenti di superficie sopra la media*/
select sum(pagamenti.Importo) as totalePagamenti, Proprietario
from pagamenti
inner join appartamenti on appartamenti.CodPro = pagamenti.CodPro
inner join proprietari on proprietari.CodPro = pagamenti.CodPro
where appartamenti.Superficie > (	select avg(appartamenti.Superficie)
									from appartamenti)
group by appartamenti.CodPro;

/*17.Restituire il proprietario di ogni appartamento e la somma totale delle spese speciali.*/
select proprietari.Proprietario, sum(spese.Importo) as totSpese
from proprietari 
left join appartamenti on proprietari.CodPro=appartamenti.CodPro
left join spesaspeciale on spesaspeciale.CodApp=appartamenti.codApp
left join spese on spese.NSpesa=spesaspeciale.NSpesa
group by appartamenti.CodPro;

/*18.Restituire l’elenco degli Appartamenti per cui non sono state effettuate spese speciali, solo nel caso in cui il proprietario abbia saldo sufficiente per pagare le spese.*/




