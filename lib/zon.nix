{ lib }:

let
  inherit (builtins) typeOf;
  inherit (lib.strings) concatMapStringsSep replaceStrings;

  keywords = [
    "addrspace"
    "align"
    "allowzero"
    "and"
    "anyframe"
    "anytype"
    "asm"
    "break"
    "callconv"
    "catch"
    "comptime"
    "const"
    "continue"
    "defer"
    "else"
    "enum"
    "errdefer"
    "error"
    "export"
    "extern"
    "fn"
    "for"
    "if"
    "inline"
    "linksection"
    "noalias"
    "noinline"
    "nosuspend"
    "opaque"
    "or"
    "orelse"
    "packed"
    "pub"
    "resume"
    "return"
    "struct"
    "suspend"
    "switch"
    "test"
    "threadlocal"
    "try"
    "union"
    "unreachable"
    "var"
    "volatile"
    "while"
  ];

  # the escapes zig's std.zig.stringEscape writes for printable text
  escape =
    replaceStrings
      [
        "\\"
        "\""
        "\n"
        "\r"
        "\t"
      ]
      [
        "\\\\"
        "\\\""
        "\\n"
        "\\r"
        "\\t"
      ];

  isValidId = s: builtins.match "[A-Za-z_][A-Za-z0-9_]*" s != null && !builtins.elem s keywords;

  id = s: if isValidId s then s else "@\"${escape s}\"";

  # the trailing comma makes zig fmt put each item on its own line
  tuple = items: if items == [ ] then ".{}" else ".{ ${concatMapStringsSep ", " (x: x) items}, }";
in

rec {
  /**
    An enum literal, `.name` in ZON.

    # Example

    ```nix
    toZON { side = enum "left"; }
    => ".{ .side = .left, }"
    ```
  */
  enum = name: { _enum = name; };

  /**
    Convert a nix value to ZON, the zig object notation. Attrsets become
    structs, lists become tuples, `enum "x"` becomes `.x`.

    # Example

    ```nix
    toZON { gap = 9; colors = [ "red" ]; }
    => ".{ .colors = .{ \"red\", }, .gap = 9, }"
    ```
  */
  toZON =
    value:
    let
      type = typeOf value;
    in
    if type == "set" && value ? _enum then
      ".${id value._enum}"
    else if type == "set" then
      tuple (map (name: ".${id name} = ${toZON value.${name}}") (builtins.attrNames value))
    else if type == "list" then
      tuple (map toZON value)
    else if type == "string" || type == "path" then
      "\"${escape (toString value)}\""
    else if type == "bool" then
      lib.trivial.boolToString value
    else if type == "null" then
      "null"
    else if type == "int" || type == "float" then
      toString value
    else
      throw "toZON: cannot convert a ${type}";
}
