{ lib, ... }:
let
  # traverse an item of type T topologically.
  # returns a List T
  topoTraverse =
    # T -> List T -- unfold an item into its next layer
    unfoldList:
    # T -> Bool -- whether to recurse further on an item
    pred:
    # T -- the start item
    tree:
    let
      work = unfoldList tree;
      moreWork = builtins.filter pred work;
    in
    work ++ lib.concatMap (topoTraverse unfoldList pred) moreWork;

  readDirRecursively =
    dir:
    topoTraverse
      # run builtins.readDir to get the next level
      (
        dir:
        lib.mapAttrsToList (basename: type: {
          path = (toString dir.path) + "/" + (toString basename);
          inherit type;
        }) (builtins.readDir dir.path)
      )
      # only recurse when it’s a directory and the predicate matches
      (x: x.type == "directory")
      # initial value
      {
        path = dir;
        type = "directory";
      };

  recursiveFiles =
    path:
    readDirRecursively path
    |> builtins.filter (x: x.type == "regular")
    |> map (x: (lib.strings.removePrefix (toString path + "/") x.path));

in
{
  config.flake.factory.symlinkDotfiles =
    {
      hmConfig, # mkOutOfStoreSymlink is only defined in home-manager
      path,
      dotfilesRoot ? "home-flakes",
      subFilesOnly ? false,

    }:
    let
      dirParts = toString path |> lib.strings.splitString "/";
      topFolder = builtins.elemAt dirParts (builtins.length dirParts - 1);
      mkSymlink =
        name: hmConfig.lib.file.mkOutOfStoreSymlink "${hmConfig.dotfilesRoot.${dotfilesRoot}}/${name}";
    in
    if subFilesOnly then
      (
        recursiveFiles path
        |> map (
          file:
          let
            finalName = "${topFolder}/${file}";
          in
          {
            name = finalName;
            value.source = mkSymlink finalName;
          }
        )
        |> builtins.listToAttrs
      )
    else
      {
        "${topFolder}".source = mkSymlink topFolder;
      };
}
