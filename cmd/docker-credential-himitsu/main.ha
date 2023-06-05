use fmt;
use himitsu::client;
use net;
use os;

export fn main() void = {
	if (len(os::args) != 2) {
		fmt::fatalf("Usage: {} <store|get|erase|list>", os::args[0]);
	};

	const sock = match (client::connect()) {
	case let s: net::socket =>
		yield s;
	case let err: client::error =>
		fmt::fatalf("Cannot connect to himitsud: {}", client::strerror(err));
	};
	defer net::close(sock)!;

	switch (os::args[1]) {
	case "store" =>
		store(sock);
	case "get" =>
		get(sock);
	case "erase" =>
		erase(sock);
	case "list" =>
		list(sock);
	case =>
		fmt::fatalf("Usage: {} <store|get|erase|list>", os::args[0]);
	};
};
