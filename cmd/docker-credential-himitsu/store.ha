use encoding::json;
use himitsu::client;
use himitsu::query;
use net;
use os;
use strings;

fn store(hi: net::socket) void = {
	const json = json::load(os::stdin)! as json::object;
	defer json::finish(json);
	const url = *(json::get(&json, "ServerURL") as *json::value) as str;
	const username = *(json::get(&json, "Username") as *json::value) as str;
	const secret = *(json::get(&json, "Secret") as *json::value) as str;

	const query = build_query(url, username, secret)!;
	defer query::finish(&query);

	(match (drain_query(&client::query(hi, client::operation::ADD, &query, 0)!)) {
	case let e: client::hierror =>
		if (strings::compare(e, DUP_ERROR) == 0) {
			const public_query = query::dup_pub(&query)!;
			defer query::finish(&public_query);
			drain_query(&client::update(hi, &public_query, &query, 0)!)!;
			return;
		};
		yield e;
	case let e: client::error =>
		yield e;
	case void =>
		yield;
	})!;
};
