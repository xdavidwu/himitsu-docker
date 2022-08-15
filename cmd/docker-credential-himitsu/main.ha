use os;

export fn main() void = {
	assert(len(os::args) == 2);
	switch (os::args[1]) {
	case "store" =>
		store();
	case "get" =>
		get();
	case "erase" =>
		erase();
	case "list" =>
		list();
	case =>
		assert(false);
	};
};
