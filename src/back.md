# RPL_ISUPPORT Parameters

Servers MAY send parameters that are not covered in this document.


## CLIENTVER

      CLIENTVER=string

The CLIENTVER parameter is informational purposes only and indicates the version of the client protocol supported by the server that the client is connected to. The version specified by this document is `3`.

The value MUST be specified. A client SHOULD NOT use this value to change client behaviour.

Example CLIENTVER tokens:

      CLIENTVER=3

      CLIENTVER=3.2


## CASEMAPPING

      CASEMAPPING=string

The CASEMAPPING parameter is used to indicate what method if used by the server to compare equality of case-insensitive strings. Possible values are:

* `ascii`: The ASCII characters 97 to 122 (decimal) are defined as the lower-case characters of ASCII 65 to 90 (decimal). No other character equivalency is defined.
* `rfc1459`: The ASCII characters 97 to 126 (decimal) are defined as the lower-case characters of ASCII 65 to 94 (decimal). No other character equivalency is defined.
* `strict-rfc1459`: The ASCII characters 97 to 125 (decimal) are defined as the lower-case characters of ASCII 65 to 93 (decimal). No other character equivalency is defined.

The value MUST be specified. The default value for this token is `rfc1459`, and clients should assume this until the server sends a CASEMAPPING token.

An example CASEMAPPING token:

      CASEMAPPING=rfc1459


## CHANLIMIT

      CHANLIMIT=prefix:number[,prefix:number[,...]]

