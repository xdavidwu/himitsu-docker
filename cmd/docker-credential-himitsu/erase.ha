use bufio;
use himitsu::client;
use himitsu::query;
use net;
use os;
use strings;

fn erase(hi: net::socket) void = {
	const url = strings::fromutf8(bufio::scanline(os::stdin)! as []u8)!;
	const query = query::query {
		items = [
			query::pair { key = "proto", value = "docker", private = false, optional = false},
			query::pair { key = "host", value = url, private = false, optional = false},
			query::pair { key = "username", value = "", private = false, optional = false},
			query::pair { key = "secret", value = "", private = true, optional = false},
		],
	};
	client::next(&client::query(hi, client::operation::DEL, &query, 0)!)!;
};
