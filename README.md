# Invador Informant

CLI tool for Mac OS to automate network scans and notify, using ntfy.sh, of any new or dropped connections on your network.  

## Dependencies:

Install Nmap -> https://nmap.org/download#macosx

or using homebrew

```
brew install nmap 
```

## Install Instructions 
1. Install script to the default mac os PATH location `/usr/local/bin`
```
 curl -L https://raw.githubusercontent.com/patricksthannon/InvaderInformant/refs/heads/main/InvaderInformant.sh -o /usr/local/bin/InvaderInformant.sh && chmod +x /usr/local/bin/InvaderInformant.sh
```

2. Edit script to add your ntfy server ip and topic name

`Line 8: topic=your_ntfy_topic_here` 
`Line 9: notifyserver=your_ntfy_server_ip_here`

```
Edit using Vim
vim /usr/local/bin/InvaderInformant.sh

Or Edit using VSCode
code /usr/local/bin/InvaderInformant.sh
```
3. Test script

```
InvaderInformant.sh
```

4. Add on a cron schedule

```
crontab -e 
```
add a cronjob 
(every 5 minutes as the example or use a [Crontab Generator](https://crontab.guru/))
<br><br>
Press <kbd>i</kbd>

```
*/5 * * * * /usr/local/bin/InvaderInformant.sh
```
Save and quit your crontab script schedule <br><br>
Press <kbd>escape</kbd> 
```
:wq
```

## Credits :raised_hands:

This is an modified version of [notify_me_the_intruders](https://github.com/nothingbutlucas/notify_me_the_intruders) by [nothingbutlucas](https://github.com/nothingbutlucas)
