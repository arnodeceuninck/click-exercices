#include <click/config.h>
#include <click/args.hh>
#include <click/error.hh>
#include "simplenullpushelement.hh"

CLICK_DECLS
SimpleNullPushElement::SimpleNullPushElement()
{}

SimpleNullPushElement::~ SimpleNullPushElement()
{}

int SimpleNullPushElement::configure(Vector<String> &conf, ErrorHandler *errh) {
    // Groot deel van de code van fixipsrc
    IPAddress a;
    if (Args(conf, this, errh).read_mp("IPADDR", a).complete() < 0)
	return -1;
    _my_ip = a.in_addr();
    return 0;
}

void SimpleNullPushElement::push(int, Packet *p){

  click_ip *ip = p->ip_header();
  ip->ip_src = _my_ip;
  int hlen = ip->ip_hl << 2;
  ip->ip_sum = 0;
  ip->ip_sum = click_in_cksum((unsigned char *)ip, hlen);
    output(0).push(p);
}

CLICK_ENDDECLS
EXPORT_ELEMENT(SimpleNullPushElement)
