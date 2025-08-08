use encoding::json;
use himitsu::client;
use himitsu::query;
use net;
use os;
use shlex;
use strings;

fn list(hi: net::socket) void = {
	const query = query::query {
		items = [
			query::pair { key = "proto", value = "docker", private = false, optional = false},
			query::pair { key = "host", value = "", private = false, optional = false},
			query::pair { key = "username", value = "", private = false, optional = false},
			query::pair { key = "secret", value = "", private = true, optional = false},
		],
		strict = false,
	};
	const iter = client::query(hi, client::operation::QUERY, &query, 0)!;
	const json = json::newobject();
	defer json::finish(json);
	for (const query => client::next(&iter)!) {
		defer query::finish(&query);
		let hosti = 0z, usernamei = 0z;
		for (let i = 0z; i < len(query.items); i += 1) {
			if (strings::compare(query.items[i].key, "host") == 0) {
				hosti = i;
			} else if (strings::compare(query.items[i].key, "username") == 0) {
				usernamei = i;
			};
		};
		json::set(&json, query.items[hosti].value, query.items[usernamei].value)!;
	};
	json::dump(os::stdout, json)!;
};
