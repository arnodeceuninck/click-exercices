#include <click/config.h>
#include <click/args.hh>
#include <click/error.hh>
#include "fixipdst.hh"

CLICK_DECLS
FixIpDst::FixIpDst()
{}

FixIpDst::~ FixIpDst()
{}

int FixIpDst::configure(Vector<String> &conf, ErrorHandler *errh) {
    // Groot deel van de code van fixipsrc
    IPAddress a;
    if (Args(conf, this, errh).read_mp("IPADDR", a).complete() < 0)
	return -1;
    _my_ip = a.in_addr();
    return 0;
}

void FixIpDst::push(int, Packet *p){
  WritablePacket *p = p_in->uniqueify();
  click_ip *ip = p->ip_header();
  ip->ip_dst = _my_ip;
  int hlen = ip->ip_hl << 2;
  ip->ip_sum = 0;
  ip->ip_sum = click_in_cksum((unsigned char *)ip, hlen);
  output(0).push(p);
}

CLICK_ENDDECLS
EXPORT_ELEMENT(FixIpDst)
