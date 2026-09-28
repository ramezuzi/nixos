{ self, inputs, ... }: {
	flake.homeModules.music = { pkgs, config, ... }: {
		home.packages = with pkgs; [
		cmus
		termusic
		ncmpcpp
		mpd
		mpc
		];
		 
		services.mpd = {
			enable = true;
			musicDirectory = "/home/ramez/Music";
			user = "ramez";
		};

	};
	}
