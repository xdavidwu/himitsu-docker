use encoding::json;
use himitsu::client;
use himitsu::query;
use net;
use os;

fn store(hi: net::socket) void = {
	const json = json::load(os::stdin)! as json::object;
	defer json::finish(json);
	const url = *(json::get(&json, "ServerURL") as *json::value) as str;
	const username = *(json::get(&json, "Username") as *json::value) as str;
	const secret = *(json::get(&json, "Secret") as *json::value) as str;
	const query = query::query {
		items = [
			query::pair { key = "proto", value = "docker", private = false, optional = false},
			query::pair { key = "host", value = url, private = false, optional = false},
			query::pair { key = "username", value = username, private = false, optional = false},
			query::pair { key = "secret", value = secret, private = true, optional = false},
		],
		strict = false,
	};
	client::next(&client::query(hi, client::operation::ADD, &query, 0)!)!;
};
