# Bugspots - Bug Prediction Heuristic

An implementation of the simple bug prediction heuristic outlined by the Google Engineering team: [Bug Prediction at Google](http://google-engtools.blogspot.com/2011/12/bug-prediction-at-google.html)

> Well, we actually have a great, authoritative record of where code has been requiring fixes: our bug tracker and our source control commit log! The research indicates that predicting bugs from the source history works very well, so we decided to deploy it at Google.

Point bugspots at any git repo and it will identify the hotspots for you.
##dependency
cmake : apt-get install cmake
## Usage

```bash
$> gem install bugspots
$> bugspots /path/to/repo
$> git bugspots (in root of current git project, --help for options)
```

## Results

```bash
$> cd /your/git/repo
$> git bugspots -d 500

  .. example output ..

	Scanning /git/eventmachine repo
	Found 31 bugfix commits, with 23 hotspots:

	Fixes:
		- Revert "Write maximum of 16KB of data to an SSL connection per tick (fixes #233)" for #273
		- Do not close attached sockets (fixes #200)
		- Write maximum of 16KB of data to an SSL connection per tick (fixes #233)
		- Merge branch 'master' into close_schedule_fix
		- Remove dependency on readbytes.rb for ruby 1.9 (fixes #167, #234)
		- Fix compilation on MSVC2008 (fixes #253)
		- EM::Deferrable#(callback|errback|timeout) now return self so you can chain them (closes #177)
		- Make EventMachine::Connection#get_peername and #get_sockname valid for IPv6 (closes #132)
		- reconnect DNS socket if closed
		- Use String#bytesize in EM::Connection#send_datagram for 1.9 (closes #153)
		- Fix an issue that would cause the EM process to block when the loopbreak pipe filled up (closes #158)
		- namespace std is already included, so just call min(). fixes vc6 issue with min macro
		- Use close() instead of closesocket() to prevent FD leaks on windows.
		- Stop advertising non-available authentication mechanisms, allow multi-line authentication - fixes compatibility with javamail
		- typo fixes and undef fstat for ruby on Windows
		- Deprecate now aged info, as it's fixed
		- Some fixes for Solaris and Nexenta (opensolaris kernel + linux userland)
		- Some fixes for solaris
		- Minor fixes for rbx compatibility
		- Reduce the size of the RunEpollOnce stack frame by 800kb. This fixes the long-standing epoll+threads issue (#84)
		- Fixed aggregated event handling for kqueue and notify, fixed path for ifconfig.
		- More win32 fixes
		- Added test for reactor_thread? and fixed up EM.schedule for pre-reactor schedules
		- Merge branch 'master' of git@github.com:eventmachine/eventmachine
		- Use read instead of recv in ConnectionDescriptor::Read (fixes EM.attach issues with pipes)
		- Use false to indicated a cancelled timer instead of using an empty proc. Reduces mem usage in certain situations.
		- Inotify fixes: file_delete only fires after fds have been closed, use syscall hackery for older linux distributions (*cough* debian)
		- Clean up deferrable.rb: fixed rdoc, alias method wrappers, remove unnecessary forwardable
		- More solaris build fixes.
		- More solaris build issues fixed
		- fixed a small bug with basic auth (cherry-pick conflict merge from mmmurf (closes #92))

	Hotspots:
		0.9723 - ext/ed.cpp
		0.3311 - ext/ed.h
		0.3271 - ext/em.cpp
		0.3034 - lib/eventmachine.rb
		0.2433 - lib/em/protocols/postgres3.rb
		0.2403 - ext/project.h
		0.0431 - lib/em/deferrable.rb
		0.029 - ext/cmain.cpp
		0.0278 - ext/rubymain.cpp
		0.0277 - ext/eventmachine.h
		0.0241 - lib/em/resolver.rb
		0.0241 - tests/test_resolver.rb
		0.0225 - lib/em/connection.rb
		0.0013 - lib/em/protocols/smtpserver.rb
		0.0003 - ext/extconf.rb
		0.0002 - tests/test_basic.rb
		0.0001 - ext/em.h
		0.0001 - ext/cplusplus.cpp
		0.0001 - ext/fastfilereader/extconf.rb
		0.0 - lib/em/filewatcher.rb
		0.0 - tests/test_file_watch.rb
		0.0 - ext/fastfilereader/mapper.cpp
		0.0 - lib/protocols/httpclient.rb
```

### License

(MIT License) - Copyright (c) 2011 Ilya Grigorik
