# My Dotfiles

Completely reworked to utilize chezmoi as a dotfile manager instead of relying on custom scripts (or even ansible).

## The Rationale From @holman (my original dotfiles inspiration):

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

Their are a few cosmetic changes to this (I use emacs instead of atom, for instance), but the biggest philosophical change has to do with how we install packages and manage configurations. After trying numerous approaches, I've landed on a combination of Ansible and Munki as my package and application managers. This is partly because I'm not just managing my own machine, but also machines for my clients and colleagues, so it needs to be reproducible and something I can manage remotely. 

For configuration management, I've landed on Chezmoi. Being able to install the configuration tool via Homebrew and then programatically pull in and customize configurations is great when this may need to work on more than one machine with slightly different requirements.

Reflecting this, the dotfiles themselves are in the main directory of the repo, prefixed by `dot_`, following the Chezmoi convention. The topical folders have mostly been collapsed, and instead topically prefixed .zsh files can be found inside the `zsh/` directory.

## install

`chezmoi init https://github.com/apmarshall/dotfiles.git`

That's it, we're done.


## bugs

These dotfiles are being actively used, so if you fork them read them and see what you need to change for your own personal set-up.

You can lodge issues on the original Holman repository:
[open an issue](https://github.com/holman/dotfiles/issues) or on this repository.

## thanks

[Zach Holman](https://github.com/holman)
[Mathias Bynens](https://github.com/mathiasbynens)
[Ryan Bates](http://github.com/ryanb)
[Oh-my-Zsh](https://github.com/robbyrussell/oh-my-zsh)

