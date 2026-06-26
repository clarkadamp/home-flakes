{ self, ... }:
{
  flake.modules.nixos.systemCli = {
    imports = with self.modules.nixos; [
      systemBasic
      git
      homeManager
      neovim
      networkingUtils
      ssh
      tmux
      zsh
    ];
  };

  flake.modules.darwin.systemCli = {
    imports = with self.modules.darwin; [
      systemBasic
      git
      homeManager
      neovim
      networkingUtils
      ssh
      tmux
      zsh
    ];
  };

  flake.modules.homeManager.systemCli = {
    imports = with self.modules.homeManager; [
      systemBasic
      git
      homeManager
      neovim
      networkingUtils
      ssh
      tmux
      zsh
    ];
  };
}
