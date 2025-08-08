use bufio;
use himitsu::client;
use himitsu::query;
use net;
use os;

fn erase(hi: net::socket) void = {
	const scanner = bufio::newscanner(os::stdin, os::BUFSZ);
	defer bufio::finish(&scanner);
	const url = bufio::scan_line(&scanner)! as const str;
	const query = query::query {
		items = [
			query::pair { key = "proto", value = "docker", private = false, optional = false},
			query::pair { key = "host", value = url, private = false, optional = false},
			query::pair { key = "username", value = "", private = false, optional = false},
			query::pair { key = "secret", value = "", private = true, optional = false},
		],
		strict = false,
	};
	client::next(&client::query(hi, client::operation::DEL, &query, 0)!)!;
};
