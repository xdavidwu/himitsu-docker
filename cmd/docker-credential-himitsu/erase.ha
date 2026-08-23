use bufio;
use himitsu::client;
use himitsu::query;
use net;
use os;

fn erase(hi: net::socket) void = {
	const scanner = bufio::newscanner(os::stdin, os::BUFSZ, bufio::scan_options::EOF_GREEDY);
	defer bufio::finish(&scanner);
	const url = bufio::scan_line(&scanner)! as const str;

	const query = build_query(url, "", "")!;
	defer query::finish(&query);
	drain_query(&client::query(hi, client::operation::DEL, &query, 0)!)!;
};
