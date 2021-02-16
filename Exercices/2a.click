AddressInfo(sourceAddr 10.0.0.1 1A:7C:3E:90:78:41)
AddressInfo(responderAddr 10.0.0.2 1A:7C:3E:90:78:42)

source::ICMPPingSource(sourceAddr, responderAddr);
responder::ICMPPingResponder;
switch::ListenEtherSwitch


elementclass Router { $src | 
	
	querier::ARPQuerier($src);
	responder::ARPResponder($src);

	// Splits het verkeer in 3 stukken, match1, match2, al de rest (-)
	arpclass::Classifier(12/0806 20/0001, 12/0806 20/0002, -); // queries, responses, data
	
	input [0] // Wat de host genereert van paketten en naarbuiten moet
		// Hier passeren niet alle paketten, enkel de gegenereerde
		// MAC header is er hier ook niet bij
		-> [0]querier;

	querier
		-> [0]output;

	input [1] // Komt van switch (netwerk)
	    // src: https://github.com/kohler/click/wiki/Print
	    // Input en output 0 kan je laten vallen
	    -> [0]Print[0]
	    // ARPPrint dient voor ARP paketten, hier weten we niet welk soort pakketten er binnen komen
	    // Idem voor IPPrint
		-> arpclass;
		
	arpclass[0] // queries
		-> responder
		// Paketten zijn hier al gefilterd door ARPClassifier
		-> [0]output; // to network
  	
	arpclass[1] // replies
	    // Hier zit je ook al achter de classifier en zijn de paketten dus al gefilterd
		-> [1]querier;
	
	arpclass[2] // data
		-> filter::HostEtherFilter($src);
		
	filter[0]
	    // Hier komen ook niet alle pakketten, zitten reeds achter een filter
	    // Filter gooit alle paketten die niet voor u bestemd zijn weg
	    // En hier komt dus enkel het verkeer voor u, niet al het verkeer dat voorbij komt
		-> Strip(14)
		-> MarkIPHeader
		-> [1] output

	filter[1]
		-> Discard;
}

source
    // Hier geen print omdat niet alle paketten hier passeren
    // en de mac header hier ook nog ontbreekt
	-> [0] sourceRouter::Router(sourceAddr) [0]
	-> [0] switch
	
switch[0] // stuurt naar input 1 source
	-> [1] sourceRouter [1]
	-> source

responder
	-> [0] responderRouter::Router(responderAddr) [0]
	-> [1] switch	
	
switch[1] // stuurt naar input 1 responder
	-> [1] responderRouter [1]
	-> responder

switch[2]
	-> ToDump(switch.pcap)
	-> Discard



