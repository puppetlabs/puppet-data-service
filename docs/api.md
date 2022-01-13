---
title: Puppet Data Service API v1.0.0
language_tabs:
  - shell: Shell
  - http: HTTP
  - javascript: JavaScript
  - ruby: Ruby
  - python: Python
  - php: PHP
  - java: Java
  - go: Go
toc_footers:
  - <a href="http://swagger.io">Find out more about Swagger</a>
includes: []
search: true
highlight_theme: darkula
headingLevel: 2

---

<!-- Generator: Widdershins v4.0.1 -->

<h1 id="puppet-data-service-api">Puppet Data Service API v1.0.0</h1>

> Scroll down for code samples, example requests and responses. Select a language for code samples from the tabs above or the mobile navigation menu.

This is the API documentation for the Puppet Data Service API. You can find out more about the [PDS API at here](https://github.com/puppetlabs/puppet-data-service). The PDS API uses Bearer Authentication, to generate a token for your admin user please run the ['set_admin_token' rake task](https://github.com/puppetlabs/puppet-data-service/tree/main/app#create-the-admin-token)

Base URLs:

* <a href="http://localhost:8080/v1">http://localhost:8080/v1</a>

<a href="http://swagger.io/terms/">Terms of service</a>
Email: <a href="mailto:solarch-team@puppet.com">Support</a> 
License: <a href="http://www.apache.org/licenses/LICENSE-2.0.html">TBD</a>

# Authentication

- HTTP Authentication, scheme: bearer 

<h1 id="puppet-data-service-api-users">users</h1>

Every config change should be started with an authorized Admin User

<a href="https://puppet.com/">TBD Find out more</a>

## getAllUsers

<a id="opIdgetAllUsers"></a>

> Code samples

```shell
# You can also use wget
curl -X GET http://localhost:8080/v1/users \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
GET http://localhost:8080/v1/users HTTP/1.1
Host: localhost:8080
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/users',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.get 'http://localhost:8080/v1/users',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.get('http://localhost:8080/v1/users', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','http://localhost:8080/v1/users', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/users");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "http://localhost:8080/v1/users", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /users`

*Get all available users*

This can only be done by the logged in user with an administrator role.

> Example responses

> 200 Response

```json
[
  {
    "username": "string",
    "email": "string",
    "role": "administrator",
    "status": "active",
    "created-at": "2019-08-24T14:15:22Z",
    "updated-at": "2019-08-24T14:15:22Z"
  }
]
```

<h3 id="getallusers-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|successful operation|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<h3 id="getallusers-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[allOf]|false|none|none|

*allOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[ImmutableUserProperties](#schemaimmutableuserproperties)|false|none|none|
|»» username|[Username](#schemausername)|false|none|none|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[EditableUserProperties](#schemaeditableuserproperties)|false|none|none|
|»» email|string¦null|false|none|none|
|»» role|string|false|none|User role|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[ReadOnlyUserProperties](#schemareadonlyuserproperties)|false|none|none|
|»» status|string|false|none|User status|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|
|»» created-at|string(date-time)|false|none|none|
|»» updated-at|string(date-time)|false|none|none|

#### Enumerated Values

|Property|Value|
|---|---|
|role|administrator|
|role|operator|
|status|active|
|status|inactive|
|status|deleted|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## createUser

<a id="opIdcreateUser"></a>

> Code samples

```shell
# You can also use wget
curl -X POST http://localhost:8080/v1/users \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
POST http://localhost:8080/v1/users HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "resources": [
    {
      "username": "string",
      "email": "string",
      "role": "administrator"
    }
  ]
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/users',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.post 'http://localhost:8080/v1/users',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.post('http://localhost:8080/v1/users', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','http://localhost:8080/v1/users', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/users");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "http://localhost:8080/v1/users", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /users`

*Create user*

The body params are required to be a JSON object with an array of users. This endpoint supports bulk operations, you can create one or 1000 users in a single POST request.

> Body parameter

```json
{
  "resources": [
    {
      "username": "string",
      "email": "string",
      "role": "administrator"
    }
  ]
}
```

<h3 id="createuser-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|false|Create user resources|
|» resources|body|[allOf]|false|none|
|»» *anonymous*|body|[ImmutableUserProperties](#schemaimmutableuserproperties)|false|none|
|»»» username|body|[Username](#schemausername)|false|none|
|»» *anonymous*|body|[EditableUserProperties](#schemaeditableuserproperties)|false|none|
|»»» email|body|string¦null|false|none|
|»»» role|body|string|false|User role|
|»» *anonymous*|body|object|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|»»» role|administrator|
|»»» role|operator|

> Example responses

> 201 Response

```json
[
  {
    "username": "string",
    "email": "string",
    "role": "administrator",
    "status": "active",
    "created-at": "2019-08-24T14:15:22Z",
    "updated-at": "2019-08-24T14:15:22Z"
  }
]
```

<h3 id="createuser-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Created|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|{ 'error': 'Bad Request. Unable to create requested users, check for duplicate users'}|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<h3 id="createuser-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[allOf]|false|none|none|

*allOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[ImmutableUserProperties](#schemaimmutableuserproperties)|false|none|none|
|»» username|[Username](#schemausername)|false|none|none|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[EditableUserProperties](#schemaeditableuserproperties)|false|none|none|
|»» email|string¦null|false|none|none|
|»» role|string|false|none|User role|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[ReadOnlyUserProperties](#schemareadonlyuserproperties)|false|none|none|
|»» status|string|false|none|User status|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|
|»» created-at|string(date-time)|false|none|none|
|»» updated-at|string(date-time)|false|none|none|

#### Enumerated Values

|Property|Value|
|---|---|
|role|administrator|
|role|operator|
|status|active|
|status|inactive|
|status|deleted|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## getUserByUsername

<a id="opIdgetUserByUsername"></a>

> Code samples

```shell
# You can also use wget
curl -X GET http://localhost:8080/v1/users/{username} \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
GET http://localhost:8080/v1/users/{username} HTTP/1.1
Host: localhost:8080
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/users/{username}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.get 'http://localhost:8080/v1/users/{username}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.get('http://localhost:8080/v1/users/{username}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','http://localhost:8080/v1/users/{username}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/users/{username}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "http://localhost:8080/v1/users/{username}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /users/{username}`

*Get user by username*

Retrieve a specific user.

<h3 id="getuserbyusername-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|username|path|[Username](#schemausername)|true|The username|

> Example responses

> 200 Response

```json
{
  "username": "string",
  "email": "string",
  "role": "administrator",
  "status": "active",
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}
```

<h3 id="getuserbyusername-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Ok|[User](#schemauser)|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Invalid user supplied|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|User not found|None|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## putUser

<a id="opIdputUser"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT http://localhost:8080/v1/users/{username} \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
PUT http://localhost:8080/v1/users/{username} HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "email": "string",
  "role": "administrator"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/users/{username}',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.put 'http://localhost:8080/v1/users/{username}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.put('http://localhost:8080/v1/users/{username}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','http://localhost:8080/v1/users/{username}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/users/{username}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "http://localhost:8080/v1/users/{username}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /users/{username}`

*Create a new user or replace an existing user*

If the username does not exist, it will create it for you. This endpoint does not support bulk operations

> Body parameter

```json
{
  "email": "string",
  "role": "administrator"
}
```

<h3 id="putuser-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|username|path|[Username](#schemausername)|true|The username|
|body|body|any|false|Editable properties of a user resource|

> Example responses

> 200 Response

```json
{
  "username": "string",
  "email": "string",
  "role": "administrator",
  "status": "active",
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}
```

<h3 id="putuser-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Updated|[User](#schemauser)|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Created|[User](#schemauser)|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Invalid username supplied|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## deleteUser

<a id="opIddeleteUser"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE http://localhost:8080/v1/users/{username} \
  -H 'Authorization: Bearer {access-token}'

```

```http
DELETE http://localhost:8080/v1/users/{username} HTTP/1.1
Host: localhost:8080

```

```javascript

const headers = {
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/users/{username}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.delete 'http://localhost:8080/v1/users/{username}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Authorization': 'Bearer {access-token}'
}

r = requests.delete('http://localhost:8080/v1/users/{username}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','http://localhost:8080/v1/users/{username}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/users/{username}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "http://localhost:8080/v1/users/{username}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /users/{username}`

*Deletes a user*

This can only be done by the logged in user.

<h3 id="deleteuser-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|username|path|[Username](#schemausername)|true|The username|

> Example responses

<h3 id="deleteuser-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|204|[No Content](https://tools.ietf.org/html/rfc7231#section-6.3.5)|No Content|None|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Invalid username supplied|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Username not found|None|

<h3 id="deleteuser-responseschema">Response Schema</h3>

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## getTokenByUsername

<a id="opIdgetTokenByUsername"></a>

> Code samples

```shell
# You can also use wget
curl -X GET http://localhost:8080/v1/users/{username}/token \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
GET http://localhost:8080/v1/users/{username}/token HTTP/1.1
Host: localhost:8080
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/users/{username}/token',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.get 'http://localhost:8080/v1/users/{username}/token',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.get('http://localhost:8080/v1/users/{username}/token', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','http://localhost:8080/v1/users/{username}/token', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/users/{username}/token");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "http://localhost:8080/v1/users/{username}/token", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /users/{username}/token`

*Get API token by username*

Retrieve an API token for the user

<h3 id="gettokenbyusername-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|username|path|[Username](#schemausername)|true|The username|

> Example responses

> 200 Response

```json
{
  "token": "string"
}
```

<h3 id="gettokenbyusername-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Ok|[Token](#schematoken)|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Invalid user supplied|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|User not found|None|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

<h1 id="puppet-data-service-api-nodes">nodes</h1>

Node details and configuration data, Nodedata stores configuration details for a specific node

## getAllNodes

<a id="opIdgetAllNodes"></a>

> Code samples

```shell
# You can also use wget
curl -X GET http://localhost:8080/v1/nodes \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
GET http://localhost:8080/v1/nodes HTTP/1.1
Host: localhost:8080
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/nodes',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.get 'http://localhost:8080/v1/nodes',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.get('http://localhost:8080/v1/nodes', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','http://localhost:8080/v1/nodes', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/nodes");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "http://localhost:8080/v1/nodes", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /nodes`

*Get all available nodes*

This can only be done by the logged in user.

> Example responses

> 200 Response

```json
[
  {
    "name": "string",
    "code-environment": "string",
    "classes": [
      "string"
    ],
    "data": {},
    "created-at": "2019-08-24T14:15:22Z",
    "updated-at": "2019-08-24T14:15:22Z"
  }
]
```

<h3 id="getallnodes-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|successful operation|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<h3 id="getallnodes-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[allOf]|false|none|none|

*allOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[ImmutableNodeProperties](#schemaimmutablenodeproperties)|false|none|none|
|»» name|string|false|none|none|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[EditableNodeProperties](#schemaeditablenodeproperties)|false|none|none|
|»» code-environment|string¦null|false|none|Code environment|
|»» classes|[string]|false|none|none|
|»» data|object|false|none|none|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|
|»» created-at|string(date-time)|false|none|none|
|»» updated-at|string(date-time)|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## createNode

<a id="opIdcreateNode"></a>

> Code samples

```shell
# You can also use wget
curl -X POST http://localhost:8080/v1/nodes \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
POST http://localhost:8080/v1/nodes HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "resources": [
    {
      "name": "string",
      "code-environment": "string",
      "classes": [
        "string"
      ],
      "data": {}
    }
  ]
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/nodes',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.post 'http://localhost:8080/v1/nodes',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.post('http://localhost:8080/v1/nodes', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','http://localhost:8080/v1/nodes', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/nodes");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "http://localhost:8080/v1/nodes", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /nodes`

*Create new node(s)*

The body params are required to be a JSON object with an array of node's data. This endpoint supports bulk operations, you can create one or 1000 nodedata in a single POST request.

> Body parameter

```json
{
  "resources": [
    {
      "name": "string",
      "code-environment": "string",
      "classes": [
        "string"
      ],
      "data": {}
    }
  ]
}
```

<h3 id="createnode-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|false|Create new node resources|
|» resources|body|[allOf]|false|none|
|»» *anonymous*|body|[ImmutableNodeProperties](#schemaimmutablenodeproperties)|false|none|
|»»» name|body|string|false|none|
|»» *anonymous*|body|[EditableNodeProperties](#schemaeditablenodeproperties)|false|none|
|»»» code-environment|body|string¦null|false|Code environment|
|»»» classes|body|[string]|false|none|
|»»» data|body|object|false|none|
|»» *anonymous*|body|object|false|none|

> Example responses

> 201 Response

```json
[
  {
    "name": "string",
    "code-environment": "string",
    "classes": [
      "string"
    ],
    "data": {},
    "created-at": "2019-08-24T14:15:22Z",
    "updated-at": "2019-08-24T14:15:22Z"
  }
]
```

<h3 id="createnode-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Created|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|{ "error": "Bad Request. Unable to create requested nodes, check for duplicate nodes" }|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<h3 id="createnode-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[allOf]|false|none|none|

*allOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[ImmutableNodeProperties](#schemaimmutablenodeproperties)|false|none|none|
|»» name|string|false|none|none|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[EditableNodeProperties](#schemaeditablenodeproperties)|false|none|none|
|»» code-environment|string¦null|false|none|Code environment|
|»» classes|[string]|false|none|none|
|»» data|object|false|none|none|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|
|»» created-at|string(date-time)|false|none|none|
|»» updated-at|string(date-time)|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## getNodeByName

<a id="opIdgetNodeByName"></a>

> Code samples

```shell
# You can also use wget
curl -X GET http://localhost:8080/v1/nodes/{name} \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
GET http://localhost:8080/v1/nodes/{name} HTTP/1.1
Host: localhost:8080
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/nodes/{name}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.get 'http://localhost:8080/v1/nodes/{name}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.get('http://localhost:8080/v1/nodes/{name}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','http://localhost:8080/v1/nodes/{name}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/nodes/{name}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "http://localhost:8080/v1/nodes/{name}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /nodes/{name}`

*Get node by node name*

Retrieve a specific node.

<h3 id="getnodebyname-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|name|path|string|true|The node name to be fetched or modified. Use node1 for testing.|

> Example responses

> 200 Response

```json
{
  "name": "string",
  "code-environment": "string",
  "classes": [
    "string"
  ],
  "data": {},
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}
```

<h3 id="getnodebyname-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Ok|[Node](#schemanode)|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Invalid node-name supplied|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Node not found|None|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## putNodeByName

<a id="opIdputNodeByName"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT http://localhost:8080/v1/nodes/{name} \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
PUT http://localhost:8080/v1/nodes/{name} HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "code-environment": "string",
  "classes": [
    "string"
  ],
  "data": {}
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/nodes/{name}',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.put 'http://localhost:8080/v1/nodes/{name}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.put('http://localhost:8080/v1/nodes/{name}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','http://localhost:8080/v1/nodes/{name}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/nodes/{name}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "http://localhost:8080/v1/nodes/{name}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /nodes/{name}`

*Create a new node or replace an existing node*

If the node name does not exist, it will create it for you. This endpoint does not support bulk operations

> Body parameter

```json
{
  "code-environment": "string",
  "classes": [
    "string"
  ],
  "data": {}
}
```

<h3 id="putnodebyname-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|name|path|string|true|The node name to be fetched or modified. Use node1 for testing.|
|body|body|any|false|Editable properties of a node resource|

> Example responses

> 200 Response

```json
{
  "name": "string",
  "code-environment": "string",
  "classes": [
    "string"
  ],
  "data": {},
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}
```

<h3 id="putnodebyname-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Updated|[Node](#schemanode)|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Created|[Node](#schemanode)|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Invalid node-name supplied|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## deleteNode

<a id="opIddeleteNode"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE http://localhost:8080/v1/nodes/{name} \
  -H 'Authorization: Bearer {access-token}'

```

```http
DELETE http://localhost:8080/v1/nodes/{name} HTTP/1.1
Host: localhost:8080

```

```javascript

const headers = {
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/nodes/{name}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.delete 'http://localhost:8080/v1/nodes/{name}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Authorization': 'Bearer {access-token}'
}

r = requests.delete('http://localhost:8080/v1/nodes/{name}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','http://localhost:8080/v1/nodes/{name}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/nodes/{name}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "http://localhost:8080/v1/nodes/{name}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /nodes/{name}`

*Deletes a node*

This can only be done by the logged in user.

<h3 id="deletenode-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|name|path|string|true|The node name to be fetched or modified. Use node1 for testing.|

> Example responses

<h3 id="deletenode-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|204|[No Content](https://tools.ietf.org/html/rfc7231#section-6.3.5)|No Content|None|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Invalid Node name supplied|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Nodedata not found|None|

<h3 id="deletenode-responseschema">Response Schema</h3>

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

<h1 id="puppet-data-service-api-hiera-data">hiera-data</h1>

Hierdata manages your Hiera Key:Value as a service

## getHieraData

<a id="opIdgetHieraData"></a>

> Code samples

```shell
# You can also use wget
curl -X GET http://localhost:8080/v1/hiera-data \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
GET http://localhost:8080/v1/hiera-data HTTP/1.1
Host: localhost:8080
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/hiera-data',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.get 'http://localhost:8080/v1/hiera-data',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.get('http://localhost:8080/v1/hiera-data', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','http://localhost:8080/v1/hiera-data', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/hiera-data");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "http://localhost:8080/v1/hiera-data", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /hiera-data`

*Get all hiera data available in the system*

Get all Hiera data

<h3 id="gethieradata-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|level|query|string|false|(Optional) This will filter by Hiera level (URL encoded), e.g. 'level%2Fone%2Fglobal'|

> Example responses

> 200 Response

```json
[
  {
    "level": "string",
    "key": "string",
    "value": null,
    "created-at": "2019-08-24T14:15:22Z",
    "updated-at": "2019-08-24T14:15:22Z"
  }
]
```

<h3 id="gethieradata-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|successful operation|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<h3 id="gethieradata-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[allOf]|false|none|none|

*allOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[ImmutableHieraDatumProperties](#schemaimmutablehieradatumproperties)|false|none|none|
|»» level|string|false|none|none|
|»» key|string|false|none|none|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[EditableHieraDatumProperties](#schemaeditablehieradatumproperties)|false|none|none|
|»» value|any|false|none|The value to set the Hiera key to|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|
|»» created-at|string(date-time)|false|none|none|
|»» updated-at|string(date-time)|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## createHieraData

<a id="opIdcreateHieraData"></a>

> Code samples

```shell
# You can also use wget
curl -X POST http://localhost:8080/v1/hiera-data \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
POST http://localhost:8080/v1/hiera-data HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "resources": [
    {
      "level": "string",
      "key": "string",
      "value": null
    }
  ]
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/hiera-data',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.post 'http://localhost:8080/v1/hiera-data',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.post('http://localhost:8080/v1/hiera-data', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','http://localhost:8080/v1/hiera-data', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/hiera-data");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "http://localhost:8080/v1/hiera-data", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /hiera-data`

*Create new Hiera data value(s)*

The body params are required to be a JSON object with an array of Hieradata. This endpoint supports bulk operations, you can create one or 1000 hieradata in a single POST request.

> Body parameter

```json
{
  "resources": [
    {
      "level": "string",
      "key": "string",
      "value": null
    }
  ]
}
```

<h3 id="createhieradata-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|false|Create new Hiera data resources|
|» resources|body|[allOf]|false|none|
|»» *anonymous*|body|[ImmutableHieraDatumProperties](#schemaimmutablehieradatumproperties)|false|none|
|»»» level|body|string|false|none|
|»»» key|body|string|false|none|
|»» *anonymous*|body|[EditableHieraDatumProperties](#schemaeditablehieradatumproperties)|false|none|
|»»» value|body|any|false|The value to set the Hiera key to|
|»» *anonymous*|body|object|false|none|

> Example responses

> 201 Response

```json
[
  {
    "level": "string",
    "key": "string",
    "value": null,
    "created-at": "2019-08-24T14:15:22Z",
    "updated-at": "2019-08-24T14:15:22Z"
  }
]
```

<h3 id="createhieradata-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Created|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|{"error": "Bad Request. Unable to create requested hiera-data, check for duplicate hiera-data"}|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<h3 id="createhieradata-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[allOf]|false|none|none|

*allOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[ImmutableHieraDatumProperties](#schemaimmutablehieradatumproperties)|false|none|none|
|»» level|string|false|none|none|
|»» key|string|false|none|none|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[EditableHieraDatumProperties](#schemaeditablehieradatumproperties)|false|none|none|
|»» value|any|false|none|The value to set the Hiera key to|

*and*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» *anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|
|»» created-at|string(date-time)|false|none|none|
|»» updated-at|string(date-time)|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## getHieraDataWithLevelAndKey

<a id="opIdgetHieraDataWithLevelAndKey"></a>

> Code samples

```shell
# You can also use wget
curl -X GET http://localhost:8080/v1/hiera-data/{level}/{key} \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
GET http://localhost:8080/v1/hiera-data/{level}/{key} HTTP/1.1
Host: localhost:8080
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/hiera-data/{level}/{key}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.get 'http://localhost:8080/v1/hiera-data/{level}/{key}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.get('http://localhost:8080/v1/hiera-data/{level}/{key}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','http://localhost:8080/v1/hiera-data/{level}/{key}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/hiera-data/{level}/{key}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "http://localhost:8080/v1/hiera-data/{level}/{key}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /hiera-data/{level}/{key}`

*Get a specific hiera value*

Get Hiera data that matches the given {level} and {key}

<h3 id="gethieradatawithlevelandkey-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|level|path|string|true|The Hiera level|
|key|path|string|true|The Hiera key|

> Example responses

> 200 Response

```json
{
  "level": "string",
  "key": "string",
  "value": null,
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}
```

<h3 id="gethieradatawithlevelandkey-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|successful operation|[HieraDatum](#schemahieradatum)|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Hiera data not found for the given level and key|None|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## upsertHieraDataWithLevelAndKey

<a id="opIdupsertHieraDataWithLevelAndKey"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT http://localhost:8080/v1/hiera-data/{level}/{key} \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer {access-token}'

```

```http
PUT http://localhost:8080/v1/hiera-data/{level}/{key} HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "value": null
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/hiera-data/{level}/{key}',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.put 'http://localhost:8080/v1/hiera-data/{level}/{key}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer {access-token}'
}

r = requests.put('http://localhost:8080/v1/hiera-data/{level}/{key}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','http://localhost:8080/v1/hiera-data/{level}/{key}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/hiera-data/{level}/{key}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "http://localhost:8080/v1/hiera-data/{level}/{key}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /hiera-data/{level}/{key}`

*Upserts a specific hiera object*

If the hieradata with the compound ID {level} and {key} does not exist, it will create it for you. This endpoint does not support bulk operations

> Body parameter

```json
{
  "value": null
}
```

<h3 id="upserthieradatawithlevelandkey-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|level|path|string|true|The Hiera level|
|key|path|string|true|The Hiera key|
|body|body|any|false|Create or edit a Hiera value at a specified level and key|

> Example responses

> 200 Response

```json
{
  "level": "string",
  "key": "string",
  "value": null,
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}
```

<h3 id="upserthieradatawithlevelandkey-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Updated|[HieraDatum](#schemahieradatum)|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Created|[HieraDatum](#schemahieradatum)|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|{"error": "Bad Request. Unable to create requested hiera-data, check for duplicate hiera-data"}|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

## deleteHieraDataObject

<a id="opIddeleteHieraDataObject"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE http://localhost:8080/v1/hiera-data/{level}/{key} \
  -H 'Authorization: Bearer {access-token}'

```

```http
DELETE http://localhost:8080/v1/hiera-data/{level}/{key} HTTP/1.1
Host: localhost:8080

```

```javascript

const headers = {
  'Authorization':'Bearer {access-token}'
};

fetch('http://localhost:8080/v1/hiera-data/{level}/{key}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Authorization' => 'Bearer {access-token}'
}

result = RestClient.delete 'http://localhost:8080/v1/hiera-data/{level}/{key}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Authorization': 'Bearer {access-token}'
}

r = requests.delete('http://localhost:8080/v1/hiera-data/{level}/{key}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Authorization' => 'Bearer {access-token}',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','http://localhost:8080/v1/hiera-data/{level}/{key}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("http://localhost:8080/v1/hiera-data/{level}/{key}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Authorization": []string{"Bearer {access-token}"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "http://localhost:8080/v1/hiera-data/{level}/{key}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /hiera-data/{level}/{key}`

*Deletes a Hieradata object*

Permanently removes the Hiera object that matches the level/key ID

<h3 id="deletehieradataobject-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|level|path|string|true|The Hiera level|
|key|path|string|true|The Hiera key|

> Example responses

<h3 id="deletehieradataobject-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|204|[No Content](https://tools.ietf.org/html/rfc7231#section-6.3.5)|No Content|None|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Invalid level or key supplied|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Access (Bearer) token is missing or invalid|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Hieradata not found|None|

<h3 id="deletehieradataobject-responseschema">Response Schema</h3>

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
bearerAuth
</aside>

# Schemas

<h2 id="tocS_Username">Username</h2>
<!-- backwards compatibility -->
<a id="schemausername"></a>
<a id="schema_Username"></a>
<a id="tocSusername"></a>
<a id="tocsusername"></a>

```json
"string"

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|string|false|none|none|

<h2 id="tocS_TimestampProperties">TimestampProperties</h2>
<!-- backwards compatibility -->
<a id="schematimestampproperties"></a>
<a id="schema_TimestampProperties"></a>
<a id="tocStimestampproperties"></a>
<a id="tocstimestampproperties"></a>

```json
{
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|created-at|string(date-time)|false|none|none|
|updated-at|string(date-time)|false|none|none|

<h2 id="tocS_ImmutableUserProperties">ImmutableUserProperties</h2>
<!-- backwards compatibility -->
<a id="schemaimmutableuserproperties"></a>
<a id="schema_ImmutableUserProperties"></a>
<a id="tocSimmutableuserproperties"></a>
<a id="tocsimmutableuserproperties"></a>

```json
{
  "username": "string"
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|username|[Username](#schemausername)|false|none|none|

<h2 id="tocS_EditableUserProperties">EditableUserProperties</h2>
<!-- backwards compatibility -->
<a id="schemaeditableuserproperties"></a>
<a id="schema_EditableUserProperties"></a>
<a id="tocSeditableuserproperties"></a>
<a id="tocseditableuserproperties"></a>

```json
{
  "email": "string",
  "role": "administrator"
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|email|string¦null|false|none|none|
|role|string|false|none|User role|

#### Enumerated Values

|Property|Value|
|---|---|
|role|administrator|
|role|operator|

<h2 id="tocS_ReadOnlyUserProperties">ReadOnlyUserProperties</h2>
<!-- backwards compatibility -->
<a id="schemareadonlyuserproperties"></a>
<a id="schema_ReadOnlyUserProperties"></a>
<a id="tocSreadonlyuserproperties"></a>
<a id="tocsreadonlyuserproperties"></a>

```json
{
  "status": "active"
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|status|string|false|none|User status|

#### Enumerated Values

|Property|Value|
|---|---|
|status|active|
|status|inactive|
|status|deleted|

<h2 id="tocS_User">User</h2>
<!-- backwards compatibility -->
<a id="schemauser"></a>
<a id="schema_User"></a>
<a id="tocSuser"></a>
<a id="tocsuser"></a>

```json
{
  "username": "string",
  "email": "string",
  "role": "administrator",
  "status": "active",
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}

```

### Properties

allOf

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[ImmutableUserProperties](#schemaimmutableuserproperties)|false|none|none|

and

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[EditableUserProperties](#schemaeditableuserproperties)|false|none|none|

and

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[ReadOnlyUserProperties](#schemareadonlyuserproperties)|false|none|none|

and

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|

<h2 id="tocS_Token">Token</h2>
<!-- backwards compatibility -->
<a id="schematoken"></a>
<a id="schema_Token"></a>
<a id="tocStoken"></a>
<a id="tocstoken"></a>

```json
{
  "token": "string"
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|token|string|false|none|API token|

<h2 id="tocS_ImmutableNodeProperties">ImmutableNodeProperties</h2>
<!-- backwards compatibility -->
<a id="schemaimmutablenodeproperties"></a>
<a id="schema_ImmutableNodeProperties"></a>
<a id="tocSimmutablenodeproperties"></a>
<a id="tocsimmutablenodeproperties"></a>

```json
{
  "name": "string"
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|name|string|false|none|none|

<h2 id="tocS_EditableNodeProperties">EditableNodeProperties</h2>
<!-- backwards compatibility -->
<a id="schemaeditablenodeproperties"></a>
<a id="schema_EditableNodeProperties"></a>
<a id="tocSeditablenodeproperties"></a>
<a id="tocseditablenodeproperties"></a>

```json
{
  "code-environment": "string",
  "classes": [
    "string"
  ],
  "data": {}
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|code-environment|string¦null|false|none|Code environment|
|classes|[string]|false|none|none|
|data|object|false|none|none|

<h2 id="tocS_Node">Node</h2>
<!-- backwards compatibility -->
<a id="schemanode"></a>
<a id="schema_Node"></a>
<a id="tocSnode"></a>
<a id="tocsnode"></a>

```json
{
  "name": "string",
  "code-environment": "string",
  "classes": [
    "string"
  ],
  "data": {},
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}

```

### Properties

allOf

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[ImmutableNodeProperties](#schemaimmutablenodeproperties)|false|none|none|

and

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[EditableNodeProperties](#schemaeditablenodeproperties)|false|none|none|

and

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|

<h2 id="tocS_ImmutableHieraDatumProperties">ImmutableHieraDatumProperties</h2>
<!-- backwards compatibility -->
<a id="schemaimmutablehieradatumproperties"></a>
<a id="schema_ImmutableHieraDatumProperties"></a>
<a id="tocSimmutablehieradatumproperties"></a>
<a id="tocsimmutablehieradatumproperties"></a>

```json
{
  "level": "string",
  "key": "string"
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|level|string|false|none|none|
|key|string|false|none|none|

<h2 id="tocS_EditableHieraDatumProperties">EditableHieraDatumProperties</h2>
<!-- backwards compatibility -->
<a id="schemaeditablehieradatumproperties"></a>
<a id="schema_EditableHieraDatumProperties"></a>
<a id="tocSeditablehieradatumproperties"></a>
<a id="tocseditablehieradatumproperties"></a>

```json
{
  "value": null
}

```

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|value|any|false|none|The value to set the Hiera key to|

<h2 id="tocS_HieraDatum">HieraDatum</h2>
<!-- backwards compatibility -->
<a id="schemahieradatum"></a>
<a id="schema_HieraDatum"></a>
<a id="tocShieradatum"></a>
<a id="tocshieradatum"></a>

```json
{
  "level": "string",
  "key": "string",
  "value": null,
  "created-at": "2019-08-24T14:15:22Z",
  "updated-at": "2019-08-24T14:15:22Z"
}

```

### Properties

allOf

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[ImmutableHieraDatumProperties](#schemaimmutablehieradatumproperties)|false|none|none|

and

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[EditableHieraDatumProperties](#schemaeditablehieradatumproperties)|false|none|none|

and

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|*anonymous*|[TimestampProperties](#schematimestampproperties)|false|none|none|

