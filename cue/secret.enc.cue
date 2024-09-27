apiVersion: "v1"
data: key: "ENC[AES256_GCM,data:zS0+sA==,iv:5+xNefdgi6ziJVms2uZdHPO497vcP1uW8B1OB7Uu18M=,tag:WQNJMfUbZmnqzQOOZ8+ukg==,type:str]"
kind: "Secret"
metadata: {
	name:              "test"
}
sops: {
	kms: []
	gcp_kms: []
	azure_kv: []
	hc_vault: []
	age: [{
		recipient: "age16xgyjnq3ded8wcvlycz9d9ag0d6uyufgtdh9h6px3sqs34ct5vsq6n9z2s"
		enc: """
			-----BEGIN AGE ENCRYPTED FILE-----
			YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBIeTJ6NXN5aEVyTE9tdllU
			OU9GK3ByTEU5UEhKekx3VWtaYnpVTzVQNTJjCnVINnYwTVB5NUVjd3o5UHVqR3Zp
			WHEvMXgzaVhnUmpzYk9WUEMzdUxyVU0KLS0tIE1mM25FYlBhVnMwWklZcGthcFN6
			dFJvKzY4TjhVZW15V1pUVk1EdGw3TlEKOMbGZArdWt7fqVHdY3s/5ClSzrrXd0eg
			qqmvT7IymzZidX71NkOdmmyYHn9lfyrj41JP2Xf0IFDPhD8O7QTcVA==
			-----END AGE ENCRYPTED FILE-----

			"""
	}]
	lastmodified: "2024-09-27T21:01:38Z"
	mac:          "ENC[AES256_GCM,data:rv3cj7j2XpnytsGnrNuJ82saRieJIyh3xyIZvMOflm2zS9bytTYpwyKKHxlCE2mv3g1+ZZ0bmoNO3dvzyMtBjZc/DKjcUrpme/jGRXogOhTWzwYlGJ6A5p7J7hfab2zox5zTvh0LktRm6izYOQGdG2JKDO0FFvyEdlEkt7Bkk2Y=,iv:wUTp8pbcmuBNx3/VoFpjatdjPY7YVW2HqHBqEBIsH3Q=,tag:7OyEn1ObDxSRp3YeBBV9zA==,type:str]"
	pgp: []
	encrypted_regex: "^(data|stringData)$"
	version:         "3.9.0"
}
