{ config, pkgs, lib, ... }:

with pkgs;
with lib;
let
  yamlToJSON = path:
    runCommand "yaml.json" { nativeBuildInputs = [ pkgs.ruby ]; } ''
      ruby -rjson -ryaml -e "puts YAML.load(ARGF).to_json" < ${path} > $out
    '';
in {
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+j" = "kitten pass_keys.py neighboring_window bottom ctrl+j";
      "ctrl+k" = "kitten pass_keys.py neighboring_window top    ctrl+k";
      "ctrl+h" = "kitten pass_keys.py neighboring_window left   ctrl+h";
      "ctrl+l" = "kitten pass_keys.py neighboring_window right  ctrl+l";
    };
    settings = {
      scrollback_pager = ''
        nvim -u NONE -c "syntax on" -c 'set ft=man nonumber nolist showtabline=0 foldcolumn=0 laststatus=0' -c "autocmd VimEnter * normal G" -c "map q :qa!<CR>" -c "set clipboard+=unnamedplus" -'';
      shell = "${pkgs.zsh}/bin/zsh";
      term = "xterm-256color";

      foreground = "#979eab";
      background = "#282c34";
      cursor = "#cccccc";
      color0 = "#282c34";
      color1 = "#e06c75";
      color2 = "#98c379";
      color3 = "#e5c07b";
      color4 = "#61afef";
      color5 = "#be5046";
      color6 = "#56b6c2";
      color7 = "#979eab";
      color8 = "#393e48";
      color9 = "#d19a66";
      color10 = "#56b6c2";
      color11 = "#e5c07b";
      color12 = "#61afef";
      color13 = "#be5046";
      color14 = "#56b6c2";
      color15 = "#abb2bf";
      selection_foreground = "#282c34";
      selection_background = "#979eab";
    };
  };

  xdg.configFile."kitty/pass_keys.py".source =
    "${vimPlugins.vim-kitty-navigator}/share/vim-plugins/vim-kitty-navigator/pass_keys.py";
  xdg.configFile."kitty/neighboring_window.py".source =
    "${vimPlugins.vim-kitty-navigator}/share/vim-plugins/vim-kitty-navigator/neighboring_window.py";
}