The CHANLIMIT parameter is used to indicate the maximum amount of channels that a client may join. The value is a series of "prefix:number" pairs, where "prefix" refers to one or more prefix characters defined in the PREFIX ([](#prefix)) token, and "number" indicates how many channels of the given type combined may be joined. The number parameter MAY be omitted if no limit is placed on the number of channels.

A client SHOULD NOT make any assumptions about how many channels other clients may join based on the CHANLIST parameter.

An example CHANLIMIT token:

      CHANLIMIT=#+:25,&:

Indicates that a client may join up to 25 channels with the prefix `#` and `+`, and an unlimited number of channels with the `&` prefix.


## CHANMODES

      CHANMODES=A,B,C,D

The CHANMODES parameter is used to indicate the channel modes available and the arguments they take. There are four categories of modes, defined as follows:

* Type A: Modes that add or remove an address to or from a list. These modes MUST always have a parameter when sent from the server to a client. A client MAY issue the mode without an argument to obtain the current contents of the list.
* Type B: Modes that change a setting on a channel. These modes MUST always have a parameter.
* Type C: Modes that change a setting on a channel. These modes MUST have a parameter when being set, and MUST NOT have a parameter when being unset.
* Type D: Modes that change a setting on a channel. These modes MUST NOT have a parameter.

To allow for future extensions, a server MAY send additional types, delieted by the comma character (`,`). The behaviour of any additional types is undefined.

The IRC server MUST NOT list modes in the CHANMODES parameter that are contained within the PREFIX ([](#prefix)) parameter. However, for completeness, modes within the PREFIX parameter may be treated as type B modes.

An example CHANMODES token:

      CHANMODES=b,k,l,imnpst


## CHANNELLEN

      CHANNELLEN=number

The CHANNELLEN parameter specifies the maximum length of a channel name that a client may join. A client elsewhere on the network MAY join a channel with a name length of a higher value. The value MUST be specified and MUST be numeric.

An example CHANNELLEN token:

      CHANNELLEN=50

Limits the length of a channel name that a user may join to 50 characters.


## CHANTYPES

      CHANTYPES=[string]

Special characters used as prefixes are reserved to differentiate channels from other namespaces within the IRC protocol. The CHANTYPES parameter specifies these characters.

The value is OPTIONAL and when it is not specified indicates that no channel types are supported.

An example CHANTYPES token:

      CHANTYPES=&#

Denotes the andpersand (`&`) and hash (`#`) characters as valid channel prefixes


## CNOTICE

      CNOTICE

The CNOTICE parameter indicates that the server supports the `CNOTICE` command. An extension of the NOTICE command, as defined in [](#notice-command), it allows users with a specific status in a channel to issue a NOTICE command to a user within that channel, free of certain restrictions a server MAY apply to NOTICE.

The CNOTICE parameter MUST NOT be specified with a value.

An example CNOTICE token:

      CNOTICE


## CPRIVMSG

      CPRIVMSG

The CPRIVMSG parameter indicates that the server supports the `CPRIVMSG` command. An extension of the PRIVMSG command, as defined in [](#privmsg-command), it allows users with a specific status in a channel to issue a PRIVMSG command to a user within that channel, free of certain restrictions a server MAY apply to PRIVMSG.

The CPRIVMSG parameter MUST NOT be specified with a value.

An example CPRIVMSG token:

      CPRIVMSG


## ELIST

      ELIST=string

The ELIST parameter indicates that the server supports search extensions to the LIST command. The value is required, and is a non-delimited set of characters which each denote an extension. The following extensions, which a client MUST treat as being case insensitive are defined:

* C: Searching based on creation time, via the `C<val` and `C>val` modifiers to search for a channel creation time that is lower or higher than val, respectively.
* M: Searching based on mask.
* N: Searching based on ~mask.
* P: To explain. XXX -
* T: Searching based on topic time, via the `T<val` and `T>val` modifiers to search for a topic time that is lower of higher than val, respectively.
* U: Searching based on user count within the channel, but the `<val` and `>val` modifiers to search for a chnanel that has less than or more than val users, respectively.

An example ELIST token:

      ELIST=CMNTU


## EXCEPTS

      EXCEPTS[=letter]

The EXCEPTS parameter indicates that the server supports "ban exceptions", as defined in ()[#channel-bans-and-exceptions]. The value is OPTIONAL and when not specified indicates taht the letter 'e' is used as the channel mode for ban exceptions. When the value is specified, it indiates the letter which is used for ban exceptions.

An example EXCEPTS token:

      EXCEPTS


## INVEX

      INVEX[=letter]

The INVEX parameter indicates that the server supports "invite exceptions", as defined in [](#channel-invitation). The value is OPTIONAL, and when not specified indicates that the letter `I` is used as the channel mode for invite exceptions. When the value is specified, it indicates the letter is used for invite exceptions.

An example INVEX token:

      INVEX


## MAXLIST

      MAXLIST=mode:number[,mode:number[,...]]

The MAXLIST parameter limits how many "variable" modes of type A that have been defined in the CHANMODES (()[#chanmodes]) token a client may set in total on a channel. The value MUST be specified and is a set of "mode:number" pairs, where "mode" refers to a type A mode defined in the CHANMODES token and "number" indicates how many of the given modes combined a client may issue on a channel.

A client MUST NOT make any assumptions about how many of the given modes actually exist on the channel. The limit applies only to the client setting new modes of the given types.

Example MAXLIST tokens:

      MAXLIST=beI:25

Indicates that a client may set to a total of 25 of a combination of `+b`, `+e`, and `+I` modes.

      MAXLIST=e:25,eI:50

Indicates that a client may set up to a total of 25 `+b` modes, and up to a total of 50 of a combination of `+e` and `+I` modes.


## MODES

      MODES=[number]

The MODES parameter limits how many "variable" modes may be set on a channel by a single MODE command from a client. A "variable" mode is defined as being a type A, B or C as defined for the CHANMODES ([](#chanmodes)) parameter, and the channel modes specified in the PREFIX ([](#prefix)) parameter.

A client SHOULD NOT issue more "variables" modes than this in a single "mode" command. A server MAY however issue more "variable" modes than this in a single MODE command. The value is OPTIONAL and when specified indicates that no limit is places upon "variable" modes. The value, if specified, MUST be numeric.

An example MODES token:

      MODES=3

Limits the number of "variable" modes from a client to the server to 3 per MODE command.


## NETWORK

      NETWORK=string

The NETWORK parameter is for informational purposes only and defines the name of the IRC network that the client is connected to. The value MUST be specified. A client SHOULD NOT use the value to make assumptions about supported features on the server.

An example NETWORK token:

      NETWORK=EFnet

Indicates the client is connected to the EFnet IRC network.


## NICKLEN

      NICKLEN=number

The NICKLEN parameter specifies the maximum length of a nickname that a client can use. A client elsewhere on the network MAY use a nick length of a higher value. The value MUST be specified and MUST be numeric.

An example NICKLEN token:

      NICKLEN=9

Limits the length of a nickname to 9 characters.


## PREFIX

      PREFIX=[(modes)prefixes]

Within channels, clients can have various different statuses, denoted by single character "prefixes". The PREFIX parameter specifies these pefixes and the channel mode character that it is mapped to. There is a one-to-one mapping between prefixes and channel modes. The prefixes are in descending order, from the prefix that gives the most privileges to the prefix that gives the least.

The value is OPTIONAL and when it is not specified indicates that no prefixes are supported.

An example PREFIX token:

      PREFIX=(ov)@+

Denotes that the at character (`@`) is mapped to the channel mode denoted by the letter 'o', and the plus character (`+`) is mapped to the channel mode denoted by the letter 'v'.


## SAFELIST

      SAFELIST

The SAFELIST parameter indicates that the client may request a `LIST` command from the server, without being disconnected by the large amount of data the LIST command generates. The SAFELIST parameter MUST NOT be specified with a value.

An example SAFELIST token:

      SAFELIST


## SILENCE

      SILENCE=number

The SILENCE parameter indicates the maximum number of entries a user may have in their silence list. The value is OPTIONAL and if it is not specified indicates SILENCE support is not available.

Whilst a formal definition of the SILENCE command is outside the scope of this document, it is generally a list of masks of equivalent form to those defined as type A in the CHANMODES ([](#chanmodes)) parameter. Any messages, as defined in [](#sending-messages) that originate from another client matching the given mask, with a destination of the client itself will be dropped by the server.

An example SILENCE token:

      SILENCE=15

Indicates that the client may have 15 masks in their silence list.


## STATUSMSG

      STATUSMSG=string

The STATUSMSG parameter indicates that the server supports a method for the client to send a message via the NOTICE command to those people on a channel with the specified status.

The value MUST be specified and MUST be a non-delimited list of prefixes that have been defined in the PREFIX ([](#prefix)) parameter. The server MUST NOT advertise a character in STATUSMSG which is also present in CHANTYPES ([](#chantypes)).

An example STATUSMSG token:

      STATUSMSG=@+

Presuming the hash character (`#`) is defined within the CHANTYPES ([](#chantypes)) parameter, allows the client to send a NOTICE command to "@#channel" and "+#channel".


## TARGMAX

      TARGMAX=[cmd:number,cmd:number,...]

Certain command from a client MAY contain multiple targets, delimited by a comma character (`,`). The TARGMAX parameter defines the maximum number of targets allowed for commands which accept multiple targets. The value is OPTIONAL and is a set of "cmd:number" pairs, where "cmd" refers to a command the client MAY send to the server, and "number" refers to the maximum number of targets for this command. A client MUST treat the "cmd" field as case insensitive.

If the number is not specified for a particular command, then the command does not have a limit on the number of targets. The server MUST specify all commands available to the user which support multiple targets.

If the TARGMAX parameter is not advertised, or a value is not sent then a client SHOULD assume that no commands except the JOIN and PART commands accept multiple parameters.

An example TARGMAX token:

      TARGMAX=PRIVMSG:3,WHOIS:1,JOIN:

Indicates that a client could issue 3 targets to a PRIVMSG command, 1 target to a WHOIS command and an unlimited number of targets to a JOIN command.


## TOPICLEN

      TOPICLEN=number

The TOPICLEN parameter specifies the maximum length of a topic, defined in [](#topic-command) that a client may set on a channel. A channel on the network MAY have a topic with a longer length. The value MUST be specified and MUST be numeric.

An example TOPICLEN token:

      TOPICLEN=120

Limits the length of a topic to 120 characters.


## WATCH

      WATCH=number

The WATCH parameter indicates the maximum number of nicknames a user may have in their watch list. The value MUST be specified.

Whilst a formal definition of the WATCH command is outside the scope of this document, it is generally a method for clients to have the server notify them when a given nickname joins or leaves the network. It is designed to replace repetitive use by clients of the ISON command, as defined in [](#ison-command).

An example WATCH token:

      WATCH=100

Indicates that a client may have up to 100 nicks in their watch list.
