== Intro ==

After a couple of issues with the Red Pitaya web app, we have tried to set up a UDP server on the Pitaya.

The first trials were done with '''/srcTestServer.c''' -- but we were still quite buggy, especially in terms of memory management, which proved quite tricky for a C n00b like me.

Moreover, I think that the UDP data rate, at least with the Pitaya, are note quite compatible with the data rate in terms of raw images. The time being, I rather focused on delivering an image.

== Structure ==

The setup consists in :
* a server, ie CreateImage16s.c (which sends averages of 16s). 
** I removed the triggerdelay from the RP to avoid loosing to much time waiting for a  second pulse for the PMW -- I'm just taking what I need to know where the motor is.
**Using the SDK, an executable in /tmp/api_test will appear on the RP. It can be safely executed from there.
**Over the 16k samples, it takes the sums of the squares
* It packs at the moment 256 samples, on 4 bytes int, plus 7 int bearing information (motor, date, time elapsed, ...) on each packet.
* UDP  client, in Python.
** It unpacks the data coming through the UDP and processes the packet "header"
** It stores the packets in a .log file, which can be used to replay the capture
*A LogParser, which interprets a log file, repacks the different parts of a same line, sorts the lines according to their positions as encoded on the single int left, an shoots a png that represents the capture

So far, I canceled working on the createref.py tool, to remove the baseline from all the signals
 

== TODO ==
* Sending RawData (sampled at 125MHZ) through UDP.
* Having the Pitaya broadcast its messages, instead of streaming them to the main computer (INANYADDR)
* Having a pitaya emulator replay the log files in a local C UDP server.
* Artificial TCG in the LogParser*
* Forgetting, it's getting late.