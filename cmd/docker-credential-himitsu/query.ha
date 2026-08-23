use himitsu::client;
use himitsu::query;

def DUP_ERROR = "The keystore does not allow duplicate entries";

fn build_query(url: str, username: str, secret: str) (query::query | nomem) = {
	const q = query::query {
		items = [
			query::pair { key = "proto", value = "docker", private = false, optional = false},
			query::pair { key = "host", value = url, private = false, optional = false},
			query::pair { key = "username", value = username, private = false, optional = false},
			query::pair { key = "secret", value = secret, private = true, optional = false},
		],
		strict = false,
	};
	return query::dup(&q);
};

fn drain_query(iter: *client::keyiter) (void | client::error) = {
	for (const query => client::next(iter)?) {
		query::finish(&query);
	};
};

fn first_query(iter: *client::keyiter) (query::query | done | client::error) = {
	const first = match (client::next(iter)?) {
	case done =>
		return done;
	case let q: query::query =>
		yield q;
	};

	drain_query(iter)?;

	return first;
};
