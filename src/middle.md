# Introduction

The Internet Relay Chat (IRC) protocol has been designed and implemented over a number of years, with multitudes of implementations and use cases appearing. This document describes version 3 of the IRC protocol.

IRC is a text-based teleconferencing system, which has proven itself as a very valuable and useful protocol. It is well-suited to running on many machines in a distributed fashion. A typical setup involves multiple servers connected in a distributed network, through which messages are delivered and state is maintained across the network for the connected clients and active channels.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [](#RFC2119).


## Servers

Servers form the backbone of IRC, providing a point to which clients may connect and talk to each other, and a point for other servers to connect to, forming an IRC network.

The most common network configuration for IRC servers is that of a spanning tree [see [](#fig:typicalnet)], where each server acts as a central node for the rest of the net it sees.

                               [ Server 15 ]  [ Server 13 ] [ Server 14]
                                     /                \         /
                                    /                  \       /
            [ Server 11 ] ------ [ Server 1 ]       [ Server 12]
                                  /        \          /
                                 /          \        /
                      [ Server 2 ]          [ Server 3 ]
                        /       \                      \
                       /         \                      \
               [ Server 4 ]    [ Server 5 ]         [ Server 6 ]
                /    |    \                           /
               /     |     \                         /
              /      |      \____                   /
             /       |           \                 /
     [ Server 7 ] [ Server 8 ] [ Server 9 ]   [ Server 10 ]

                                      :
                                   [ etc. ]
                                      :

^[fig:typicalnet::Format of a typical IRC network.]


## Clients

A client is anything connecting to a server that is not another server. Each client is distinguished from other clients by a unique nickname. See the protocol grammar rules for what may and may not be used in a nickname. In addition to the nickname, all servers must have the following information about all clients: The real name of the host that the client is running on, the username of the client on that host, and the server to which the client is connected.

### Operators

To allow a reasonable amount of order to be kept within the IRC network, a special class of clients (operators) are allowed to perform general maintenance functions on the network. Although the powers granted to an operator can be considered as 'dangerous', they are nonetheless required.

Operators should be able to to perform basic networking tasks such as disconnecting and reconnecting servers as needed to prevent long-term use of bad network routing. See [](#squit-command) (SQUIT) and [](#connect-command) (CONNECT).

A more controversial power of operators is the ability to remove a user from the connected network by 'force', i.e. operators are able to close the connection between a client and server. The justification for this is delicate since its abuse is both destructive and annoying. For further details on this action, see [](#kill-command) (KILL).


## Channels

A channel is a named group of one or more clients which will all receive messages addressed to that channel. The channel is created implicitly when the first client joins it, and the channel ceases to exist when the last client leaves is. While the channel exists, any client can reference the channel using the name of the channel.

Channel names are strings (beginning with a '&' or '#' character)., Apart from the requirement of the first character being either '&' or '#'; the only restriction on a channel name is that it may not contain any spaces (' '), a control G (^G or ASCII 7), or a comma (',' which is used as a list item separator by the protocol).

There are two types of channels defined by this protocol. One is a distributed channel which is known to all the servers that are connected to the network. These channels are marked by the first character being a '#'. The second type are server-specific channels, where the clients connected can only see and talk to other clients on the same server. These channels are distinguished by the first character being a '&'.

On top of these two types, there are various channel modes available to alter the characteristics of individual channels. See [](#mode-command) (MODE command) for more details on this.

To create a new channel of become part of an existing channel, a user is required to JOIN the channel. If the channel doesn't exist prior to joining, the channel is created and the creating user becomes a channel operator. If the channel already exists, whether or not your request to JOIN that channel is honoured depends on the current modes of the channel. For example, if the channel is invite-only, (+i), then you may only join if invited. As part of the protocol, a user may be a part of several channels at once, but a limit may be imposed as to how many channels a user can be in at one time. This limit is specified the CHANLIMIT RPL_ISUPPORT token. See [](#feature-advertisement) (RPL_ISUPPORT) and [](#chanlimit) (CHANLIMIT) for more details on this.

If the IRC network becomes disjoint because of a split between servers, the channel on either side is only composed of those clients which are connected to servers on the respective sides of the split, possibly ceasing to exist on one side of the split. When the split is healed, the connecting servers ensure the network state is consistent between them.

### Channel Operators

Channel operators (also referred to as a "chop" or "chanop") on a given channel are considered to 'own' that channel. In recognition of this status, channel operators are endowed with certain powers which enable them to keep control and some sort of sanity in their channel.

As owners of a channel, channel operators are not required to have reasons for their actions, although if their actions are abusive, it may be reasonable to ask an IRC operator to intervene, or for the users to go elsewhere and form their own channel.

The commands which may only be used by channel operators are:

- KICK    - Eject a client from the channel
- MODE    - Change the channel's modes
- INVITE  - Invite a client to an invite-only channel (mode +i)
- TOPIC   - Change the channel topic in a mode +t channel

A channel operator is identified by the '@' symbol next to their nickname whenever it is associated with a channel (ie replies to the NAMES, WHO and WHOIS commands).



# IRC Concepts

This section is devoted to describing the concepts behind the organisation of the IRC protocol and how the current implementations deliver different classes of messages.


                              1--\
                                  A        D---4
                              2--/ \      /
                                    B----C
                                   /      \
                                  3        E

       Servers: A, B, C, D, E         Clients: 1, 2, 3, 4

^[fig:smallsamplenet::Sample small IRC network.]


## One-to-one communication

Communication on a one-to-one basis is usually only performed by clients, since most server-server traffic is not a result of servers talking only to each other.



# Protocol Structure

## Overview

The protocol as described herein is for use with client to server connections.

Various server to server protocols have been defined over the years, with TS6 and P10 (both based on the client to server protocol) among the most popular. However, with the fragmented nature of IRC server to server protocols and differences in server implementations, features and network designs, it is at this point impossible to define a single standard server to server protocol.

### Character Codes

It is strongly RECOMMENDED that IRC servers and clients use the UTF-8 [](#RFC3629) character encoding, however implementations MAY use an alternative 8-bit character encoding for backwards compatibility or historical reasons.

For historical reasons, the characters '{', '}', and '|' are considered to be the lower case equivalents of the characters '[', ']', and '\', respectively. This is a critical issue when determining the equivalence of two nicknames.

If the IRC server uses a character encoding other than UTF-8 or a casemapping other than the one specified in this section, it MUST include such information in the RPL_ISUPPORT numeric sent on completion of client registration, as set out in [](#rpl_isupport-parameters).


## Messages

Servers and clients send each other messages which may or may not generate a reply; client to server communication is essentially asynchronous in nature.

Each IRC message may consist of up to four main parts: tags (optional), the prefix (optional), the command, and the command parameters (of which there may be up to 15).

### Tags

Tags are additional and optional metadata included with relevant messages.

Every message tag is enabled by a capacity (as outlined in [](#capability-negotiation)). One capability may enable several tags is those tags are intended to be used together.

Each tag may have its own rules about how it can be used: from client to server only, from server to client only, or in both directions.

The server MUST NOT add a tag to a message if the client has not requested the capability which enables the tag. The server MUST NOT add a tag to a message before replying to a client's CAP REQ with CAP ACK. If a client requests a capability which enables one or more message tags, that client MUST be able to parse the message tags syntax.

Similarly, the client MUST NOT add a tag to messages before the server replies to the client's CAP REQ with CAP ACK. If the server accepts the capability request with CAP ACK, the server MUST be able to parse the message tags syntax.

Both clients and servers MAY parse supplied tags without any capabilities being enabled on the connection. They SHOULD ignore the tags of capabilities which are not enabled.

The rules for naming and registering tags are detailed in [](#message-tags)

### Message Prefix

The prefix is used by servers to indicate the true origin of a message. If the prefix is missing from the message, it is assumed to have originated from the connection from which it was received.

Clients SHOULD NOT use a prefix when sending a message from themselves; if they use a prefix, the only valid prefix is the registered nickname associated with the client. If the source identified by the prefix cannot be found in the server's internal database, or if the source is registered from a different link than from which the message arrived, the server MUST ignore the message silently.

### Command

The command must either be a valid IRC command or a three-digit number represented as text.


## Wire Format

The protocol messages are extracted from a contiguous stream of octets. A pair of characters, CR (0x13) and LF (0x10), act as message separators. Empty messages are silently ignored, which permits use of the sequence CR-LF between messages.

The tags, prefix, command, and all parameters are separated by one (or more) ASCII space character(s) (0x20).

The presense of tags is indicated with a single leading character ('@', 0x40), which MUST be the first character of the message itself. There MUST NOT be any whitespace between this leading character and the list of tags.

The presence of a prefix is indicated with a single leading colon character (':', 0x3b). If there are no tags it MUST be the first character of the message itself. There MUST NOT be any whitespace between this leading character and the prefix

IRC messages shall not exceed 1024 bytes in length, counting all characters including the trailing CR-LF. There are a maximum of 512 bytes allocated for message tags, including the leading '@' and trailing space. There are 510 bytes maximum allowed for the command and its parameters. There is no provision for continuation message lines.

### Wire format in 'pseudo' ABNF

The extracted message is parsed into the components `tags`, `prefix`, `command`, and a list of parameters (`params`).

The ABNF representation for this is:

      message    =  ["@" tags SPACE ] [ ":" prefix SPACE ] command
                    [ params ] crlf
      tags       =  tag *[";" tag]
      tag        =  key ["=" value]
      key        =  [ <vendor> '/' ] <sequence of letters, digits,
                    hyphens (`-`)>
      value      =  <sequence of any characters except NUL, BELL,
                    CR, LF, semicolon (`;`) and SPACE>
      vendor     =  hostname
      prefix     =  servername / ( nickname [ [ "!" user ] "@" host ] )
      command    =  1*letter / 3digit
      params     =  *13( SPACE middle ) [ SPACE ":" trailing ]
                 =/ 14( SPACE middle ) [ SPACE [ ":" ] trailing ]
          
      nospcrlfcl =  %x01-09 / %x0B-0C / %x0E-1F / %x21-39 / %x3B-FF
                      ; any octet except NUL, CR, LF, " " and ":"
      middle     =  nospcrlfcl *( ":" / nospcrlfcl )
      trailing   =  *( ":" / " " / nospcrlfcl )
      
      SPACE      =  %x20        ; space character
      crlf       =  %x0D %x0A   ; "carriage return" "linefeed"


NOTES:

1. After extracting the parameter list, all parameters are equal, whether matched by \<middle\> or \<trailing\>. \<trailing\> is just a syntactic trick to allow ASCII SPACE characters within a parameter.
2. The NUL (%x00) character is not special in message framing, but as it would cause extra complexities in traditional C string handling, it is not allowed within messages.
3. The last parameter may be an empty string.
4. Use of the extended prefix (['!' \<user\> ] ['@' \<host\> ]) is only intended for server to client messages in order to provide clients with more useful information about who a message is from without the need for additional queries.

Most protocol messages specify additional semantics and syntax for the extracted parameter strings dictated by their position in the list. For example, many server commands will assume that the first parameter after the command is a list of targets.



# Connection Registration

Immediately upon establishing a connection the client must attempt registration without waiting for any banner message from the server.

Until registration is complete, only a limited subset of commands may be accepted by the server.

The recommended order of commands during registration is as follows:

1. PASS
2. CAP
3. NICK
4. USER

The PASS command (see [](#password-command)) is not required for the connection to be registered, but if included it MUST precede the latter of the NICK and USER commands.

If the server supports capability negotiation, the CAP command (see [](#cap-command)) suspends the registration process and immediately starts the capability negotiation (see [](#capability-negotiation)) process.

The NICK and USER commands (see [](#nick-command) and [](#user-command), respectively) are used to identify the user's nickname, username and "real name". Unless the registration is suspended by a CAP negotiation, these commands will end the registration process.

Upon successful completion of the registration process, the server MUST send the RPL_WELCOME (001) and RPL_ISUPPORT (005) numerics. The server SHOULD also send the Message of the Day (MOTD), if one exists, and MAY send other numerics.


## Feature Advertisement

IRC server and networks implement many different IRC features, limits, and protocol options that clients should be aware of. The RPL_ISUPPORT (005) numeric is designed to advertise these features to clients on connection registration, providing a simple way for clients to change their behaviour according to what is implemented on the server.

Once client registration is complete, the server MUST send at least one RPL_ISUPPORT numeric to the client. The server MAY send more than one RPL_ISUPPORT numeric and it is RECOMMENDED that consecutive RPL_ISUPPORT numerics are sent adjacent to each other.

Clients SHOULD NOT assume a server supports a feature unless it has been advertised in RPL_ISUPPORT. For RPL_ISUPPORT parameters which specify a 'default' value, clients SHOULD assume the default value for these parameters until the server advertises these parameters itself. This is generally done for compatibility reasons with older versions of the IRC protocol that do not require the RPL_ISUPPORT numeric.

The ABNF representation for this is:

      isupport   =  [ ":" servername SPACE ] "005" SPACE nick SPACE
                    1*13( token SPACE ) ":are supported by this server"

      token      =  *1"-" parameter / parameter *1( "=" value )
      parameter  =  1*20 letter
      value      =  * letpun
      letter     =  ALPHA / DIGIT
      punct      =  %d33-47 / %d58-64 / %d91-96 / %d123-126
      letpun     =  letter / punct

      SPACE      =  %x20        ; space character

\<servername\> and \<nick\> are as specified above.

As with other local numerics, when RPL_ISUPPORT is delivered remotely, it MUST be converted into a `105` numeric before delivery to the client.

A token is of the form `-PARAMETER`, `PARAMETER`, or `PARAMETER=VALUE`. A server MAY send an empty value feild and a parameter MAY have a default value. A server MUST send the parameter as upper-case text. Unless otherwise stated, when a parameter contains a value, the value MUST be treated as being case sensitive. The value MAY contain multiple fields, if this is the case the fields MUST be delimited with a comma character (`,`).

It is possible for the status of features previously advertised to clients can change. When this happens, a server SHOULD reissue the RPL_ISUPPORT numeric with the relevant parameters that have changed. If a feature becomes unavailable, the server MUST prefix the parameter with the dash character ('-') when issuing the updated RPL_ISUPPORT.

As the maximum number of parameters to any reply is 15, the maximum number of RPL_ISUPPORT tokens that can be advertised is 13. To counter this, a server MAY issue multiple RPL_ISUPPORT numerics. A server MUST issue the RPL_ISUPPORT numeric after client registration has completed. It also MUST be issued after the RPL_WELCOME (001) numeric and MUST be issued before further commands from the client are processed.

A list of known RPL_ISUPPORT parameters is available in [](#rpl_isupport-parameters).


## Capability Negotiation

Over the years, various extensions to the IRC protocol have been made by server programmers. Often, these extensions are intended to conserve bandwidth, close loopholes left by the original protocol specification, or add new features for users or for the server administrators. Most of these changes are backwards-compatible with the base protocol specifications: A command may be added, a reply may be extended to contain more parameters, etc. However, there are extensions which may be designed to change protocol behaviour in a backwards-incompatible way.

Capability Negotiation is a mechanism for the negotiation of protocol extensions, known as **capabilities**, that is backwards-compatible with all existing IRC clients and servers (including those using earlier versions of the IRC protocol). While all servers implementing IRCv3 support capability negotiation, it is important for clients implementing IRCv3 to support servers using earlier protocol versions, and for servers implementing IRCv3 connecting to clients without support.

Any server not implementing capability negotiation will still interoperate with clients that do implement it; similarly, clients that do not implement capability negotiation may successfully communicate with a server that does implement it.

IRC is an asynchronous protocol, which means that clients may issue additional IRC commands while previous commands are being processed. Additionally, there is no guarantee of a specific kind of banner being issues upon connection. Some servers also do not complain about unknown commands during registration, which means that a client cannot reliably do passive implementation discovery at registration time.

The solution to these problems is to allow for active capability negotiation, and to extend the registration process with this negotiation. If the server support capability negotiation, the registration process will be suspended until negotiation is completed. If the server does not support this feature, then registration will complete immediately and the client will not use any capabilities.

Capability negotiation is started by the client issuing a `CAP LS` command. Negotiation is then performed with the `CAP REQ`, `CAP ACK`, and `CAP NAK` commands, and is ended with the `CAP END` command (See [](#cap-command)).

Once capability negotiation has ended, the registration process shall resume.



# Client commands


## Connection commands

### Password command

         Command: PASS
      Parameters: <password>

The PASS command is used to set a 'connection password'. The password can and must be set before any attempt to register the connection is made. This requires that clients send a PASS command before sending the CAP/NICK/USER combination.

The password supplied must match the one contained in I lines. It is possible to send multiple PASS commands before registering but only the last one sent is used for verification and it may not be changed once registered.

Numeric replies:

               ERR_NEEDMOREPARAMS              ERR_ALREADYREGISTRED

Example:

      PASS secretpasswordhere

### Nick command

         Command: NICK
      Parameters: <nickname>

The NICK command is used to give the client a nickname or change the previous one.

If the server receives a NICK command from a client with a `<nickname>` which is already in use on the network, it may issue an ERR_NICKCOLLISION to the client and ignore the NICK command.

Numeric Replies:

               ERR_NONICKNAMEGIVEN             ERR_ERRONEUSNICKNAME
               ERR_NICKNAMEINUSE               ERR_NICKCOLLISION

Example:

      NICK Wiz                  ; Introducing the new nick "Wiz".

      :WiZ NICK Kilroy          ; WiZ changed his nickname to Kilroy.

### User command

         Command: USER
      Parameters: <username> <hostname> <servername> <realname>

The USER command is used at the beginning of a connection to specify the username, hostname, servername and realname of a new user.

It must be noted that `<realname>` must be the last parameter, because it may contain space characters and must be prefixed with a colon (`:`) to make sure this is recognised as such.

Since it is easy for a client to lie about its username by relying solely on the USER command, the use of an "Identity Server" is recommended. If the host which a user connects from has such a server enabled, the username is set to that as in the reply from the "Identity Server". If the host does not have such a server enabled, the username is set to the value of the `<username>` parameter, prefixed by a tilde (`~`) to show that this value is user-set.

Numeric Replies:

                 ERR_NEEDMOREPARAMS              ERR_ALREADYREGISTRED

Examples:

      USER guest tolmoon tolsun :Ronnie Reagan
                                  ; No ident server
                                  ; User gets registered with username
                                  "~guest" and real name "Ronnie Reagan"

      USER guest tolmoon tolsun :Ronnie Reagan
                                  ; Ident server gets contacted and
                                  returns the name "danp"
                                  ; User gets registered with username
                                  "danp" and real name "Ronnie Reagan"

### CAP command

The CAP command takes a single required subcommand, optionally followed by a single parameter of space-separated capability identifiers. Each capability in the list MAY be preceded by a capability modifier (see [](#capability-modifiers)).

The subcommands for CAP are: LS, LIST, REQ, ACK, NAK, and END (see [](#cap-subcommands)).

The LS, LIST, REQ, ACK and NAK subcommands MAY be followed by a single parameter containing a space-separated list of capabilities.

If more than one capability is named, the designated sentinal (`:`) for a multi-parameter argument MUST be present.

If a client sends a subcommand which is not in the list above or otherwise issues an invalid command, then ERR_INVALIDCAPCMD (numeric 410) MUST be sent. The first parameter after the client identifier (usually nickname) MUST be the command name; the second parameter SHOULD be a human-readable description of the error.

Replies from the server must contain the client identifier name or an asterisk (`*`) if one is not yet available.

#### Capability Modifiers

There are three capability modifiers specified by this document. If a capability modifier is to be used, it MUST directly proceede the capability identifier.

The capability modifiers are:

* "-" modifier (disable): this modifier indicates that the capability is being disabled.
* "~" modifier (ack): this modifier indicates the client must acknowledge the capability using an ACK subcommand.
* "=" modifier (sticky): this modifier indicates that the specified capability may not be disabled.

### CAP subcommands

#### CAP LS subcommand

The LS subcommand is used to list the capabilities supported by the server. The client should send an LS subcommand with no other arguments to solicit a list of all arguments.

If a client issues an LS subcommand during client registration, registration must be suspended until an END subcommand is received.

Example:

      Client: CAP LS
      Server: CAP * LS :multi-prefix sasl

#### CAP LIST subcommand

The LIST subcommand is used to list the capabilities associated with the active connection. The client should send a LIST subcommand with no other arguments to solicit a list of active capabilities.

If no other capabilities are active, an empty parameter must be sent.

Example:

      Client: CAP LIST
      Server: CAP * LIST :multi-prefix

#### CAP REQ subcommand

The REQ subcommand is used to request a change in capabilities associated with the active connection. Its sole parameter must be a list of space-separated capability identifiers. Each capability identifier must be prefixed with a dash (`-`) to designate that the capability should be disabled.

The capability identifier set must be accepted as a whole, or rejected entirely.

If a client issues a REQ subcommand, registration must be suspended until an END subcommand is received.

Example:

      Client: CAP REQ :multi-prefix sasl
      Server: CAP * ACK :multi-prefix sasl

#### CAP ACK subcommand

The ACK subcommand has two uses:

* The server sends it to acknowledge a REQ subcommand.
* The client sends it to acknowledge capabilities which require client-side acknowledgement.

If an ACK reply originating from the server is spread across multiple lines, a client MUST NOT change capabilities until the last ACK of the set is received. Equally, a server MUST NOT change the capabilities of the client until the last ACK of the set has been sent.

In the first usage, acknowledging a REQ subcommand, the ACK subcommand has a single parameter consisting of a space-separated list of capability names, which may optionally be preceded with one or more modifiers (see [](#capability-modifiers) for details of capability modifiers).

The third usage is when, in the preceding case, some capability names may have been preceded with the ack modifier. ACK in this case is used to full enable or disable the capability. Clients MUST NOT issue an ACK subcommand for any capability not marked with the ack modifier in a server-generated ACK subcommand.

#### CAP NAK subcommand

The NAK subcommand designates that the requested capability change was rejected. The server MUST NOT make any change to any capabilities if it replies with a NAK subcommand.

The argument of the NAK subcommand MUST consist of at least the first 100 characters of the capability list in the REQ subcommand which triggered the NAK.

#### CAP END subcommand

The END subcommand signals to the server that capability negotiation is complete and requests that the server continue with client registration. If the client is already registered, this command MUST be ignored by the server.

Clients that support capabilities but do not wish to enter negotiation SHOULD send CAP END upon connection to the server.


## Server Queries and Commands

The server query group of commands has been designed to return information about any server which is connected to the networks. All servers connected must respond to these queries and respond correctly. Any invalid response (or lack thereof) must be considered a sign of a broken server and it must be disconnected/disabled as soon as possible until the situation is remedied.

In these queries, where a parameter appears as `<server>`, it usually means it can be a nickname or a server or a wildcard name of some sort. For each parameter, however, only one query and set or replies is to be generated.


### VERSION command

         Command: VERSION
      Parameters: [<server>]

The VERSION command is used to query the version of the server software, and to request the server's ISUPPORT tokens. An optional parameter `<server>` is used to query the version of the given server instead of the server the client is directly connected to.

Numeric Replies:

               ERR_NOSUCHSERVER                RPL_VERSION

Examples:

      :Wiz VERSION *.se               ; message from Wiz to check the
                                      version of a server matching "*.se"

      VERSION tolsun.oulu.fi          ; check the version of server
                                      "tolsun.oulu.fi".


### CONNECT command

         Command: CONNECT
      Parameters: <target server> [<port> [<remote server>]]

The CONNECT command forces a server to try to establish a new connection to another server. CONNECT is a privileged command and is available only to IRC Operators. If a remote server is given, the connection is attempted by that remote server to `<target server>` using `<port>`.

Numeric Replies:

               ERR_NOSUCHSERVER                ERR_NEEDMOREPARAMS
               ERR_NOPRIVILEGES

Examples:

      CONNECT tolsun.oulu.fi
      ; Attempt to connect the current server to tololsun.oulu.fi

      CONNECT  eff.org 12765 csd.bu.edu
      ; Attempt to connect csu.bu.edu to eff.org on port 12765


### TIME command

         Command: TIME
      Parameters: [<server>]

The TIME command is used to query local time from the specified server. If the server parameter is not given, the server handling the command must reply to the query.

Numeric Replies:

               ERR_NOSUCHSERVER                RPL_TIME

Examples:

      TIME tolsun.oulu.fi             ; check the time on the server
                                      "tolson.oulu.fi"

      Angel TIME *.au                 ; user angel checking the time on a
                                      server matching "*.au"


### STATS command

         Command: STATS
      Parameters: [<query> [<server>]]

The STATS command is used to query statistics of a certain server. If the `<server>` parameter is ommitted, only the end of stats reply is sent back. The implemented of this command is highly dependent on the server which replies, although the server must be able to supply information as described by the queries below (or similar).

A query may be given by any single letter which is only checked by the destination server and is otherwise passed on by intermediate servers, ignored and unaltered.

The following queries are those found in current IRC implementations and provide a large portion of the setup information for that server. All servers should be able to supply a valid reply to a STATS query which is consistent with the reply formats currently used and the purpose of the query.

The currently supported queries are:

        c - returns a list of servers which the server may connect
            to or allow connections from;
        h - returns a list of servers which are either forced to be
            treated as leaves or allowed to act as hubs;
        i - returns a list of hosts which the server allows a client
            to connect from;
        k - returns a list of banned username/hostname combinations
            for that server;
        l - returns a list of the server's connections, showing how
            long each connection has been established and the traffic
            over that connection in bytes and messages for each
            direction;
        m - returns a list of commands supported by the server and
            the usage count for each if the usage count is non zero;
        o - returns a list of hosts from which normal clients may
            become operators;
        y - show Y (Class) lines from server's configuration file;
        u - returns a string showing how long the server has been up.

Numeric Replies:

            ERR_NOSUCHSERVER
            RPL_STATSCLINE                  RPL_STATSNLINE
            RPL_STATSILINE                  RPL_STATSKLINE
            RPL_STATSQLINE                  RPL_STATSLLINE
            RPL_STATSLINKINFO               RPL_STATSUPTIME
            RPL_STATSCOMMANDS               RPL_STATSOLINE
            RPL_STATSHLINE                  RPL_ENDOFSTATS

Examples:

      STATS m                         ; check the command usage for the
                                      server you are connected to

      :Wiz STATS c eff.org            ; request by WiZ for C/N line
                                      information from server eff.org

















# Temporary headers so references to unwritten sections work

### Kill Command

### Mode Command

### Channel Prefix

### Feature Advertisement Appendix

### Notice Command

### Privmsg Command

### User Command

### Squit Command

### Message Tags

### Channel Bans and Exceptions

### Channel Invitation

### Sending Messages

### Topic Command

### ISON Command



# Acknowledgements

Parts of this document came from the "IRC RPL_ISUPPORT Numeric Definition" Internet Draft authored by L. Hardy, E. Brocklesby, and K. Mitchell. Parts of this document came from the "IRC Client Capabilities Extension" Internet Draft authored by K. Mitchell, P. Lorier, L. Hardy, and P. Kucharski.

Thanks to all the IRC software and document authors throughout the years.
