use himitsu::query;

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
