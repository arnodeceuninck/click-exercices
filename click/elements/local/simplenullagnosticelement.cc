#include <click/config.h>
#include <click/args.hh>
#include <click/error.hh>
#include "simplenullagnosticelement.hh"

CLICK_DECLS
SimpleNullAgnosticElement::SimpleNullAgnosticElement()
{}

SimpleNullAgnosticElement::~ SimpleNullAgnosticElement()
{}

int SimpleNullAgnosticElement::configure(Vector<String> &conf, ErrorHandler *errh) {
	return 0;
}

void SimpleNullAgnosticElement::push(int, Packet *p){
	output(0).push(p);
}

Packet* SimpleNullAgnosticElement::pull(int){
	Packet* p = input(0).pull();
	if(p == 0){
		return 0;
	}
	return p;
}

CLICK_ENDDECLS
EXPORT_ELEMENT(SimpleNullAgnosticElement)
