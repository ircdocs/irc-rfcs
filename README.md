# IRC RFCs

I'm trying to write an update to the outdated [RFC 1459](https://tools.ietf.org/html/rfc1459) and [RFC 2812](https://tools.ietf.org/html/rfc2812) specifications.

Newest builds are available here:

<!-- - IRC Client: [HTML](https://rawgit.com/ircdocs/irc-rfcs/master/dist/draft-oakley-irc-client-latest.html) / [Text](https://rawgit.com/ircdocs/irc-rfcs/master/dist/draft-oakley-irc-client-latest.txt) -->
- IRC CTCP: [HTML](https://cdn.jsdelivr.net/gh/ircdocs/irc-rfcs@master/dist/draft-oakley-irc-ctcp-latest.html) / [Text](https://cdn.jsdelivr.net/gh/ircdocs/irc-rfcs@master/dist/draft-oakley-irc-ctcp-latest.txt) (I'll fix the html link a bit later, the txt link works though)

The 'drafts' in this repo are mostly based off my [Modern docs](https://modern.ircdocs.horse/). The CTCP I-D is something I'm working on, but the IRC Client Protocol document is probably not going to be worked on for a very long time (I think that info's better conveyed in the [Modern doc](https://modern.ircdocs.horse/) and more recent documentation attempts like [devdocs](https://dd.ircdocs.horse)).


## Why?

RFC 1459 and RFC 2812 are the first place that new IRC software authors look when they want to implement IRC. And why wouldn't they – those are the latest RFCs for it!

However, IRC has changed a lot since those specs were published. Today, there are many different documents that you need to look at to fully understand how the protocol works in practice. I've got a page [here](https://ircdocs.horse/specs/) that tries to go through the useful ones, and [this living specification](https://modern.ircdocs.horse/) which attempts to produce a workable spec to use day-to-day.

However, having an updated specification that's gone through the IETF process and is a proper RFC would:

- Help us standardise the defacto solutions that have been in use for years, and prevent fragmentation from those by newer software.
- Give people a better core standard which they can refer to, which is an RFC and describes the protocol as it really works.

These documents don't describe things that will be, or things that should happen after the spec is published. These documents describe how things work right now in specific detail.


## Documents

I'm going to split this into a few separate documents, each describing a separate part of IRC as it stands today. Here, I'll go through what each one covers, what it explicitly doesn't, and the status of it.

### Client Protocol

This is the big one, the replacement for RFC 1459 and RFC 2812 on the whole. It'll probably include:

- Core client protocol.
- `RPL_ISUPPORT`
- Basic message tags (at least describing them as part of the IRC framing).

This document is being actively worked on as the main [Modern Client Protocol Doc](https://modern.ircdocs.horse/). I'm **not working on the client protocol spec here** until that linked Modern document is at a point where I'm relatively happy removing the WIP tag from it.

<!-- [HTML](https://rawgit.com/DanielOaks/irc-rfcs/master/dist/draft-oakley-irc-client-latest.html) / [Text](https://rawgit.com/DanielOaks/irc-rfcs/master/dist/draft-oakley-irc-client-latest.txt) -->

### Client-to-Client Protocol (CTCP)

This describes how CTCP works today, ignoring a lot of the quoting that was specified in older documents but not actually implemented by any widely-used clients. It describes:

- Core CTCP protocol.
- Commonly-used or seen CTCP messages.

I'm **working on this document currently**, most of that work being copyediting and editing in general. I'm thinking about using this as a 'test bed' for seeing how I can go getting clients to look over and validate it, and for seeing how the IETF responds to IRC specifications.

[HTML](https://rawgit.com/DanielOaks/irc-rfcs/master/dist/draft-oakley-irc-ctcp-latest.html) / [Text](https://rawgit.com/DanielOaks/irc-rfcs/master/dist/draft-oakley-irc-ctcp-latest.txt)


## S2S Note

The server to server protocol is explicitly not being covered here.

[RFC 2812](https://tools.ietf.org/html/rfc2812) says the following: "At the time of writing, the only current implementation of this protocol is the IRC server, version 2.10". Today, that's not the case. You have lots and lots of different IRCds, and lots of different server protocols in use because of it. TS6, a bunch of custom TS6 flavours, TS5, P10, InspIRCd's protocol. We're primarily aiming to document and specify what is being used today, and there simply isn't a single server protocol in use today.

Especially given that there are servers (and competing IRC protocol efforts) experimenting with topologies other than the standard spanning-tree, and even their own newly-designed protocols between servers, I don't think it makes sense to try to specify a new version of the server protocol at this point. I think it's best to leave this to server authors themselves and relevant server spec documents sometime later as the technology grows and experiments, as what we specify would probably just be ignored or quickly become irrelevant.


## Building

To build this, install [kramdown-rfc2629](https://github.com/cabo/kramdown-rfc2629) and then use the relevant `build-*.sh` script. That script will put the xml, txt and html files in the `dist/` directory.

As noted below, when submitting changes only include the source file changes. Don't include the newly-built `dist/` changes. This helps when merging and resolving conflicts.


## Contributing

When putting in a pull request, ***ONLY*** submit a change for the source files. ***DO NOT*** include the new `dist/` files in your pull request. This is to prevent a million conflicts if we have three PRs sitting in the waiting queue and try to merge all of them at once (particularly the .txt files). We can generate new `dist/` files after we merge things into the repo.

**NOTE:** `lib/addstyle.sed` and `lib/style.css` have been taken from Martin Thompson's [I-D Template](https://github.com/martinthomson/i-d-template) repository.
