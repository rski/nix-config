.PHONY: all install

all:
	sudo nixos-rebuild switch

install:
	sudo ln -sf `pwd`/configuration.nix /etc/nixos/configuration.nix
	sudo ln -sf `pwd`/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
