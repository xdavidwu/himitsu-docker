use bufio;
use encoding::json;
use fmt;
use himitsu::client;
use himitsu::query;
use net;
use os;
use shlex;
use strings;

fn get(hi: net::socket) void = {
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
	};
	const iter = client::query(hi, client::operation::QUERY, &query, client::flags::DECRYPT)!;
	const json = json::newobject();
	defer json::finish(json);
	const query = match (client::next(&iter)!) {
	case done =>
		// see go github.com/docker/docker-credential-helpers/client
		// client.go
		fmt::println("credentials not found in native keychain")!;
		os::exit(255);
	case let q: query::query =>
		yield q;
	};
	defer query::finish(&query);
	let secreti = 0z, usernamei = 0z;
	for (let i = 0z; i < len(query.items); i += 1) {
		if (strings::compare(query.items[i].key, "secret") == 0) {
			secreti = i;
		} else if (strings::compare(query.items[i].key, "username") == 0) {
			usernamei = i;
		};
	};
	json::set(&json, "SeverURL", url);
	json::set(&json, "Username", query.items[usernamei].value);
	json::set(&json, "Secret", query.items[secreti].value);
	json::dump(os::stdout, json)!;
};
