# IRC RFCs

I'm trying to write an update to the outdated [RFC1459](https://tools.ietf.org/html/rfc1459) and [RFC2812](https://tools.ietf.org/html/rfc2812).

Newest builds are available here:

- IRC Client: [HTML](https://rawgit.com/DanielOaks/irc-rfcs/master/dist/id-oakley-irc-client-latest.html) / [Text](https://rawgit.com/DanielOaks/irc-rfcs/master/dist/id-oakley-irc-client-latest.txt)
- IRC CTCP: [HTML](https://rawgit.com/DanielOaks/irc-rfcs/master/dist/id-oakley-irc-ctcp-latest.html) / [Text](https://rawgit.com/DanielOaks/irc-rfcs/master/dist/id-oakley-irc-ctcp-latest.txt)

The 'drafts' in this repo are based off my [Modern docs](https://modern.ircdocs.horse/). This repo can be considered 'on hold' until the relevant Modern documents are stable and complete enough for me to be happy with. Recent updates in this repo are just an attempt to prove that the tech works, not to actually start work in this repo.

If you'd like to contribute, please take a look at the [Modern docs](https://modern.ircdocs.horse/) and contribute in the relevant [Github repo](https://github.com/ircdocs/modern-irc).


## Why?

TBD

<!-- Right now, there are a bunch of different specs IRC authors need to pull stuff from when implementing clients and servers. RFC1459 got outdated, RFC2812 and the related family of RFCs have always been contentious, with things defined within that never became standard practice. The best we got for ISUPPORT and CAP was an Internet Draft that never got ratified.

Basically put, it's become standard practice to implement most of some RFCs, some of others, and to rely heavily on Internet Drafts. For people implementing new software, it's a mess, and almost impossible to see what to implement and what to ignore without going back to the biggest servers and just copying what they do, since you can't rely on the documents to be correct.

So we need a new base RFC for IRC. Something that actually reflects reality these days, and defines things that have become commonplace these days like ISUPPORT and capabilities. Something authors can actually use to implement software properly today.


## What are we covering?

Current IRC implementations, and a certain subset of features defined by the [IRCv3 WG](http://ircv3.net/) (mostly just `CAP`, `SASL`, and Message Tags)

* Core client protocol (what's widely used today from the [old](https://tools.ietf.org/html/rfc1459) [RFCs](https://tools.ietf.org/html/rfc2812))
* `ISUPPORT`
* `CAP`
* `SASL`
* Message Tags

This spec also assumes that a spanning-tree layout is not the only allowable layout for an IRC network. This may be a controversial decision, but we do have IRCds experimenting with things like mesh networking (as well as competing protocols such as RobustIRC), and I think allowing for this in the spec is a good thing.


## What are we not covering?

We're not writing a boatload of new stuff in here that we're not sure will be adopted. The purpose of this document is mostly to document and standardize what is being used today, and what should be used today to implement decent IRC technology and allow for future extensibility.

---

The server to server protocol is explicitly not being covered in this document.

[RFC2812](https://tools.ietf.org/html/rfc2812) says the following: "At the time of writing, the only current implementation of this protocol is the IRC server, version 2.10". Today, that's not the case. You have lots and lots of different IRCds, and lots of different server protocols in use because of it. TS6, a bunch of custom TS6 flavours, TS5, P10, InspIRCd's protocol. We're primarily aiming to document and specify what is being used today, and there simply isn't a single server protocol in use today.

Especially given that there are servers (and competing IRC protocol efforts) experimenting with topologies other than the standard spanning-tree, and even their own newly-designed protocols between servers, I don't think it makes sense to try to specify a new version of the server protocol at this point. I think it's best to leave this to server authors themselves and relevant server spec documents sometime later as the technology grows and experiments, as what we specify would probably just be ignored or quickly become irrelevant.

If necessary, we could name this something like the IRCv3 Client RFC, though this document also goes over the architectural aspects of IRC, so a better name may be required.

---

`STARTTLS` should not be documented in here. There are quite a few issues that make it really annoying to implement client-side, there aren't that many clients that do actually support it, and I think we'd get better adoption and reception if we just present port 6697 as in [RFC7194](https://tools.ietf.org/html/rfc7194). -->


## Building

To build this, install [kramdown-rfc2629](https://github.com/cabo/kramdown-rfc2629) and then use the `build.sh` script. That script will put the xml, txt and html files in the `dist/` directory.


## Contributing

The main document is in [id-oakley-irc-client-latest.mkd](id-oakley-irc-client-latest.mkd).

When putting in a pull request, ***ONLY*** submit a change for the source files. ***DO NOT*** include rebuilding the `dist/` files in your pull request. This is to prevent a million conflicts if we have three PRs sitting in the waiting queue and try to merge all of them at once (particularly the .txt files). We can generate new `dist/` files after we merge things into the repo.

**NOTE:** `lib/addstyle.sed` and `lib/style.css` have been taken from Martin Thompson's [I-D Template](https://github.com/martinthomson/i-d-template) repository.


## Plans

I hope to (when it's good and ready) submit this document to the IETF and get a new RFC more closely describing how IRC works these days.

Regardless of how this spec goes, the [Modern docs](https://modern.ircdocs.horse/) are online, go through everything here and are updated more often than the material here.
