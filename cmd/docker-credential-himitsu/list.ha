use encoding::json;
use himitsu::client;
use himitsu::query;
use io;
use memio;
use net;
use net::unix;
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

@test fn list() void = {
	const (s1, s2) = unix::socketpair()!;
	defer net::close(s1)!;
	defer net::close(s2)!;

	io::write(s2, strings::toutf8("key proto=docker host=example.org username=foo secret\nend\n"))!;
	list(s1);

	// TODO parse json
	assert(strings::fromutf8(memio::buffer(os::stdout: *memio::stream))! == "{\"example.org\":\"foo\"}");
};
