.PHONY: all

all:
	sudo cp configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch
