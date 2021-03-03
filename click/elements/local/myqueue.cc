#include <click/config.h>
#include <click/args.hh>
#include <click/error.hh>
#include "myqueue.hh"

CLICK_DECLS
MyQueue::MyQueue()
{}

MyQueue::~ MyQueue()
{}

int MyQueue::configure(Vector<String> &conf, ErrorHandler *errh) {
    if (Args(conf, this, errh).read_m("LENGTH", length).complete() < 0) return -1;
    if (length <= 0) return errh->error("length should be larger than 0");
	return 0;
}

void MyQueue::push(int, Packet *p){
    if (queue.size() > length){
        ouput(1).push(p);
    } else {
        queue.push(p);
    }
}

Packet* MyQueue::pull(int){
    if (!queue.empty()) {
        Packet* p = queue.front();
        queue.pop()
        return p;
    } else {
        return 0;
    }
}

CLICK_ENDDECLS
EXPORT_ELEMENT(MyQueue)
