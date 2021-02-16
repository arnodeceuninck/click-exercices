AddressInfo(sourceAddr 10.0.0.1 1A:7C:3E:90:78:41)
AddressInfo(responderAddr 10.0.0.2 1A:7C:3E:90:78:42)

source::ICMPPingSource(sourceAddr, responderAddr);
responder::ICMPPingResponder;
switch::ListenEtherSwitch


elementclass Router { $src | 
	
	querier::ARPQuerier($src);
	responder::ARPResponder($src);

	// Match arp request, arp reply, ip pakketten
	// Maakt zeker dat we met IP bezig zijn
	arpclass::Classifier(12/0806 20/0001, 12/0806 20/0002, -); // queries, responses, data
	
	input [0]
	    // Komt van het netwerk en moet naar de switch, foute plaats
	    -> [0]querier;

	querier
		-> [0]output;

	input [1]
	    // Komt van het netwerk, maar nog te vroeg
	    // In arpclass wordt gekeken of het wel IP is
	    // Hier is het dus nog niet zeker of het al IP is
		-> arpclass;
		
	arpclass[0] // queries
		-> responder
		// Hier worden pakketten naar het netwerk gestuurd
		// Moet bij van het netwerk verlaagd worden
		// Uit de responder kunnen ook ARP pakketten komen
		-> [0]output; // to network
  	
	arpclass[1] // replies
		-> [1]querier;
	
	arpclass[2] // data
		-> filter::HostEtherFilter($src);
		
	filter[0]
		-> Strip(14)
		-> MarkIPHeader
		// Zit achter deze filter, zit achter de ARP Classifier
		// src: https://github.com/kohler/click/wiki/DecIPTTL
		-> DecIPTTL // Juiste oplossing
		-> [1] output

	filter[1]
		-> Discard;
}

source
	-> [0] sourceRouter::Router(sourceAddr) [0]
	-> [0] switch
	
switch[0]
	-> [1] sourceRouter [1]
	-> source

responder
	-> [0] responderRouter::Router(responderAddr) [0]
	-> [1] switch	
	
switch[1]
	-> [1] responderRouter [1]
	-> responder

switch[2]
	-> ToDump(switch.pcap)
	-> Discard



