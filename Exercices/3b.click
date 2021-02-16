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
		-> [1] output

	filter[1]
		-> Discard;
}

source
	-> [0] sourceRouter::Router(sourceAddr) [0]
	-> [0] switch

// Genereer UDP Pakketten en stuur die naar het netwerk
sourceUDP::FastUDPSource(RATE 5, LIMIT 200, LENGTH 60, SRCETH sourceAddr, SRCIP sourceAddr, SPORT 1234, DSTETH responderAddr, DSTIP responderAddr, DPORT 1234); // Kan dit korter?
sourceUDP
    -> Unqueue
	-> [0] sourceRouter [0]
	-> [0] switch

switch[0]
	-> [1] sourceRouter [1]
	-> source

responder
	-> [0] responderRouter::Router(responderAddr) [0]
	// Als de UDPHeader niet klopt, stuur verder, anders Discard
	-> checkUDP::CheckUDPHeader[1] // Push output
	-> [1] switch

checkUDP[0]
    -> Discard

switch[1]
	-> [1] responderRouter [1]
	-> responder

switch[2]
	-> ToDump(switch.pcap)
	-> Discard

