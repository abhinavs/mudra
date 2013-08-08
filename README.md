# mudra - virtual currency management API

## API Reference

### Create a new app
<pre>DEFINITION
POST https://mudra.abhinav.co/v1/apps

EXAMPLE REQUEST
$ curl -X POST https://mudra.abhinav.co/v1/apps \
     -d "name=my app" \
     -d "description=my optional app description" \
     -d "guid=optional-unique-uid"

EXAMPLE RESPONSE
{
  "id" : 9999,
  "name" : "my app",
  "description" : "my optional app description",
  "guid" : "optional-unique-uid",
  "app_key": "ak_db0eaf8e5d11e6878f96cdcbe2a9de3228622f29"
}
</pre>


### Copyright

Copyright (c) 2013 Abhinav Saxena. See LICENSE for details.
