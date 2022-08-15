use bufio;
use encoding::json;
use himitsu::client;
use himitsu::query;
use os;
use shlex;
use strings;

fn get() void = {
	const hi = client::connect()!;
	const url = strings::fromutf8(bufio::scanline(os::stdin)! as []u8);
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
	const res = match (client::next(&iter)!) {
	case void =>
		return;
	case let s: const str =>
		yield s;
	};
	const parts = shlex::split(res)!;
	defer strings::freeall(parts);
	const query = query::parse_items(parts)!;
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