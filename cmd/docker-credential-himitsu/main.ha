use os;

export fn main() void = {
	assert(len(os::args) == 2);
	switch (os::args[1]) {
	case "list" =>
		list();
	case =>
		assert(false);
	};
};
