#!/usr/bin/env python

"""
cat << EOF > /tmp/plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>org.sewell.silas.hosts</string>
    <key>ProgramArguments</key>
    <array>
        <string>${HOME}/.local/bin/hosts.py</string>
    </array>
    <key>StartInterval</key>
    <integer>60</integer>
</dict>
</plist>
EOF
sudo cp /tmp/plist /Library/LaunchDaemons/org.sewell.silas.hosts.plist
sudo launchctl load -w /Library/LaunchDaemons/org.sewell.silas.hosts.plist
"""
 
import datetime
 
path = '/etc/hosts'
sep = '\n##\n# Custom Rules\n##\n'
 
now = datetime.datetime.now()
 
with open(path) as f:
    hosts = f.read().split(sep, 1)[0]
 
block = [
    '4chan.org',
    'boards.4chan.org',
    'cnn.com',
    'experts-exchange.com',
    'google-analytics.com',
    'news.ycombinator.com',
    'slashdot.org',
    'ssl.google-analytics.com',
    'techcrunch.com',
]

if not (now.hour >= 21 and now.hour < 23):
    block += [
    	'linkedin.com',
        'facebook.com',
        'twitter.com',
        'youtube.com',
    ]
 
block += ['www.%s' % name for name in block if name.count('.') == 1]
 
with open(path, 'w') as f:
    f.write(hosts + sep + '\n'.join(['127.0.0.1\t%s' % n for n in block]) + '\n')
