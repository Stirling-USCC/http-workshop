---
title: The Naked Web - HTTP Under the Hood
subtitle: University of Stirling Society of Computing
author: Michael Connor Buchan <mib00150@students.stir.ac.uk>
date: January 2024
lang: en-GB
reference-location: block
description: |
    Licensed under [CC By SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.en)
...

# Introduction

## How the Web Works

HTTP (HyperText Transfer Protocol) is the fundamental technology that makes the world-wide web work. Invented by [Tim
Berners-Lee][tbl] in the early 1990s, it defines how your web browser talks to a web server to retrieve and upload
information.

[tbl]: <https://en.wikipedia.org/wiki/Tim_Berners-Lee>

HTTP is by far the most common protocol for transferring data on the web [^1]. Considering this, it is an astonishingly
simple, plain-text protocol that is entirely human readable. Despite this, it has proved to be an extremely extensible,
vercitile, and reliable protocol [^2].

[^1]: The web, not the internet. The internet is a network of interconnected networks (I.E. it is the communications
  infrestructure itself). The web is an application that runs ontop of the internet, and allows you to view web-pages
  and, in general, make requests to, and receive requests from, a server.

[^2]: Only recently have efforts been made to change the fundamental technologies of the web, and they mostly focus on
  the transport-layer protocol (I.E. improving or replacing [TCP][tcp]), such as [QUIC][quic].

[tcp]: <https://en.wikipedia.org/wiki/Transmission_Control_Protocol>
[QUIC]: <https://en.wikipedia.org/wiki/QUIC>

## Beyond the Browser

But HTTP isn't just used in web browsers. Its simplicity, ease of implementation, and status as probably the most well
supported application layer protocol on the internet makes it perfect for many uses.

## Application Programming Interfaces

API is a somewhat generalisable term that refers to an interface (I.E. a specification of inputs and outputs) for an
application (I.E. a running computer system), that a programmer can write code to make use of. For example:

* A shopping app on a mobile device might use an API to request to the app's server that an order for an item be created
  by the logged in user
* When you type in the search box of your operating system, the web suggestions you get may be retrieved by requesting
  results from an API
* If you were to build an AI fatial recognision system to track the attendance of students at a university, [^3] you
  would create an API to allow your clients to add, edit, view and remove attendance records

[^3]: Sound interesting? Join the [AI Club][ai-club] and help out with [Project FRAS][fras].

[ai-club]: <https://www.stirlingstudentsunion.com/societies/9620/>
[fras]: <https://uk.surveymonkey.com/r/SH5T3WZ>

## REST APIs

REST (REpresentational State Transfer) is a specific architecture used when building APIs that is especially suited for
use over HTTP.

HTTP provides us with the tools to build REST APIs easily, and indeed this is one of the biggest uses of HTTP. Many APIs
are custom-designed to fulfill a single application's requirements, but some are open standards, such as
[WebDAV][webdav], which provides an API for writing and organising files on a web server.



[webdav]: <https://en.wikipedia.org/wiki/WebDAV>

# Anatomy of an HTTP Request

## HTTP Requests

> What does an HTTP request look like?

Here's an example of an HTTP request made by [cURL][curl]:

[curl]: <https://curl.org>

```sh
curl --verbose https://lowerelements.club/
```

```http
GET / HTTP/2
Host: lowerelements.club
user-agent: curl/7.88.1
accept: */*

<!doctype html>
<!-- ... -->
```

The components of this request are explained on the following slides.

## The Method

