# click-exercises

## Grafische weergave
```shell
tools/click-flatten/click-flatten ping-1.click | tools/click-pretty/click-pretty --dot | dot -Tpng > ping-1.png
```
Note: Zonder de flatten worden compound elements een zwarte doos en zie je dus niet wat erin zit. 
- Bovenste blokjes: input poorten 
- Middenste blok: naam element
- Onderste blokjes: output element

## Oplossingen
De kleurcodes die gebruikt worden in de oplossingen van de assistent
- BLauw: Juist
- Oranje: Fout (te vroeg, maar heeft misschien wel juist gedrag)
- Rood: Fout

## Blokjes
Specifieker toegepast op ping 5 scriptje
### ARPQuerier
Voegt een Ethernet Header ervoor toe met de src en dst. Vraag naar Netwerk wie (MAC) het gegeven IP adres heeft. 
### LIstenEtherSwitch
Switch, 3e poort passeert alle output (dacht ik)
### ToDump
Schrijft alles weg in een PCap file (Dat je met Wireshark kan analyseren)
### responderRouter/arpclass::Classifier
Splits verkeer in 3 stukken: ARP Requests, ARP replies.
### sourceRouter/arpclass::Classifier
Doet hetzelfde, output van poort 2 (responses), gaan naar ARPQuerier, zodat die alle info heeft om in te vullen en stuurt het ping pakket van ICMPPingSource naar buiten. 
### ARPResponder
Kijkt of het voor zijn IP adres is en stuurt een reply buiten als dit het geval is
### HostEtherFilter
Kijkt of het voor mij is, indien niet wordt het weggegooid
### MarkIPHeader
Zet een annotatie: Hier begint een IP header
### ICMPPingResponder
Stuurt een reply
### ICMPPingSource
Verstuurt het initiele request, en ontvangt ook de uiteindelijke reply

## Handlers
Laten dingen aanpassen zonder dat je de router moet stoppen. 

In Click zit een Telnet server (voorganger van ssh (zonder security)). Deze moet je aanzetten om handlers te kunnen gebruiken.
Om dit op te zetten, voeg je de parameter `-p 10000` mee, hierbij is `10000` een zelfgekozen poort. Zo krijgen we bv. hetvolgende:
```shell
../userlevel/click -p 10000 ping-5.click
```
Je ziet geen verschil met normaal. 
Nu kan je een nieuw terminal window openen en vanuit `click/scripts` kan je telnet gebruiken:
```shell
./telnet localhost 10000
```
Note: telnet staat default op ubuntu, dus `telnet localhost 10000` zou ook moeten werken
- ReadHandler: Om dingen op te vragen
- WriteHandler: Om dingen te gebruik
### ReadHandler
``` 
read [naam_element].[naam_handler]
```
Handlers voor een specifiek element kan je onder `ELEMENT HANDLERS`  in de docs terugvinden. Indien dit er niet is, heeft dit element geen handlers. 
#### Voorbeelden
- `read list` geeft een overzicht van alle handlers die je kan gebruiken. 
- `read sourceRouter/querier.queries` geeft terug hoeveel ARP Queries er verstuurd zijn.
- `read sourceRouter/querier.table` drukt de gecachte ARP tabel af (IP, MAC, Tijd in tabel)
- `quit` om te exitten, zodat je geen situaties zoals bij vim krijgt

# Oefeningen todo
2d (read handler gebruiken), 3abcd (op verschillende plekken elementen toevoegen)
3b: pas op met opzetten UDP stream, wordt allemaal naar pcap gedumpt en kan schijf dus rap volmaken