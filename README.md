iOS Restrictions Passcode Extractor
===

## Usage

On unix-like systems, run

    restrictions_extractor.rb <RestrictionsPasswordKey> <RestrictionsPasswordSalt>

**Or without checking out the repository, use this one-liner:**

    curl -L https://git.io/voY1p | ruby - <RestrictionsPasswordKey> <RestrictionsPasswordSalt>

_https://git.io/voY1p is a shortlink pointing to the raw script on GitHub_

If you're on windows, you can remove the line

    #!/usr/bin/env ruby

from the top of the file and run

    ruby restrictions_extractor.rb  <RestrictionsPasswordKey> <RestrictionsPasswordSalt>

### Getting the passcode key and salt

Find your [iTunes backup location](https://support.apple.com/en-us/HT204215)

    \Users\<username>\AppData\Roaming\Apple Computer\MobileSync\Backup\
on Windows and

    ~/Library/Application Support/MobileSync/Backup/
on Mac.

In there, if you have multiple backups, you'll find multiple directories corresponding to each backup. Find the latest backup (or whichever one contains a backup that has your restrictions code lock on).

The backup contents are just a bunch of files whose names have been hashed for obscurity. The file you want is named: *398bc9c2aeeab4cb0c12ada0f52eea12cf14f40b* which corresponds to
*HomeDomain-Library/Preferences/com.apple.restrictionspassword.plist*
You can check this out for yourself by running this command:

    echo -n "HomeDomain-Library/Preferences/com.apple.restrictionspassword.plist" | openssl sha1

Alternatively, you can use commercial backup extraction software which makes this process easier but they often limit the number of files you can extract, etc.

If you look at the contents of the file, you'll see something like this:

    <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>RestrictionsPasswordKey</key>
          <data>
            M/p4734c8/SOXZnGgZot+BciAW0=
          </data>
          <key>RestrictionsPasswordSalt</key>
          <data>
            aSbUXg==
          </data>
        </dict>
      </plist>

In this case, I've purposely set my restrictions passcode to **0001**. The two bits you'll need from this are the RestrictionsPasswordKey, *VWJNqmVy5TLmp4oljM2MC6p296Y=* in my case, and the RestrictionsPasswordSalt, *9nIscg==*. If you run the passcode extractor with these two arguments, it begins a brute force attempt to try every passcode between *0000* and *9999* and reports back if it gets the correct answer. The output looks something like this:

    ./restrictions_extractor.rb  M/p4734c8/SOXZnGgZot+BciAW0= aSbUXg==
    okay, let's get crackin
    found the passcode!, it's: 0001

That's it! Why pay $25 or more for commercial software when you can spend a whole afternoon learning something new?? :-)

## Thanks

Many thanks to the two following pages which provided a lot of insight into this. The second one even provides a web form that you can use to do this process without installing software. I decided to write another version because the web version was rather slow.

* https://nbalkota.wordpress.com/2014/04/05/recover-your-forgotten-ios-7-restrictions-pin-code/
* http://1024kb.co.nz/ios-78-passcode-hack/
