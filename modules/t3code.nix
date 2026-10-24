{ self, inputs, ... }: {
	flake.homeModules.t3code = { ... }: {
		programs.t3code = {
			enable = true;
		};
	};
	}
