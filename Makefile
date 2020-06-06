.PHONY: all install install-user

all:
	sudo nixos-rebuild switch

install:
	sudo ln -sf `pwd`/configuration.nix /etc/nixos/configuration.nix
	sudo ln -sf `pwd`/hardware-configuration.nix /etc/nixos/hardware-configuration.nix

upgrade:
	sudo nixos-rebuild switch --upgrade

gc:
	sudo nix-collect-garbage -d

install-user:
	mkdir -p ~/.config/nixpkgs
	ln -sf `pwd`/nixpkgs/config.nix ~/.config/nixpkgs
