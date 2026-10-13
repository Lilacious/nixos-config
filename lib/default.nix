# Custom libs, exported as `self.lib`
{ self, inputs, ... }:
let
  args = { inherit self inputs; };
in
{
  flake.lib = import ./mkhost.nix args;
}
