docker-credential-himitsu:
	HAREPATH=vendor/himitsu:${HAREPATH} hare build cmd/docker-credential-himitsu
.PHONY: docker-credential-himitsu
