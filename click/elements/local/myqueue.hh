#ifndef CLICK_MyQueue_HH
#define CLICK_MyQueue_HH
#include <click/element.hh>
#include <Queue>
CLICK_DECLS

class MyQueue : public Element { 
	public:
		MyQueue();
		~MyQueue();
		
		const char *class_name() const	{ return "MyQueue"; }
		const char *port_count() const	{ return "1/1"; }
		const char *processing() const	{ return "h/lh"; /*AGNOSTIC;*/ }
		int configure(Vector<String>&, ErrorHandler*);
		
		void push(int, Packet *);
		Packet* pull(int);
	private:
		uint32_t length;
		Queue<Packet*> queue;
};

CLICK_ENDDECLS
#endif
