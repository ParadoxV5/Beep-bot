# Beep bot
Beep bot is more than another Discord “censor” bot that can filter out coarse language.
The motivation of writing [this script](main.rb) is that all other censor bots I’ve found out there so far erase triggered messages whole.
This bot still deletes, but **do** echo the the original message with matching portion(s) [`gsub`](https://ruby-doc.org/core/String.html#method-i-gsub-21)bed.

Despite adding [real replies](https://support.discord.com/hc/en-us/articles/360057382374-Replies-FAQ) recently, Discord *still* does not let moderators edit out others’ messages (with their name irreversibly noted next to the message), let alone bots gaining such superpower through Discord’s API.
Echoïng is but a workaround solution.
Although it can detect replies and files, Discord’s API can’t control reply pings unlike clients can, and neither can repost any files attach by the original message through the original link – attachments are deleted along with the message.
These file losses are regonized by the bot, but because downloading and reüploading takes time and resources, it’s left `WONTFIX`.

## Features and [Dependencies](Gemfile)
* Again – Echos, so messages aren’t banned in wholes
* Ruby ([discordrb/discordrb](https://github.com/discordrb/discordrb)), an fun language ~~infamous for its underratings~~.
```bash
$ gem install discordrb
```
* Match using (__case-insensitive__) (Ruby) [`RegExp`](https://ruby-doc.org/core/Regexp.html)s for your edge cases like `variable 4$$ignment`
* Uses CSV to clearly, quckily and flexibly customize RegExps and replacements for each:
```bash
$ gem install csv
```
* _Optional_ file watching with [guard/listen](https://github.com/guard/listen) to skip hosts from rebooting their bots when the RegExps are updated:
```bash
$ gem install listen
```
* Custom status indicator:
  * `Watching <n> RegExps` (for some reason, it always states `Playing` on my end regardless what I try. _Help Wanted._)
  * 🟢 Online = Running; 🌙 = (Re)loading RegExps

Because I don’t have funds myself, **`Beep-bot` must be downloaded and hosted yourself for you Discord application and server.
If you’d like to sponsor to host public for all Discord, leave a message!** (If so, the CSV local file will be replaced by in-Discord commands.)

## Usage
* Make sure you have required [Gem dependencies](Gemfile) mentioned in [§Features and Dependencies](#Features-and-Dependencies) installed.
* Create the file `bot_token.txt` in the same directory as `main.rb`, containing your Discord bot’s token.
(For the confidentiality of both yours and mine, it’s [`.gitignore`](.gitignore)d)
* Create the file `map.csv` in the same directory. This is the CSV of RegExps and corresponding replacements:
  * Each row but the first column is a list of __case-insensitive__ (Ruby) RegExps (__without the surrounding `/…/`__) that the bot will match and replace with the text from the first column forbatim.
    * For example:
```csv
F:face_with_symbols_over_mouth:,(?<!brain)fu[c<]k,fcuk
```
will replace “[fcuk](https://en.wikipedia.org/wiki/FCUK)ing” with “F🤬ing” but will leave “[BrainFu<k](https://en.wikipedia.org/wiki/Brainfuck)” intact
    * Blank rows and RegExps are ignored when reading the CSV.
  * This file is also [`.gitignore`](.gitignore)d so one may use the same repository for running their bot and commmiting their code updates.
(It’s actually to avoid uploading swear words to a public repository.)

## Won’t Fixes
If you wanna, you can simply fork this MIT-license repo for your own development.
* [Rubocop](https://rubocop.org/): Because this is but a script, I went free-style and did not bother restraining myself.
~~Those OCD-ish police are gonna be very upset about my not-crimes.~~
* Automatically adapt [Basic Latin](https://en.wikipedia.org/wiki/ISO_basic_Latin_alphabet)-only RegExps to match:
(These are a lot of engineering to avoid accidently purging features of those permissive.)
  * Đïãçríŧìčŝ from your faux *Español/a-Français* fiends.
  * Ligatures (e.g. `æ`)
  * ҈Z҉a҉l҉g҉o (in case of stealthy snitches?)
  * £αƞ¢γƬҽאƚ (anyöne _this_ crazy?)

## Friendly mention
This bot was requested by Discord user `TaiterTot` for our club server.
They was surprised that this repository uses [the MIT license](LICENSE.txt).

Now, Tait, since I don’t have a 24/7 server but you do, _you host_.
