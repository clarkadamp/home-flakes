{ self, ... }:
{
  flake.modules.nixos.systemCli = {
    imports = with self.modules.nixos; [
      systemBasic
      git
      neovim
      networkingUtils
      tmux
      zsh
    ];
  };

  flake.modules.darwin.systemCli = {
    imports = with self.modules.darwin; [
      systemBasic
      git
      neovim
      networkingUtils
      tmux
      zsh
    ];
  };

  flake.modules.homeManager.systemCli = {
    imports = with self.modules.homeManager; [
      systemBasic
      git
      neovim
      networkingUtils
      tmux
      zsh
    ];
  };
}
