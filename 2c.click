AddressInfo(sourceAddr 10.0.0.1 1A:7C:3E:90:78:41)
AddressInfo(responderAddr 10.0.0.2 1A:7C:3E:90:78:42)

source::ICMPPingSource(sourceAddr, responderAddr);
responder::ICMPPingResponder;
switch::ListenEtherSwitch


elementclass Router { $src | 
	
	querier::ARPQuerier($src);
	responder::ARPResponder($src);
	arpclass::Classifier(12/0806 20/0001, 12/0806 20/0002, -); // queries, responses, data
	
	input [0]
		-> [0]querier;

	querier
		-> [0]output;

	input [1]
		-> arpclass;
		
	arpclass[0] // queries
		-> responder
		-> [0]output; // to network
  	
	arpclass[1] // replies
		-> [1]querier;
	
	arpclass[2] // data
		-> filter::HostEtherFilter($src);
		
	filter[0]
		-> Strip(14)
		-> MarkIPHeader
		// id's stijgen vanzelf, dus om te testen kan je gewoon kijken of de eerste 10 pakketten worden doorgelaten
		-> IPFilter(allow id <= 10, deny all) // src: https://github.com/kohler/click/wiki/IPFilter
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



