# A variation on Holman Does Dotfiles

## The Rationale From @holman:

Your dotfiles are how you personalize your system. These are mine.

I was a little tired of having long alias files and everything strewn about
(which is extremely common on other dotfiles projects, too). That led to this
project being much more topic-centric. I realized I could split a lot of things
up into the main areas I used (Ruby, git, system libraries, and so on), so I
structured the project accordingly.

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read my post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## What I'm Doing Different

Their are a few cosmetic changes to this (I use emacs instead of atom, for instance), but the biggest philosophical change has to do with how we install packages. Rather than just list all the installed pakcages, I started off using install.sh scripts for each topic which did some conditional checks similar to what Holman has set up for rben and ruby-build in his version. I then realized this was getting really repetitive. So to simplify, brew-install.sh now has two simple loops: one checking for needed taps and the other installing formulae. These loops get fed inputs from JSON files listing the packages we want under each topic. This keeps the essance of Holman's topical system intact while also keeping our scripts a lot more DRY.

## install

Run this:

```sh
git clone https://github.com/apmarshall/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## what's inside

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you.
[Fork it](https://github.com/holman/dotfiles/fork), remove what you don't
use, and build on what you do use.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.
- **topic/packages.json**: This contains a list of the Homebrew taps and packages you need for each topic, logically organized for easy editing and modification. brew-install.sh uses jq to create arrays based on what you put in the JSON files to know what to install each time it runs.

## bugs

These dotfiles are being actively used, so if you fork them read them and see what you need to change for your own personal set-up.

You can lodge issues on the original Holman repository:
[open an issue](https://github.com/holman/dotfiles/issues) or on this repository.

## thanks

[Zach Holman](https://github.com/holman)
[Mathias Bynens](https://github.com/mathiasbynens)
[Ryan Bates](http://github.com/ryanb)
[Oh-my-Zsh](https://github.com/robbyrussell/oh-my-zsh)

