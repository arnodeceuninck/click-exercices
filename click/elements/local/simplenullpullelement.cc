#include <click/config.h>
#include <click/args.hh>
#include <click/error.hh>
#include "simplenullpullelement.hh"

CLICK_DECLS
SimpleNullPullElement::SimpleNullPullElement()
{}

SimpleNullPullElement::~ SimpleNullPullElement()
{}

int SimpleNullPullElement::configure(Vector<String> &conf, ErrorHandler *errh) {
	return 0;
}

Packet* SimpleNullPullElement::pull(int){
	Packet* p = input(0).pull();
	if(p == 0){
		return 0;
	}
	return p;
}

CLICK_ENDDECLS
EXPORT_ELEMENT(SimpleNullPullElement)
