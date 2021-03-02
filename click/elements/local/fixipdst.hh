#ifndef CLICK_FixIpDst_HH
#define CLICK_FixIpDst_HH
#include <click/element.hh>
CLICK_DECLS

class FixIpDst : public Element {
    struct in_addr _my_ip;
	public:
		FixIpDst();
		~FixIpDst();
		
		const char *class_name() const	{ return "FixIpDst"; }
		const char *port_count() const	{ return "1/1"; }
		const char *processing() const	{ return PUSH; }
		int configure(Vector<String>&, ErrorHandler*);
		
		void push(int, Packet *);
	private:
		uint32_t maxSize;
};

CLICK_ENDDECLS
#endif