> | **GET** / HTTP/2
> | Host: lowerelements.club
> | user-agent: curl/7.88.1
> | accept: */*
> | 
> | <!doctype html>
> | \<!-- ... --\>

The first part of request specifies the request method (in this case it's "GET"). There are 9 [HTTP
methods][http-methods-mdn] (also called verbs):

[http-methods-mdn]: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods>

`GET`

:   Retrieve (get) a resource from the server. This is the type of request your browser makes when you load a
    webpage, or when loading an image referenced in that webpage. Both header and body data are sent in the response.
    
`HEAD`

:   Request the metadata (the head) for a specific resource, without sending the resource itself. This is the same
    as `GET`, except that only the HTTP headers are sent in the response, without the body data.

`POST`

:   Upload (post) some data to a resource on the server. This is the type of request your browser makes when you
    submit a form on a webpage, and is used to cause a change in state of that resource on the server.

`PUT`

:   Create or update (put) a resource on the server, from the data provided. Often used in APIs to create new
    resources (E.G> creating accounts), but sometimes also used for editting existing resources.

`PATCH`

:   Modify (patch) an existing resource on the server with some new data. Used in APIs when updating part of an
    existing resource, like when changing your password on a site.

`DELETE`

:   Remove (delete) a resource on the server, for example, delete a social media post, or close an account.

`OPTIONS`

:   Ask the server which HTTP methods and other communication options are allowed for the specified resource.

`CONNECT`

:   Establish a tunnel through the server to some other endpoint, identified by the specified resource. Rarely
    used when building APIs.
    
`TRACE`

Test the communications channels with the server by performing a message loopback test. Like `CONNECT`, rarely used in
the wild, especially not in APIs.

## The Path

> | GET **/** HTTP/2
> | Host: lowerelements.club
> | user-agent: curl/7.88.1
> | Accept: */*
> | 
> | <!doctype html>
> | \<!-- ... --\>

The path specifies which resource the request applies to. Simple paths are modelled after standard Unix filesystem
paths, for example, "/images/gallery/image1.jpg" means:

* Start at the root of the filesystem "/"
* Find the "images" subdirectory
* Find the "gallery" subdirectory
* Find the "image1.jpg" file, this is the resource the request is identifying

For a simple web server serving static files, these paths often translate 1-to-1 to paths to files stored on the server,
but HTTP does not inforce this, and when building APIs, they can be structured however you like!

The path can also include arbitrary query parameters. These can be used for anything that the server wants, for example:

* YouTube uses them to specify which video to play: ["/watch?v=dQw4w9WgXcQ"](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
* Search engines use them to specify the keywords you're searching for: ["/?q=TheFake+VIP"](https://duckduckgo.com/?q=TheFake+VIP)
* Many sites use them to specify which page you're on, what you've filtered by, etc: ["/?dataType=Post&pageCursor=P862f46&sort=Active"](https://programming.dev/?dataType=Post&pageCursor=P862f46&sort=Active)

Query parameters are separated by ampersand (`&`), and delimeted from the main part of the path with a question mark
(`?`).

Paths can also contain fragments, which specify which part of the page is being referred to. Browsers use this to scroll
to a specific part of a page automatically on load. For example, going to
<https://github.com/lower-elements/lege#documentation> should automatically scroll you to the "Documentation" section.

## The HTTP Version

> | GET / **HTTP/2**
> | Host: lowerelements.club
> | user-agent: curl/7.88.1
> | accept: */*
> | 
> | <!doctype html>
> | \<!-- ... --\>

As you might imagine, this specifies the version of the HTTP protocol the request uses. Curl uses `HTTP/2` by default,
but HTTP 2 has features such as multiplexing that make it harder to understand how HTTP works, so for this workshop,
we'll be focusing on HTTP/1.1. Knowledge of HTTP 1.1 is broadly applicable to HTTP 2 and future versions.

## The Request Headers

> | GET / HTTP/2
> | **Host: lowerelements.club**
> | **user-agent: curl/7.88.1**
> | **accept: \*/\***
> | 
> | <!doctype html>
> | \<!-- ... --\>

Request headers allow you to specify additional metadata to go along with your request. Headers are composed of a name
and a value, written on a single line, with the header name seperated from the value by ": " (I.E. a colon and a space).
As with the rest of HTTP, lines are seperated by "\r\n" (I.E. a carriage return, followed by a line feed).

Headers can contain any data you want, but many headers are part of the HTTP or other standards. It is good practice to
prefix any custom header names with "X-" (E.G. "X-Order-Id").

## Common HTTP Headers

There are many, many standardised HTTP headers, this is by no means an exhaustive list, but some important ones are:

* `Host`: The hostname of the server the request is for. This allows one server to serve many websites, as although the
  IP address of the server is always the same, the client identifies the domain name they used to connect via the `Host`
  header.
* `User-Agent`: Identifies the software making the request. In the example above, Curl's user agent specifies the
  version of cURL used to make the request.
* `Accept`: [MimeType][mimetype] of the data the client is expecting to receive. Common examples include "*/*"
  (anything), "text/html" (HTML page), and "text/json" (JSON data).
* `Content-Type`: Just like `Accept`, but specifies the type of the body of the request, instead of the expected content
  of the response
* `Cookie`: Used by clients to provide a saved cookie back to the server, which can be used to identify the client
  between requests

## The Request Body

> | GET / HTTP/2
> | Host: lowerelements.club
> | user-agent: curl/7.88.1
> | accept: \*/\*
> | 
> | **<!doctype html>**
> | **\<!-- ... --\>**o

The request body can contain a data payload (I.E. any data the client wants). Not all methods allow a body (`GET`
actually doesn't, so our ficticious example of a request above is technically malformed). Bodies are used most often
with `POST`, `PUT`, and `PATCH` requests. The type of data in the body is specified by the `Content-Type` header, so for
example, when your browser submits a form, it encodes the data, and uses a content type of "application/x-www-form-urlencoded".

# Manually Crafting an HTTP Request

## Really?

Yes! HTTP is so simple to write, you can type it yourself! All you need is a tool that gives you a raw TCP connection
that you can interact with directly.
