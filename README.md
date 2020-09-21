# vagrants
a collection of vagrant files I have used

## Usage
    curl -sL https://raw.githubusercontent.com/rogusdev/vagrants/master/setup | bash -s TYPE
Where TYPE can be: `all`, `dotnet-core`, `rails`, etc -- the folders in this repo with `setup_ubuntu.sh` in them.

## Installation (Vagrant)

On Windows, install with Chocolatey: https://chocolatey.org/

    choco upgrade -y virtualbox vagrant

On OS X, install with Brew: https://brew.sh/

    brew cask upgrade virtualbox vagrant

Or manually install VirtualBox: https://www.virtualbox.org/wiki/Downloads

Then manually install Vagrant: https://www.vagrantup.com/downloads.html
 (Vagrant is a wrapper around VirtualBox and so requires it)


## Clean up / Upgrading

    vagrant destroy -f && rm -rf .vagrant

## Installing on Elementary

I use [elementary os](https://elementary.io/) as my primary linux vm when I want a desktop (especially for frontend dev on my windows box to have proper hot reloading).

I also want to set it up the same as my vagrant boxes, but copy-paste is not on right at the start and I want to make it easy, so type this:

    curl https://raw.githubusercontent.com/rogusdev/vagrants/master/elementary.sh | bash
