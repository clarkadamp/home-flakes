{ lib, ... }:
{
  flake.factory.hyprland = rec {
    mainMod = "SUPER";
    toLua = lib.generators.toLua { };
    # `_args` renders attrsets as Lua multi-argument calls instead of tables.
    renderLuaArgs =
      value:
      if lib.isAttrs value && value ? _args then
        lib.concatMapStringsSep ", " toLua value._args
      else
        toLua value;
    luaAttrs = args: if args == null then "" else ((lib.generators.toLua { }) args);
    hlDsp = name: args: (lib.generators.mkLuaInline "hl.${name}(${luaAttrs args})");
    asArgs = args: { _args = args; };
    mkBind =
      {
        keys,
        dispatcher,
        flags ? null,
      }:
      asArgs (
        [
          keys
          dispatcher
        ]
        ++ lib.optional (flags != null) (lib.generators.mkLuaInline (luaAttrs flags))
      );
    bind =
      keys: dispatcher:
      (mkBind {
        inherit keys;
        dispatcher = (hlDsp "dsp.${dispatcher}" null);
      });
    bind' =
      keys: dispatcher: args:
      (mkBind {
        inherit keys;
        dispatcher = (hlDsp "dsp.${dispatcher}" args);
      });
    bind'' =
      keys: dispatcher: args: flags:
      (mkBind {
        inherit
          keys
          flags
          ;
        dispatcher = (hlDsp "dsp.${dispatcher}" args);
      });
    on =
      event: command:
      let
        ensureList = command: if builtins.isString command then [ command ] else command;
      in
      (onFunc event "hl.exec_cmd(${renderLuaArgs (asArgs (ensureList command))})");
    onFunc =
      event: content:
      asArgs [
        event
        (lib.generators.mkLuaInline "function(event)\n  ${content}\nend")
      ];
    dimKeyBoardOnClass =
      class:
      (onFunc "window.fullscreen" ''
        if event.class == "${class}" then
          if event.fullscreen > 0 then
            hl.dispatch(hl.dsp.exec_cmd("brightnessctl -s --device=tpacpi::kbd_backlight set 0"))
          else
            hl.dispatch(hl.dsp.exec_cmd("brightnessctl -r --device=tpacpi::kbd_backlight"))
          end
        end
      '');
    debugEventData =
      event:
      (onFunc event ''
        function dump(o)
          if type(o) == "table" then
            local s = "{ "
            for k, v in pairs(o) do
              local _k = k
              if type(_k) ~= "number" then
                _k = '"' .. _k .. '"'
              end
              s = s .. "[" .. _k .. "] = " .. dump(v) .. ","
            end
            return s .. "} "
          else
            return tostring(o)
          end
        end

        local file = io.open("/tmp/hyprland-events.log", "a")
        file:write("### ${event} \n")
        file:write(tostring(event.fullscreen) .. tostring(event.inhibiting_idle) .. "\n")
        file:close()
      '');
    launchOrFocus =
      keys: executable: class: workspace:
      (mkBind {
        inherit keys;
        dispatcher = (
          lib.generators.mkLuaInline ''
            function()
              for _, window in ipairs(hl.get_windows({ class = "${class}", workspace = ${toString workspace} })) do
                hl.dispatch(hl.dsp.focus({ window = window }))
                return
              end
              for _, window in ipairs(hl.get_windows({ class = "${class}" })) do
                hl.dispatch(hl.dsp.focus({ window = window }))
                return
              end
              hl.dispatch(hl.dsp.exec_cmd("${executable}", { workspace = ${toString workspace} }))
            end
          ''
        );
      });

  };
}
