#ifndef CLICK_SIMPLENULLAGNOSTICELEMENTEMPTYSTRING_HH
#define CLICK_SIMPLENULLAGNOSTICELEMENTEMPTYSTRING_HH
#include <click/element.hh>
CLICK_DECLS

class SimpleNullAgnosticElementEmptyString : public Element { 
	public:
		SimpleNullAgnosticElementEmptyString();
		~SimpleNullAgnosticElementEmptyString();
		
		const char *class_name() const	{ return "SimpleNullAgnosticElementEmptyString"; }
		const char *port_count() const	{ return "1/1"; }
		const char *processing() const	{ return AGNOSTIC; }
		int configure(Vector<String>&, ErrorHandler*);
		
		void push(int, Packet *);
		Packet* pull(int);
	private:
		uint32_t maxSize;
};

CLICK_ENDDECLS
#endif
