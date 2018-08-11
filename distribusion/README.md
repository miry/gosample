Implement library to parse data from the service and upload in unified format.

## `GET /routes`

### Params

- `passphrase` - string.
- `source` - string. possible values: sentinels, sniffers, loopholes

### Response

Return a zip file

```
HTTP/1.1 200 OK
Content-Disposition: attachment; filename*=UTF-8''sentinels
Content-Length: 996
Content-Type: application/zip
....
```

## `POST /routes`

### Params

- `passphrase` - string.
- `source` - string. possible values: sentinels, sniffers, loopholes
- `start_node` - alphanumeric code. values: alpha, beta, gamma, delta, theta, lambda, tau, psi, omega
- `end_node` - alphanumeric code. values: alpha, beta, gamma, delta, theta, lambda, tau, psi, omega
- `start_time` - ISO 8601 UTC time. YYYY-MM-DDThh:mm:ss
- `end_time` - ISO 8601 UTC time. YYYY-MM-DDThh:mm:ss

### Response

- 201
- 422
- 500


TODO
====

- [ ] Setup ruby application structure
- [ ] Setup logger
- [ ] Load Sentinel records
- [ ] Load Sniffers records
- [ ] Load Loopholes records
- [ ] Upload Sentinel records
- [ ] Upload Sniffers records
- [ ] Upload Loopholes records


Activities
==========

11 Aug 13:00:  Started
