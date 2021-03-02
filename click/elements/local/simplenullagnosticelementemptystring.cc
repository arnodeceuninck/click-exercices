#include <click/config.h>
#include <click/args.hh>
#include <click/error.hh>
#include "simplenullagnosticelementEmptyString.hh"

CLICK_DECLS
SimpleNullAgnosticElementEmptyString::SimpleNullAgnosticElementEmptyString()
{}

SimpleNullAgnosticElementEmptyString::~ SimpleNullAgnosticElementEmptyString()
{}

int SimpleNullAgnosticElementEmptyString::configure(Vector<String> &conf, ErrorHandler *errh) {
    if (conf.size() > 0) return errh->error("HALLO JE CONFIGURATION STRING IS NIET LEEG.")
	return 0;
}

void SimpleNullAgnosticElementEmptyString::push(int, Packet *p){
	output(0).push(p);
}

Packet* SimpleNullAgnosticElementEmptyString::pull(int){
	Packet* p = input(0).pull();
	if(p == 0){
		return 0;
	}
	return p;
}

CLICK_ENDDECLS
EXPORT_ELEMENT(SimpleNullAgnosticElementEmptyString)
