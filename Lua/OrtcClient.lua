#!/usr/bin/env lua
local base_char,keywords=128,{"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while","Strings","find","require","string","_SUPER","isNullOrEmpty","self","error","uri_part_not_allowed","\"uri._util\"","userinfo","path","subclass_of","package","setmetatable","preload","WebSocketConnection","isConnected","OrtcClient","uri_encode","select","ortcIsValidInput","default_port","\"Channel has invalid characters\"","attempt_require","validHandshakeResponse","\"\"","isSubscribed","gsub","\"Channel is null or empty\"","isSubscribing","remove_dot_segments","uri_decode","_NAME","do_class_changing_change","\"Channel size exceeds the limit of \"","sub","\"invalid namespace identifier (\"","init","host","ProxyProperties","tonumber","\"Not connected\"","\"string\"","clusterUrl","\"usernames and passwords are not allowed in HTTP URIs\"","connectionMetadata","\"/\"","tostring","_userinfo","onMessageCallback","tableSize","nss","getmetatable","table","__index","filesystem_path","announcementSubChannel","_port","_host","new","\"uri\"","disconnect","make_file_uri","type","_scheme","pairs","lower","receive","scheme","\" characters\"","\"invalid namespace specific string (\"","connectionTimeout","authToken","len","\"pop user name must not be empty\"","assert","\"pop auth type must not be empty\"","\":\"","\")\"","\"Unable to get URL from cluster\"","\"^A-Za-z0-9%-._~!$&'()*+,;=:@/\"","_path","_uri","\";\"","onUnsubscribed","ortcIsValidUrl","onDisconnected","\"uri._relative\"","remove","\"userinfo\"","appKey","\"^A-Za-z0-9%-._~!$&'()*+,;=\"","\"contains illegal character\"","send","port","query","\"invalid userinfo value '\"","\"'\"","\"uri.urn\"","onSubscribed","\"#\"","numItems","subscribeOnReconnected","_query","onConnected",}; function prettify(code) return code:gsub("["..string.char(base_char).."-"..string.char(base_char+#keywords).."]", 
	function (c) return keywords[c:byte()-base_char]; end) end return assert(loadstring(prettify[===[£.•['_login']=(â(...)
å e={∑="uri._login"}
å i=òü
å t=ò”
i.¢(e,t)
å â a(e)
ä e í
å t=e:ó(‰)
ä t Å e:ó(‰,t+1)í
ë ç,"only one colon allowed in userinfo"
Ü
Ü
ë ì
Ü
â e.init_base(e)
å t=e:Ω()
ä é t è t==∞í
ë ç,"host missing from login URI"
Ü
å t,a=a(e:†())
ä é t í ë ç,a Ü
ë e
Ü
â e.†(t,...)
ä ™(˚,...)>0 í
å t,e=a(...)
ä é t í ù("invalid userinfo value ("..e..Â)Ü
Ü
ë e.ö.†(t,...)
Ü
â e.username(o,...)
å t=e.ö.†(o)
å a,n
ä t í
å e=t Å t:ó(‰)
a=e Å t:∫(1,e-1)è t
a=i.∂(a)
Ü
ä ™('#',...)>0 í
å a=n Å t:∫(n)è∞
å t=...
ä é t í
e.ö.†(o,ç)
Ñ
t=i.©(t,Ú)
e.ö.†(o,t..a)
Ü
Ü
ë a
Ü
â e.password(n,...)
å t=e.ö.†(n)
å a,o
ä t í
o=t Å t:ó(‰)
a=o Å t:∫(o+1)è ç
ä a í a=i.∂(a)Ü
Ü
ä ™('#',...)>0 í
å a=...
å t=o Å t:∫(1,o-1)è t
ä é a í
e.ö.†(n,t)
Ñ
ä é t í t=∞Ü
a=i.©(a,Ú)
e.ö.†(n,t..‰..a)
Ü
Ü
ë a
Ü
ë e
Ü)
£.•['_relative']=(â(...)
å a={∑=Ó}
å i=òü
å o=ò”
i.¢(a,o)
â a.º(e)
ë e
Ü
â a.€(e,...)
ä ™(˚,...)>0 í
ù("relative URI references can't have a scheme, perhaps you"..
" need to resolve this against an absolute URI instead")
Ü
ë ç
Ü
â a.is_relative()ë ì Ü
å â n(e,t,a)
ä a Å e==∞í
ë≈..t
Ü
ë e:≤("[^/]+$",∞,1)..t
Ü
å â s(e,t)
ä ÷(t)==¡í t=‚(o:“(t))Ü
§(e,o)
ä e:Ω()è e:†()è e:ı()í
e:°(i.µ(e:°()))
e:€(t:€())
ë
Ü
å a=e:°()
ä a==∞í
e:°(t:°())
ä é e:ˆ()í e:ˆ(t:ˆ())Ü
Ñ
ä a:ó("^/")í
e:°(i.µ(a))
Ñ
å o=t:Ω()è t:†()è t:ı()
å t=n(t:°(),a,o)
e:°(i.µ(t))
Ü
Ü
e:Ω(t:Ω())
e:†(t:†())
e:ı(t:ı())
e:€(t:€())
Ü
â a.resolve(e,a)
å t=∆(e)
å a,i=pcall(s,e,a)
ä a í ë Ü
å t=‚(o:“(t))
à t ã ÿ(e)É e[t]=ç Ü
à t,a ã ÿ(t)É e[t]=a Ü
§(e,À(t))
ù("resolved URI reference would be invalid: "..i)
Ü
â a.relativize(e,e)Ü
ë a
Ü)
£.•['_util']=(â(...)
å t={∑=ü}
å a={}
à e=0,255 É
a[ô.char(e)]=ô.format("%%%02X",e)
Ü
â t.©(t,e)
ä é t í ë Ü
ä é e í
e="^A-Za-z0-9%-_.!~*'()"
Ü
ë(t:≤("(["..e.."])",
â(e)ë a[e]Ü))
Ü
â t.∂(t,e)
ä é t í ë Ü
ä e í e="["..e.."]"Ü
ë(t:≤("%%(%x%x)",â(a)
å t=ô.char(ø(a,16))
ë(e Å é t:ó(e))Å"%"..a è t
Ü))
Ü
â t.µ(e)
å t=∞
ï e~=∞É
ä e:ó("^%.%.?/")í
e=e:≤("^%.%.?/",∞,1)
Ö e:ó("^/%./")è e=="/."í
e=e:≤("^/%./?",≈,1)
Ö e:ó("^/%.%./")è e=="/.."í
e=e:≤("^/%.%./?",≈,1)
ä t:ó(≈)í
t=t:≤("/[^/]*$",∞,1)
Ñ
t=∞
Ü
Ö e=="."è e==".."í
e=∞
Ñ
å i,a,o=e:ó("^(/?[^/]*)")
e=e:∫(a+1)
t=t..o
Ü
Ü
ë t
Ü
â t.split(i,t,n)
ä t==∞í ë{}Ü
å a,o=1,ô.ó(t,i)
ä é o í ë{t}Ü
å e={}
ï ì É
ä#e+1==n í e[n]=t:∫(a);ë e Ü
e[#e+1]=t:∫(a,o-1)
a=o+1
o=ô.ó(t,i,a)
ä é o í
e[#e+1]=t:∫(a)
Ç
Ü
Ü
ë e
Ü
â t.Æ(e)
å t,e=pcall(ò,e)
ä t í
ë e
Ö ÷(e)==¡Å
e:ó("module '.*' not found")í
ë ç
Ñ
ù(e)
Ü
Ü
â t.¢(e,t)
e.Õ=e
e.__tostring=t.__tostring
e.ö=t
§(e,t)
Ü
â t.∏(t,i,n,a,
o)
å e={}
§(e,i)
à t,a ã ÿ(t)É e[t]=a Ü
o(e,a)
e.È=ç
å o,i=e:º()
ä é o í
ù("URI not valid after "..n.." changed to '"..
a.."': "..i)
Ü
§(t,À(e))
à e ã ÿ(t)É t[e]=ç Ü
à e,a ã ÿ(e)É t[e]=a Ü
Ü
â t.û(t,e)
t[e]=â(t,a)
ä a í ù(e.." not allowed on this kind of URI")Ü
ë t["_"..e]
Ü
Ü
ë t
Ü)
£.•['data']=(â(...)
å e={∑="uri.data"}
å t=òü
å a=ò”
t.¢(e,a)
å i=t.Æ("datafilter")
å â n(e)ë e:ó("^[0-9a-zA-Z/+]*$")Ü
å â o(e)
å t,t,e,a=e:ó("^([^,]*),(.*)")
ä é e í ë"must have comma in path"Ü
å t=á
ä e:ó(";base64$")í
t=ì
e=e:∫(1,-8)
Ü
ä t Å é n(a)í
ë"illegal character in base64 encoding"
Ü
ë ç,e,t,a
Ü
â e.º(t)
ä e.ö.Ω(t)í
ë ç,"data URIs may not have authority parts"
Ü
å e,a,a,a=o(e.ö.°(t))
ä e í ë ç,"invalid data URI ("..e..ÂÜ
ë t
Ü
â e.data_media_type(i,...)
å s,a,o,n=o(e.ö.°(i))
ä ™('#',...)>0 í
å a=...è∞
a=t.©(a,"^A-Za-z0-9%-._~!$&'()*+;=:@/")
ä o í a=a..";base64"Ü
e.ö.°(i,a..","..n)
Ü
ä a~=∞í
ä a:ó("^;")í a="text/plain"..a Ü
ë t.∂(a)
Ñ
ë"text/plain;charset=US-ASCII"
Ü
Ü
å â r(t)
å e=t:≤("[A-Za-z0-9%-._~!$&'()*+,;=:@/]",∞):‡()
å t=t:‡()-e
ë t+e*3
Ü
å â h(e)
å e=(e:‡()+2)/3
e=e-e%1
ë e*4
+7
Ü
å â s(e,t)
ë i[e](t)
Ü
â e.data_bytes(n,...)
å l,o,d,a=o(e.ö.°(n))
ä d í
ä é i í
ù("'datafilter' Lua module required to decode base64 data")
Ü
a=s("base64_decode",a)
Ñ
a=t.∂(a)
Ü
ä ™('#',...)>0 í
å t=...è∞
å a=r(t)
å h=h(t)
ä h<a Å i í
o=o..";base64"
t=s("base64_encode",t)
Ñ
t=t:≤("%%","%%25")
Ü
e.ö.°(n,o..","..t)
Ü
ë a
Ü
â e.°(a,...)
å i=e.ö.°(a)
ä ™('#',...)>0 í
å t=...
ä é t í ù("there must be a path in a data URI")Ü
å o=o(t)
ä o í ù("invalid data URI ("..o..Â)Ü
e.ö.°(a,t)
Ü
ë i
Ü
t.û(e,)
t.û(e,"host")
t.û(e,"port")
ë e
Ü)
£.•['unix']=(â(...)
å t={∑="uri.file.unix"}
å o=ò”
å a=òü
â t.Œ(e)
ä e:Ω()~=∞í
ù("a file URI with a host name can't be converted to a Unix path")
Ü
å e=e:°()
ä e:ó("%%00")è e:ó("%%2F")í
ù("Unix paths cannot contain encoded null bytes or slashes")
Ü
ë a.∂(e)
Ü
â t.’(e)
ä é e:ó("^/")í
ù("Unix relative paths can't be converted to file URIs")
Ü
e=e:≤("//+",≈)
e=a.©(e,Á)
ë ‚(o:“("file://"..e))
Ü
ë t
Ü)
£.•['win32']=(â(...)
å a={∑="uri.file.win32"}
å i=ò”
å o=òü
â a.Œ(e)
å t=e:Ω()
å e=o.∂(e:°())
ä t~=∞í e="//"..t..e Ü
ä e:ó("^/[A-Za-z]|/")è e:ó("^/[A-Za-z]|$")í
e=e:≤("|",‰,1)
Ü
ä e:ó("^/[A-Za-z]:/")í
e=e:∫(2)
Ö e:ó("^/[A-Za-z]:$")í
e=e:∫(2)..≈
Ü
e=e:≤(≈,"\\")
ë e
Ü
â a.’(t)
ä t:ó("^[A-Za-z]:$")í t=t.."\\"Ü
å n,n,a,e=t:ó("^\\\\([A-Za-z.]+)\\(.*)$")
a=a è∞
e=e è t
e=e:≤("\\",≈)
:≤("//+",≈)
e=o.©(e,Á)
ä é e:ó("^/")í e=≈..e Ü
ë ‚(i:“("file://"..a..e))
Ü
ë a
Ü)
£.•['file']=(â(...)
å e={∑="uri.file"}
å a=òü
å t=ò”
a.¢(e,t)
â e.º(e)
ä e:†()è e:ı()í
ë ç,√
Ü
å t=e:Ω()
å a=e:°()
ä t í
ä t:Ÿ()=="localhost"í e:Ω(∞)Ü
Ñ
ä é a:ó("^/")í
ë ç,"file URIs must contain a host, even if it's empty"
Ü
e:Ω(∞)
Ü
ä a==∞í e:°(≈)Ü
ë e
Ü
â e.Ω(a,...)
å o=e.ö.Ω(a)
ä ™('#',...)>0 í
å t=...
ä é t í ù("file URIs must have an authority part")Ü
ä t:Ÿ()=="localhost"í t=∞Ü
e.ö.Ω(a,t)
Ü
ë o
Ü
â e.°(a,...)
å o=e.ö.°(a)
ä ™('#',...)>0 í
å t=...
ä é t è t==∞í t=≈Ü
e.ö.°(a,t)
Ü
ë o
Ü
å â o(t)
å e=a.Æ("uri.file."..t:Ÿ())
ä é e í
ù("no file URI implementation for operating system "..t)
Ü
ë e
Ü
â e.Œ(e,t)
ë o(t).Œ(e)
Ü
â e.’(e,t)
ë o(t).’(e)
Ü
a.û(e,)
a.û(e,"port")
ë e
Ü)
£.•['ftp']=(â(...)
å e={∑="uri.ftp"}
å a=òü
å t=ò"uri._login"
a.¢(e,t)
â e.¨()ë 21 Ü
â e.º(t)
t,err=e.ö.init_base(t)
ä é t í ë ç,err Ü
å e=t:Ω()
ä é e è e==∞í
ë ç,"FTP URIs must have a hostname"
Ü
ä t:°()==∞í t:°(≈)Ü
ë t
Ü
â e.°(a,...)
å o=e.ö.°(a)
ä ™(˚,...)>0 í
å t=...
ä é t è t==∞í t=≈Ü
e.ö.°(a,t)
Ü
ë o
Ü
â e.ftp_typecode(i,...)
å t=e.ö.°(i)
å n,n,o,a=t:ó("^(.*);type=(.*)$")
ä é o í o=t Ü
ä a==∞í a=ç Ü
ä ™(˚,...)>0 í
å t=...
ä é t í t=∞Ü
ä t~=∞í t=";type="..t Ü
e.ö.°(i,o..t)
Ü
ë a
Ü
ë e
Ü)
£.•['http']=(â(...)
å e={∑="uri.http"}
å t=òü
å a=ò”
t.¢(e,a)
â e.¨()ë 80 Ü
â e.º(e)
ä e:†()í
ë ç,√
Ü
ä e:°()==∞í e:°(≈)Ü
ë e
Ü
t.û(e,)
ë e
Ü)
£.•['https']=(â(...)
å e={∑="uri.https"}
å a=òü
å t=ò"uri.http"
a.¢(e,t)
â e.¨()ë 443 Ü
ë e
Ü)
£.•['pop']=(â(...)
å e={∑="uri.pop"}
å t=ò”
å a=òü
a.¢(e,t)
å i="^A-Za-z0-9%-._~%%!$&'()*+,=:"
â e.¨()ë 110 Ü
å â n(s,n,t)
ä t í
å n,n,o,e=t:ó("^(.*);[Aa][Uu][Tt][Hh]=(.*)$")
ä é o í o=t Ü
ä o==∞í ë·Ü
o=a.©(o,i)
ä e í
ä e==∞í ë„Ü
ä e=="*"í e=ç Ü
e=a.©(e,i)
Ü
t=o..(e Å";auth="..e è∞)
Ü
ä t~=n í e.ö.†(s,t)Ü
ë ç
Ü
â e.º(t)
ä e.ö.°(t)~=∞í
ë ç,"pop URIs must have an empty path"
Ü
å e=e.ö.†(t)
å e=n(t,e,e)
ä e í ë ç,e Ü
ë t
Ü
â e.†(a,...)
å t=e.ö.†(a)
ä ™('#',...)>0 í
å e=...
å e=n(a,t,e)
ä e í ù(e)Ü
Ü
ë t
Ü
â e.°(t,e)
ä e Å e~=∞í ù("POP URIs must have an empty path")Ü
ë∞
Ü
å â n(t)
å t=e.ö.†(t)
ä é t í ë ç,ç Ü
å o,o,e,a=t:ó("^(.*);auth=(.*)$")
ä é e í e=t Ü
ë e,a
Ü
â e.pop_user(s,...)
å n,o=n(s)
ä ™('#',...)>0 í
å t=...
ä t==∞í ù(·)Ü
ä é t Å o í
ù("pop user name required when an auth type is specified")
Ü
ä t í
t=a.©(t,i)
ä o í t=t..";auth="..o Ü
Ü
e.ö.†(s,t)
Ü
ë a.∂(n)
Ü
â e.pop_auth(s,...)
å o,n=n(s)
ä ™('#',...)>0 í
å t=...
ä é t è t==∞
í ù(„)
Ü
ä t=="*"í t=ç Ü
ä t Å é o í
ù("pop auth type can't be specified without user name")
Ü
ä t í
t=o..";auth="..
a.©(t,i)
Ñ
t=o
Ü
e.ö.†(s,t)
Ü
ë n Å a.∂(n)è"*"
Ü
ë e
Ü)
£.•['rtsp']=(â(...)
å e={∑="uri.rtsp"}
å t=òü
å a=ò"uri.http"
t.¢(e,a)
â e.¨()ë 554 Ü
ë e
Ü)
£.•['rtspu']=(â(...)
å e={∑="uri.rtspu"}
å a=òü
å t=ò"uri.rtsp"
a.¢(e,t)
ë e
Ü)
£.•['telnet']=(â(...)
å e={∑="uri.telnet"}
å t=òü
å a=ò"uri._login"
t.¢(e,a)
â e.¨()ë 23 Ü
â e.º(t)
t,err=e.ö.init_base(t)
ä é t í ë ç,err Ü
å e=e.ö.°(t)
ä e~=∞Å e~=≈í
ë ç,"superfluous information in path of telnet URI"
Ü
ä e==∞í t:°(≈)Ü
ë t
Ü
â e.°(t,e)
ä e Å e~=∞Å e~=≈í
ù("invalid path for telnet URI")
Ü
ë≈
Ü
ë e
Ü)
£.•['isbn']=(â(...)
å e={∑="uri.urn.isbn"}
å t=òü
å a=ò˘
t.¢(e,a)
å â o(e)
ä é e:ó("^[-%d]+[%dXx]$")í ë ç,"invalid character"Ü
å t=t.Æ("isbn")
ä t í ë t:“(e)Ü
ë e
Ü
å â a(e)
e=e:≤("%-",∞):upper()
å t=t.Æ("isbn")
ä t í ë ∆(t:“(e))Ü
ë e
Ü
â e.º(e)
å t=e: ()
å o,i=o(t)
ä é o í ë ç,"invalid ISBN value ("..i..ÂÜ
e: (a(t))
ë e
Ü
â e. (i,t)
å s=e.ö. (i)
ä t í
å n,o=o(t)
ä é n í
ù("bad ISBN value '"..t.."' ("..o..Â)
Ü
e.ö. (i,a(t))
Ü
ë s
Ü
â e.isbn_digits(t,e)
å i=t: ():≤("%-",∞)
ä e í
å i,o=o(e)
ä é i í
ù("bad ISBN value '"..e.."' ("..o..Â)
Ü
t.ö. (t,a(e))
Ü
ë i
Ü
â e.isbn(t,e)
å a=ò"isbn"
å a=a:“(t: ())
ä e í t: (∆(e))Ü
ë a
Ü
ë e
Ü)
£.•['issn']=(â(...)
å t={∑="uri.urn.issn"}
å a=òü
å e=ò˘
a.¢(t,e)
å â a(e)
å o,o,a,t,e
=e:ó("^(%d%d%d%d)-?(%d%d%d)([%dxX])$")
ä e=="x"í e="X"Ü
ë a,t,e
Ü
å â o(e)
å e,t,o=a(e)
ä é e í ë ç,"invalid ISSN syntax"Ü
å a=e..t
å e=0
à t=1,7 É
e=e+ø(a:∫(t,t))*(9-t)
Ü
e=(11-e%11)%11
e=(e==10)Å"X"
è ∆(e)
ä o~=e í
ë ç,"wrong checksum, expected "..e
Ü
ë ì
Ü
å â i(e)
å a,t,e=a(e)
ë a.."-"..t..e
Ü
â t.º(e)
å a=e: ()
å o,n=o(a)
ä é o í ë ç,"bad NSS value for ISSN URI ("..n..ÂÜ
t.ö. (e,i(a))
ë e
Ü
â t. (a,e)
å n=t.ö. (a)
ä e í
å n,o=o(e)
ä é n í
ù("bad ISSN value '"..e.."' ("..o..Â)
Ü
t.ö. (a,i(e))
Ü
ë n
Ü
â t.issn_digits(e,t)
å e=e: (t)
ë e:∫(1,4)..e:∫(6,9)
Ü
ë t
Ü)
£.•['oid']=(â(...)
å a={∑="uri.urn.oid"}
å t=òü
å e=ò˘
t.¢(a,e)
å â o(e)
ä e==∞í ë ç,"OID can't be zero-length"Ü
ä é e:ó("^[.0-9]*$")í ë ç,"bad character in OID"Ü
ä e:ó("%.%.")í ë ç,"missing number in OID"Ü
ä e:ó("^0[^.]")è e:ó("%.0[^.]")í
ë ç,"OID numbers shouldn't have leading zeros"
Ü
ë ì
Ü
â a.º(e)
å t=e: ()
å t,a=o(t)
ä é t í ë ç,"bad NSS value for OID URI ("..a..ÂÜ
ë e
Ü
â a. (t,e)
å n=a.ö. (t)
ä e í
å i,o=o(e)
ä é i í
ù("bad OID value '"..e.."' ("..o..Â)
Ü
a.ö. (t,e)
Ü
ë n
Ü
â a.oid_numbers(o,e)
å a=t.split("%.",o: ())
à e=1,#a É a[e]=ø(a[e])Ü
ä e í
ä ÷(e)~="table"í ù("expected array of numbers")Ü
å t=∞
à a,e ã ipairs(e)É
ä ÷(e)==¡Å e:ó("^%d+$")í e=ø(e)Ü
ä ÷(e)~="number"í ù("bad type for number in OID")Ü
e=e-e%1
ä e<0 í ù("negative numbers not allowed in OID")Ü
ä t~=∞í t=t.."."Ü
t=t..e
Ü
ä t==∞í ù("no numbers in new OID value")Ü
o: (t)
Ü
ë a
Ü
ë a
Ü)
£.•['urn']=(â(...)
å e={∑=˘}
å a=òü
å t=ò”
a.¢(e,t)
å â i(e)
ä e==∞í ë ç,"missing completely"Ü
ä e:‡()>32 í ë ç,"too long"Ü
ä é e:ó("^[A-Za-z0-9][-A-Za-z0-9]*$")í
ë ç,Û
Ü
ä e:Ÿ()=="urn"í ë ç,"'urn' is reserved"Ü
ë ì
Ü
å â h(e)
ä e==∞í ë ç,"can't be empty"Ü
ä e:ó("[^A-Za-z0-9()+,%-.:=@;$_!*'/%%]")í
ë ç,Û
Ü
ë ì
Ü
å â s(e)
å t,t,e,o=e:ó("^([^:]+):(.*)$")
ä é e í ë ç,"illegal path syntax for URN"Ü
å t,a=i(e)
ä é t í
ë ç,ª..a..Â
Ü
t,a=h(o)
ä é t í
ë ç,›..a..Â
Ü
ë e:Ÿ()..‰..o
Ü
â e.º(t)
ä e.ö.ˆ(t)í
ë ç,"URNs may not have query parts"
Ü
ä e.ö.Ω(t)í
ë ç,"URNs may not have authority parts"
Ü
å o,i=s(t:°())
ä é o í ë ç,i Ü
e.ö.°(t,o)
å a
=a.Æ("uri.urn."..t:nid():≤("%-","_"))
ä a í
§(t,a)
ä t.º~=e.º í ë t:º()Ü
Ü
ë t
Ü
â e.nid(o,t)
å s,s,n=o:°():ó("^([^:]+)")
ä t í
t=t:Ÿ()
ä t~=n í
å t,e=i(t)
ä é t í
ù(ª..e..Â)
Ü
Ü
a.∏(o,e,"NID",t,â(t,a)
e.ö.°(t,a..‰..t: ())
Ü)
Ü
ë n
Ü
â e. (a,t)
å i,i,o=a:°():ó(":(.*)")
ä t Å t~=o í
å i,o=h(t)
ä é i í
ù(›..o..Â)
Ü
e.ö.°(a,a:nid()..‰..t)
Ü
ë o
Ü
â e.°(t,o)
å h=e.ö.°(t)
ä o Å o~=h í
å n,s=s(o)
ä é n í
ù("invalid path for URN '"..o.."' ("..s..Â)
Ü
å h,h,o,s=n:ó("^([^:]+):(.*)")
ä é o í ù("bad path for URN, no NID part found")Ü
å h,i=i(o)
ä é h í ù(ª..i..Â)Ü
ä o:Ÿ()==t:nid()í
t: (s)
Ñ
a.∏(t,e,"path",n,
â(a,t)e.ö.°(a,t)Ü)
Ü
Ü
ë h
Ü
a.û(e,)
a.û(e,"host")
a.û(e,"port")
a.û(e,"query")
ë e
Ü)
£.•['uri']=(â(...)
å e={∑=”,VERSION="1.0"}
e.Õ=e
£.°=£.°..";./lib/uri/uri/?.lua"
å o=ò("_util")
å n="A-Za-z0-9%-._~"
å t=":/?#%[%]@"
å i="!$&'()*+,;="
å t=t..i
å w="^["..n.."%%"..i..":]*$"
å d="^["..n.."%%"..i.."]*$"
å l="^v[0-9A-Fa-f]+%."..
"["..n..i.."]+$"
å f="^["..n.."%%"..i..":@/?]*$"
å h="^["..n.."%%"..i..":@/]*$"
å â c(e)
ä e:ó("%%$")è e:ó("%%.$")í
ù("unfinished percent encoding at end of URI '"..e..¯)
Ü
ë e:≤("%%(..)",â(t)
ä é t:ó("^[0-9A-Fa-f][0-9A-Fa-f]$")í
ù("invalid percent encoding '%"..t..
"' in URI '"..e..¯)
Ü
å e=ô.char(ø("0x"..t))
ë e:ó("^["..n.."]")Å e è"%"..t:upper()
Ü)
Ü
å â s(e)
ä é e:ó("^[0-9]+%.[0-9]+%.[0-9]+%.[0-9]+$")í ë á Ü
à e ã e:gmatch("[0-9]+")É
ä e:‡()>3 è e:ó("^0.")è
ø(e)>255 í
ë á
Ü
Ü
ë ì
Ü
å â r(t)
å o=á
å a=0
ï t~=∞É
a=a+1
å i,n=t:ó("::?")
å e
ä i í
e=t:∫(1,i-1)
t=t:∫(n+1)
ä n~=i í
ä o í ë á Ü
o=ì
ä e==∞í a=a-1 Ü
Ñ
ä e==∞í ë á Ü
ä t==∞í ë á Ü
Ü
Ñ
e=t
t=∞
Ü
ä(é e:ó("^[0-9a-f]+$")è e:‡()>4)Å
(t~=∞è é s(e))Å
e~=∞í
ë á
Ü
ä e:‡()>4 í a=a+1 Ü
Ü
ä o í
ä a>7 í ë á Ü
Ñ
ä a~=8 í ë á Ü
Ü
ë ì
Ü
å â m(e)
ä e:ó("^%[.*%]$")í
å e=e:∫(2,-2)
ä e:ó("^v")í
ä é e:ó(l)í
ë"invalid IPvFuture literal '"..e..¯
Ü
Ñ
ä é r(e)í
ë"invalid IPv6 address '"..e..¯
Ü
Ü
Ö é s(e)Å é e:ó(d)í
ë"invalid host value '"..e..¯
Ü
ë ç
Ü
å â y(e,t)
ä é e:ó(h)í ë á Ü
ä é t í ë e Ü
ë o.µ(e)
Ü
â e.“(u,a,t)
ä é a í ù("usage: URI:new(uristring, [baseuri])")Ü
ä ÷(a)~=¡í a=∆(a)Ü
ä t í
å a,o=e.“(u,a)
ä é a í ë ç,o Ü
ä ÷(t)~="table"í
t,o=e.“(u,t)
ä é t í ë ç,"error parsing base URI: "..o Ü
Ü
ä t:is_relative()í ë ç,"base URI must be absolute"Ü
å e,t=pcall(a.resolve,a,t)
ä é e í ë ç,t Ü
ë a
Ü
å t=c(a)
å i,e
å o,a,h,l,s,n,d,r
i,e,o=t:ó("^([a-zA-Z][-+.a-zA-Z0-9]*):")
ä o í
o=o:Ÿ()
t=t:∫(e+1)
Ü
i,e,a=t:ó("^//([^/?#]*)")
ä a í
t=t:∫(e+1)
i,e,h=a:ó("^([^@]*)@")
ä h í
ä é h:ó(w)í
ë ç,˜..h..¯
Ü
a=a:∫(e+1)
Ü
e,i,s=a:ó(":([0-9]*)$")
ä s í
s=(s~=∞)Å ø(s)è ç
a=a:∫(1,e-1)
Ü
l=a:Ÿ()
å e=m(l)
ä e í ë ç,e Ü
Ü
i,e,n=t:ó("^([^?#]*)")
ä n~=∞í
å a=y(n,o)
ä é a í ë ç,"invalid path '"..n..¯Ü
n=a
t=t:∫(e+1)
Ü
i,e,d=t:ó("^%?([^#]*)")
ä d í
t=t:∫(e+1)
ä é d:ó(f)í
ë ç,"invalid query value '?"..d..¯
Ü
Ü
i,e,r=t:ó("^#(.*)")
ä r í
ä é r:ó(f)í
ë ç,"invalid fragment value '#"..r..¯
Ü
Ü
å e={
◊=o,
«=h,
—=l,
–=s,
Ë=n,
˛=d,
_fragment=r,
}
§(e,o Å u è(òÓ))
ë e:º()
Ü
â e.uri(a,...)
å t=a.È
ä é t í
å e=a:€()
ä e í
t=e..‰
Ñ
t=∞
Ü
å o,i,e=a:Ω(),a.–,a:†()
ä o è i è e í
t=t.."//"
ä e í t=t..e.."@"Ü
ä o í t=t..o Ü
ä i í t=t..‰..i Ü
Ü
å e=a:°()
ä t==∞Å e:ó("^[^/]*:")í
e="./"..e
Ü
t=t..e
ä a:ˆ()í t=t.."?"..a:ˆ()Ü
ä a:fragment()í t=t..˚..a:fragment()Ü
a.È=t
Ü
ä ™(˚,...)>0 í
å t=...
ä é t í ù("URI can't be set to nil")Ü
å e,t=e:“(t)
ä é e í
ù("new URI string is invalid ("..t..Â)
Ü
§(a,À(e))
à e ã ÿ(a)É a[e]=ç Ü
à e,t ã ÿ(e)É a[e]=t Ü
Ü
ë t
Ü
â e.__tostring(e)ë e:uri()Ü
â e.eq(t,a)
ä ÷(t)==¡í t=‚(e:“(t))Ü
ä ÷(a)==¡í a=‚(e:“(a))Ü
ë t:uri()==a:uri()
Ü
â e.€(a,...)
å i=a.◊
ä ™(˚,...)>0 í
å t=...
ä é t í ù("can't remove scheme from absolute URI")Ü
ä ÷(t)~=¡í t=∆(t)Ü
ä é t:ó("^[a-zA-Z][-+.a-zA-Z0-9]*$")í
ù("invalid scheme '"..t..¯)
Ü
o.∏(a,e,"scheme",t,
â(t,e)t.◊=e Ü)
Ü
ë i
Ü
â e.†(t,...)
å a=t.«
ä ™(˚,...)>0 í
å e=...
ä e í
ä é e:ó(w)í
ù(˜..e..¯)
Ü
e=c(e)
Ü
t.«=e
ä e Å é t.— í t.—=∞Ü
t.È=ç
Ü
ë a
Ü
â e.Ω(e,...)
å a=e.—
ä ™(˚,...)>0 í
å t=...
ä t í
t=∆(t):Ÿ()
å e=m(t)
ä e í ù(e)Ü
Ñ
ä e.« è e.– í
ù("there must be a host if there is a userinfo or port,"..
" although it can be the empty string")
Ü
Ü
e.—=t
e.È=ç
Ü
ë a
Ü
â e.ı(t,...)
å a=t.– è t:¨()
ä ™(˚,...)>0 í
å e=...
ä e í
ä ÷(e)==¡í e=ø(e)Ü
ä e<0 í ù("port number must not be negative")Ü
å a=e-e%1
ä a~=e í ù("port number not integer")Ü
ä e==t:¨()í e=ç Ü
Ü
t.–=e
ä e Å é t.— í t.—=∞Ü
t.È=ç
Ü
ë a
Ü
â e.°(t,...)
å a=t.Ë
ä ™(˚,...)>0 í
å e=...è∞
e=c(e)
e=o.©(e,"^A-Za-z0-9%-._~%%!$&'()*+,;=:@/")
ä t.— í
ä e~=∞Å é e:ó("^/")í
ù("path must begin with '/' when there is an authority")
Ü
Ñ
ä e:ó("^//")í e="/%2F"..e:∫(3)Ü
Ü
t.Ë=e
t.È=ç
Ü
ë a
Ü
â e.ˆ(t,...)
å a=t.˛
ä ™(˚,...)>0 í
å e=...
ä e í
e=o.©(e,"^"..n.."%%"..i..":@/?")
Ü
t.˛=e
t.È=ç
Ü
ë a
Ü
â e.fragment(t,...)
å a=t._fragment
ä ™(˚,...)>0 í
å e=...
ä e í
e=o.©(e,"^"..n.."%%"..i..":@/?")
Ü
t._fragment=e
t.È=ç
Ü
ë a
Ü
â e.º(t)
å a
=o.Æ("uri."..t.◊:≤("[-+.]","_"))
ä a í
§(t,a)
ä t.– Å t.–==t:¨()í
t.–=ç
Ü
ä a~=e Å t.º~=e.º í
ë t:º()
Ü
Ü
ë t
Ü
â e.¨()ë ç Ü
â e.is_relative()ë á Ü
â e.resolve()Ü
â e.relativize(t,a)
ä ÷(a)==¡í a=‚(e:“(a))Ü
ä t.◊~=a.◊ è t.—~=a.— è
t.–~=a.– è t.«~=a.« í
ë
Ü
å i=a.Ë
å n=t.Ë
ä é i:ó("^/")è é n:ó("^/")í ë Ü
t.È=ç
t.◊=ç
t.—=ç
t.–=ç
t.«=ç
§(t,òÓ)
ä n==i í
ä t.˛ è é a.˛ í
t.Ë=∞
Ñ
å a,a,e=n:ó("/([^/]+)$")
ä e Å e:ó(‰)í e="./"..e Ü
t.Ë=e è"."
Ü
ë
Ü
ä n==≈è i==≈í ë Ü
å i=o.split(≈,i:∫(2))
å e=o.split(≈,n:∫(2))
ä e[1]~=i[1]í ë Ü
Ã.Ô(i)
ï#e>1 Å#i>0 Å e[1]==i[1]É
Ã.Ô(e,1)
Ã.Ô(i,1)
Ü
å o=ì
å a=∞
ï#i>0 É
Ã.Ô(i,1)
a=a.."../"
o=á
Ü
ä o Å#e==1 Å e[1]==∞í
a="./"
Ã.Ô(e)
Ü
ï#e>0 É
ä o í
ä e[1]:ó(‰)í
a=a.."./"
Ö#e>1 Å e[1]==∞Å e[2]==∞í
a=a.."/."
Ü
Ü
a=a..e[1]
o=á
Ã.Ô(e,1)
ä#e>0 í a=a..≈Ü
Ü
t.Ë=a
Ü
ë e
Ü)
£.•['ProxyProperties']=(â(...)
æ={}
æ.Õ=æ
â æ:makeProxy(e,t,a,o,i)
§(t,e)
å e=i Å t è e
å n=a Å
â(i,o)
å t=a[o]
ä t í ë t(i)Ñ ë e[o]Ü
Ü
è e
å e=o Å
â(a,t,i)
å e=o[t]
ä e í e(a,i)
Ñ rawset(a,t,i)Ü
Ü
è e
å e={
__newindex=e,
Õ=n,
priv=t
}
å e=§({},e)
ë e
Ü Ü)
£.•['Strings']=(â(...)
ñ={}
ñ.Õ=ñ
å e={}
à t=0,255 É
e[t+1]=ô.char(t)
Ü
å t=Ã.concat(e)
å e={['.']=e}
å t=â(o)
å i=ô.≤(t,'[^'..o..']','')
å t={}
à a=1,ô.‡(i)É
t[a]=ô.∫(i,a,a)
Ü
e[o]=t
ë t
Ü
â ñ:trim(e)
ë(ô.≤(e,"^%s*(.-)%s*$","%1"))
Ü
â ñ:randomNumber(e,t)
ë math.random(e,t)
Ü
â ñ:randomString(i)
å a="abcdefghijklmnopqrstuvwxyz"
å o={}
å e=e[a]è t(a)
å a=Ã.getn(e)
à t=1,i É
o[t]=e[math.random(1,a)]
Ü
ë Ã.concat(o)
Ü
â ñ:generateId(i)
å a="abcdefghijklmnopqrstuvwxyz0123456789"
å o={}
å e=e[a]è t(a)
å t=Ã.getn(e)
à a=1,i É
o[a]=e[math.random(1,t)]
Ü
ë Ã.concat(o)
Ü
â ñ:õ(t)
å e=á
ä t==ç è t==∞í
e=ì
Ü
ë e
Ü
â ñ:…(e)
¸=0
ä e~=ç í
à e,e ã ÿ(e)É
¸=¸+1
Ü
Ü
ë ¸
Ü
â ñ:Ï(e)
ë ô.match(e,"^%s*http[s]?://%w?+?:?%w?*?@?(%S+):?[0-9]?+?/?[%w#!:.?+=&%@!\-/]?%s*$")Å ì è á
Ü
â ñ:´(e)
ë(e==ç è ô.match(e,"^[%w-:/.]*$"))Å ì è á
Ü
Ü)
£.•['WebSocketConnection']=(â(...)
¶={}
¶.Õ=¶
å d=ò"socket"
å e
å â l(t,o)
å a=á
e:Ù("GET "..o.." HTTP/1.1\r\n"
.."User-Agent: Lua Web Socket Protocol Handshake\r\n"
.."Upgrade: WebSocket\r\n"
.."Connection: Upgrade\r\n"
.."Host: "..t.."\r\n"
.."Origin: http://"..t.."\r\n\r\n")
å t=e:⁄();
å i=e:⁄();
å o=e:⁄();
e:⁄()
e:⁄()
e:⁄()
Ø={"HTTP/1.1 101 Web Socket Protocol Handshake","HTTP/1.1 101 WebSocket Protocol Handshake","Upgrade: WebSocket","Connection: Upgrade"}
ä(t==Ø[1]è t==Ø[2])Å i==Ø[3]Å o==Ø[4]í
a=ì
Ü
ë a
Ü
â ¶:“(e)
e=e è{}
§(e,ú)
ú.Õ=ú
ë e
Ü
â receiveBlock(h,i)
e:settimeout(0)
ï ì É
å e,r,t=e:⁄()
ä t Å t~=∞í
å s={}
å o=∞
å e=1
å n=1
å a=t:byte(e)
ï e<=ô.‡(t)É
ï a~=255 É
ä a==0 í
o=∞
Ñ
o=o..ô.char(t:byte(e))
Ü
e=e+1
a=t:byte(e)
Ü
s[n]=o
n=n+1
e=e+1
a=t:byte(e)
Ü
ä i~=ç í
i(h,s)
Ü
Ü
ä r=="closed"í
i(h,{"disconnected;"})
Ç
Ü
Ü
Ü
â ¶:connect(t,a,i,o,n)
ä o==ç í
o=80
Ü
e=d.connect(i,o)
ä e~=ç í
å e=á
ä l(i,n)í
e=ì
Ü
a(t,{"handshake;"..(e Å 1 è 0)})
receiveBlock(t,a)
Ñ
a(t,{"reconnect;"})
Ü
Ü
â ¶:‘()
e:close()
Ü
â ¶:Ù(t)
e:Ù("\000"..t.."\255")
Ü
Ü)
£.°=£.°..";../OrtcClient/src/ibt/ortc/extensibility/?.lua;../OrtcClient/src/ibt/ortc/websocket/?.lua"
ò("ProxyProperties")
ò("Strings")
ò("WebSocketConnection")
ò("lfs")
å u=ç
u=ò(”)
®={}
®.Õ=®
å g=ò"socket.http"
å A="^a%[\"{\\\"op\\\":\\\"(.-[^\\\"]+)\\\",(.*)}\"%]$"
å T="^c%[(.*[^\"]+),\"(.*)\"%]$"
å E="^\\\"up\\\":(.*),\\\"set\\\":(.*)$"
å v="^\\\"ch\\\":\\\"(.*)\\\"$"
å I="^\\\"ex\\\":{\\\"op\\\":\\\"(.*[^\"]+)\\\",\\\"ex\\\":\\\"(.*)\\\"}$"
å O="^\\\"ex\\\":{\\\"op\\\":\\\"(.*[^\"]+)\\\",\\\"ch\\\":\\\"(.*)\\\",\\\"ex\\\":\\\"(.*)\\\"}$"
å N="^a%[\"{\\\"ch\\\":\\\"(.*)\\\",\\\"m\\\":\\\"([%s%S]*)\\\"}\"%]$"
å H="^(.[^_]*)_(.[^-]*)-(.[^_]*)_([%s%S]*)$"
å R="\\\"(.[^\\\"]+)\\\":\\\"(.[^,\\\"]+)\\\",?"
å s="var SOCKET_SERVER = \"(.*)\";"
å D=800
å d=100
å b=256
å e="ortcsession-"
å i=ç
å r=ç
å t=ç
å n=ç
å o=ç
å h=ç
å l=ç
å c=ç
å m=ç
å p=ç
å S={
url=â(e,t)
r=á
å e=À(e).priv
e.url=ñ:trim(t)
Ü,
¬=â(e,t)
r=ì
å e=À(e).priv
e.¬=ñ:trim(t)
Ü
}
å â j(e)
ä e Å e.ˇ í
e.ˇ(e)
Ü
Ü
å â q(e)
ä e Å e.Ì í
e.Ì(e)
Ü
Ü
å â k(e,t)
ä e Å e.˙ Å t í
e.˙(e,t)
Ü
Ü
å â z(e,t)
ä e Å e.Î Å t í
e.Î(e,t)
Ü
Ü
å â e(a,e,o)
ä a Å t[e]Å t[e].± Å t[e].» í
t[e].»(a,e,o)
Ü
Ü
å â e(e,t)
ä e Å e.onException í
e.onException(e,t)
Ü
Ü
å â a(e)
ä e Å e.onReconnecting í
e.onReconnecting(e)
Ü
Ü
å â x(e)
ä e Å e.onReconnected í
e.onReconnected(e)
Ü
Ü
å â y(e)
å t=g.request(e)
å e=ç
ä t~=ç í
_,_,e=ô.ó(t,s)
Ü
ë e
Ü
å â w(e)
e.ß=á
ä é m í
l=ì
a(e)
e:doConnect()
Ü
Ü
å â f()
h=á
m=ì
Ü
å â _(a,s)
ä ÷(s)=="table"í
à r=1,Ã.getn(s)É
å s=s[r]
ä s~="o"Å s~="h"í
s=ô.≤(s,"\\\\\\\\","\\")
å u,u,r,d=ô.ó(s,"^(.*[^;]+);(.*)$")
ä r~=ç í
ä r=="handshake"í
ä d=="1"í
å o,t=pcall(â()
ä unexpected_condition í
ù()
Ü
a.sessionId=ñ:generateId(16)
i:Ù("\"validate;"..a.Ò..Í..a.ﬂ..Í..(a.œ è∞)..Í..(a.sessionId è∞)..Í..(a.ƒ è∞).."\"")
Ü)
ä t~=ç í
e(a,t)
f()
i:‘()
Ü
Ñ
e(a,"Unable to perform handshake")
Ü
Ö r=="disconnected"í
o={}
h=á
l=á
ä c í
q(a)
ä a.ß í
w(a)
Ü
Ü
a.ß=á
Ö r=="reconnect"í
h=á
e(a,"Unable to connect")
socket.sleep(a.ﬁ/1e3)
w(a)
Ü
Ñ
å u,u,d,r=ô.ó(s,A)
ä d~=ç í
ä d=="ortc-validated"í
å r,r,e,s=ô.ó(r,E)
å r,r
ä s~=ç í
p=s
Ü
ä e~=ç í
à t,e ã ô.gmatch(e,R)É
o[t]=e
Ü
a.ß=ì
h=á
c=ì
à e,t ã ÿ(t)É
ä t.˝ Å(t.¥ è t.±)í
t.¥=ì
t.±=á
å t=ô.ó(e,‰)
å n=e
ä t~=ç Å t>0 í
n=ô.∫(e,1,t).."*"
Ü
å t=(o[e]~=ç Å o[e]è o[n]~=ç Å o[n]è∞)
i:Ù("\"subscribe;"..a.Ò..Í..a.ﬂ..Í..e..Í..t.."\"")
Ü
Ü
n={}
ä l í
l=á
x(a)
Ñ
j(a)
Ü
Ü
Ö d=="ortc-subscribed"í
å o,o,e=ô.ó(r,v)
ä t[e]~=ç í
t[e].¥=á
t[e].±=ì
Ü
k(a,e)
Ö d=="ortc-unsubscribed"í
å t,t,e=ô.ó(r,v)
z(a,e)
Ö d=="ortc-error"í
å h,s,o,i,n=ô.ó(r,O)
ä o==ç í
s,s,o,n=ô.ó(r,I)
Ü
e(a,n)
ä o=="validate"í
c=á
f()
Ö o=="subscribe"í
ä é ñ:õ(i)í
ä t[i]í
t[i].¥=á
Ü
Ü
Ö o=="subscribe_maxsize"è o=="unsubscribe_maxsize"è o=="send_maxsize"í
ä é ñ:õ(i)í
ä t[i]í
t[i].¥=á
Ü
Ü
f()
a:‘()
Ü
Ü
Ñ
å i,i,e,o=ô.ó(s,T)
ä e==ç Å o==ç í
å e,e,s,o=ô.ó(s,N)
ä t[s]í
o=ô.≤(ô.≤(o,"\\\\n","\n"),"\\\\\\\"","\"")
å h,h,e,r,i,d=ô.ó(o,H)
å h=á;
ä é ñ:õ(e)Å é ñ:õ(r)Å é ñ:õ(i)í
ä é n[e]í
n[e]={}
Ü
n[e][ø(r)]=d
ä ∆(ñ:…(n[e]))==i í
h=ì
Ü
Ñ
h=ì
Ü
ä h í
ä é ñ:õ(e)Å é ñ:õ(i)í
o=∞;
à t=1,i É
o=o..n[e][t]
n[e][t]=ç
Ü
n[e]=ç
Ü
t[s].»(a,s,o)
Ü
Ü
Ü
Ü
Ü
Ü
Ü
Ü
Ü
â ®:“()
å e={id,url,¬,ﬁ,ß,ƒ,œ,sessionId,ˇ,Ì,˙,Î,onException}
å e=æ:makeProxy(®,e,ç,S,ì)
math.randomseed(os.time())
math.random()
e.ﬁ=5e3
e.ß=á
p=30
h=á
l=á
r=á
c=á
m=á
t={}
n={}
o={}
ë e
Ü
â ®:doConnect()
h=ì
ä r í
å t=y(ú.¬)
ä t~=ç í
ú.url=t
Ñ
e(ú,Ê)
Ü
Ü
ä ú.url~=ç í
å e=u:“(ú.url)
å t=ñ:randomNumber(1,1e3)
å o=ñ:randomString(8)
å a=(e:€()=="https")Å"wss"è"ws"
connectionUrl=a.."://"..e:Ω()..(e:ı()Å‰..e:ı()è∞).."/broadcast/"..t..≈..o.."/websocket"
å e=u:“(connectionUrl)
å t=e:Ω()
å a=e:ı()
å e=e:°()
i=¶:“{}
i:connect(ú,_,t,a,e)
Ü
Ü
â ®:connect(t,a)
ä ú.ß í
e(ú,"Already connected")
Ö ñ:õ(ú.¬)Å ñ:õ(ú.url)í
e(ú,"URL and Cluster URL are null or empty")
Ö ñ:õ(t)í
e(ú,"Application Key is null or empty")
Ö ñ:õ(a)í
e(ú,"Authentication ToKen is null or empty")
Ö é r Å é ñ:Ï(ú.url)í
e(ú,"Invalid URL")
Ö r Å é ñ:Ï(ú.¬)í
e(ú,"Invalid Cluster URL")
Ö é ñ:´(t)í
e(ú,"Application Key has invalid characters")
Ö é ñ:´(a)í
e(ú,"Authentication Token has invalid characters")
Ö é ñ:´(ú.œ)í
e(ú,"Announcement Subchannel has invalid characters")
Ö é ñ:õ(ú.ƒ)Å ô.‡(ú.ƒ)>b í
e(ú,"Connection metadata size exceeds the limit of "..b..‹)
Ö h è l í
e(ú,"Already trying to connect")
Ñ
ä pcall(â()
ä unexpected_condition í
ù()
Ü
ä r í
u:“(ú.¬)
Ñ
u:“(ú.url)
Ü
Ü)í
m=á
ú.Ò=t
ú.ﬂ=a
ú:doConnect()
Ñ
e(ú,"Invalid URL")
Ü
Ü
Ü
â ®:subscribe(a,h,r)
ä é ú.ß í
e(ú,¿)
Ö ñ:õ(a)í
e(ú,≥)
Ö é ñ:´(a)í
e(ú,≠)
Ö t[a]Å t[a].¥ í
e(ú,"Already subscribing to the channel "..a)
Ö t[a]Å t[a].± í
e(ú,"Already subscribed to the channel "..a)
Ö ô.‡(a)>d í
e(ú,π..d..‹)
Ñ
å s=ô.ó(a,‰)
å n=a
ä s~=ç Å s>0 í
n=ô.∫(a,1,s).."*"
Ü
å n=(o[a]~=ç Å o[a]è o[n]~=ç Å o[n]è∞)
ä ñ:…(o)>0 Å ñ:õ(n)í
e(ú,"No permission found to subscribe to the channel '"..a..¯)
Ñ
ä é t[a]í
t[a]={}
Ü
t[a].¥=ì
t[a].±=á
t[a].˝=h
t[a].»=r
i:Ù("\"subscribe;"..ú.Ò..Í..ú.ﬂ..Í..a..Í..n.."\"")
Ü
Ü
Ü
â ®:unsubscribe(a)
ä é ú.ß í
e(ú,¿)
Ö ñ:õ(a)í
e(ú,≥)
Ö é ñ:´(a)í
e(ú,≠)
Ö é t[a]í
e(ú,"Not subscribed to the channel "..a)
Ö ô.‡(a)>d í
e(ú,π..d..‹)
Ñ
i:Ù("\"unsubscribe;"..ú.Ò..Í..a.."\"")
Ü
Ü
â ®:Ù(t,a)
ä é ú.ß í
e(ú,¿)
Ö ñ:õ(t)í
e(ú,≥)
Ö é ñ:´(t)í
e(ú,≠)
Ö ñ:õ(a)í
e(ú,"Message is null or empty")
Ö ô.‡(t)>d í
e(ú,π..d..‹)
Ñ
å n=ô.ó(t,‰)
å s=t
ä n~=ç Å n>0 í
s=ô.∫(t,1,n).."*"
Ü
å h=(o[t]~=ç Å o[t]è o[s]~=ç Å o[s]è∞)
ä ñ:…(o)>0 Å ñ:õ(h)í
e(ú,"No permission found to send to the channel '"..t..¯)
Ñ
a=ô.≤(ô.≤(a,"\\","\\\\"),"\\\\n","\\n")
å o={}
å r=ñ:generateId(8)
å s=D-ô.‡(t);
å e=1
å n=1
ï e<ô.‡(a)É
ä ô.‡(a)<=s í
o[n]=a
Ç
Ü
ä ô.∫(a,e,e+s)í
o[n]=ô.∫(a,e,e+s)
Ü
e=e+s
n=n+1
Ü
à e=1,ñ:…(o)É
i:Ù("\"send;"..ú.Ò..Í..ú.ﬂ..Í..t..Í..h..Í..r.."_"..e.."-"..ñ:…(o).."_"..o[e].."\"")
Ü
Ü
Ü
Ü
â ®:‘()
f()
t={}
ä é ú.ß í
e(ú,¿)
Ñ
i:‘()
Ü
Ü
â ®:±(a)
result=ç
ä é ú.ß í
e(ú,¿)
Ö ñ:õ(a)í
e(ú,≥)
Ö é ñ:´(a)í
e(ú,≠)
Ñ
result=t[a]Å t[a].± Å ì è á
Ü
ë result
Ü
â ®:saveAuthentication(o,u,d,l,r,s,h,a,c)
å n=á
å t=ç
å i=ç
ä u í
t=y(o)
ä t==ç í
e(ú,Ê)
Ü
Ñ
t=o
Ü
ä t~=ç í
t=(ô.∫(t,ô.‡(o))==≈Å t è(t..≈)).."authenticate"
å e="AT="..d.."&PVT="..(l Å"1"è"0").."&AK="..r.."&TTL="..s.."&PK="..h.."&TP="..ñ:…(a)
ä a~=ç í
à t,a ã ÿ(a)É
e=e.."&"..t.."="..a
Ü
Ü
å t,e=g.request(t,e)
ä e==200 è e==201 í
n=ì
Ñ
i=t
Ü
c(i,n)
Ü
Ü
]===], '@OrtcClient.lua'))()