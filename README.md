# DDPV
This script allows to easily run `dd` with `pv` pipe, resulting in a nice and accurate progress bar.

I always use `dd` to write images to disks and I'm not satisfied by `status=progress` so I end up using `pv`

Ocasionally I've found myself puzzeled by what is the proper syntax for piping `dd .. | pv ..`

So I finally decided to write a script for that!

## Running:

	$ chmod 750 ./ddpv.sh
	$ ./ddpv.sh /path/to/your/image /dev/sdx

	### Optionally specify block-size:
	$ ./ddpv.sh /path/to/your/image /dev/sdx 16M


## Notes:
* Don't run as root - sudo is used

## TODO:
- Add a check if target is smaller than source
- Maybe generify the script to be able to move also regular files and other unix file-like objects

---

> License: **MIT License**

> Author: **Max Grinberg (@codeswhite)**
