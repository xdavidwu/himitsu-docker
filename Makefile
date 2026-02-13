docker-credential-himitsu:
	hare build cmd/docker-credential-himitsu

test:
	hare test cmd/docker-credential-himitsu

.PHONY: docker-credential-himitsu test
