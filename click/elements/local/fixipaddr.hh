#ifndef CLICK_FixIpAddr_HH
#define CLICK_FixIpAddr_HH
#include <click/element.hh>
CLICK_DECLS

class FixIpAddr : public Element {
    struct in_addr _my_ip;
	public:
		FixIpAddr();
		~FixIpAddr();
		
		const char *class_name() const	{ return "FixIpAddr"; }
		const char *port_count() const	{ return "1/1"; }
		const char *processing() const	{ return PUSH; }
		int configure(Vector<String>&, ErrorHandler*);
		
		void push(int, Packet *);
	private:
		uint32_t maxSize;
};

CLICK_ENDDECLS
#endif
