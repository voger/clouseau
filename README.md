# Presentation
Clouseau is a silly little inspector. Essentialy is an enhancement over the [IO.inspect](https://hexdocs.pm/elixir/IO.html#inspect/2) function.
It adds the functionality to display the file, module and line number of the calling location.
Also it can optionaly display a line under the inspected term, to separate it from other output
on the screen and optionaly colorize the output. 


# How to install

Add `clouseau` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [
    #...
    {:clouseau, "~> 0.4.0"}
  ]
end
```



# How to use

In order to use Clouseau you first must require the `Cl` module

```elixir
require Cl
```

Clouseau exports two macros: `Cl.inspect/2` and `Cl.inspect/3`. Just use them instead of `IO.inspect`.


```elixir
Cl.inspect("test", label: "This is a test")
```

or if you want colors and a bottom border

```elixir
Cl.inspect("test", label: "-cb This is a test")
```

Of course the `Cl.inspect/2` macro can be used in a pipe

```elixir
conn
  |> Cl.inspect(label: "-cb Before magic")
  |> do_some_magic()
  |> Cl.inspect(label: "-cb After magic")
```


That's it. You can return to your code now.



If you wish to do some customization continue reading below.

## Switches

Both macros are ready to use out of the box. By default they display the file, module and line where the macro was called, above the label and the inspected term.

clouseau uses [OptionParser](https://hexdocs.pm/elixir/OptionParser.html) to parse the switches. The switches can be given directly in the label option. You can use switches to modify what will be shown.


```elixir
Cl.inspect({"test", 7, %{banana: :yellow}}, label: "--no-file Test showing only module and line")
# Clouseau.ClTest:20
# Test showing only module and line: {"test", 7, %{banana: :yellow}}
```

```elixir
Cl.inspect({"test", 7, %{banana: :yellow}}, label: "-b Test With border", syntax_colors: [number: :blue])
# lib/cltest.ex
# Clouseau.ClTest:26
# Test With border: {"test", 7}
# -------------------------------------------------------------------------------------
# {"test", 7}
```


Switches must be grouped in the beginning of the string. Any non-switch group of characters stops the parser and the rest of the line is treated as the text of the label. For example:

```elixir
Cl.inspect({"test", 7, [banana: :yellow]}, label: "--no-module --no-line -b Showing only the --file option. The --no-border option has no effect")
# lib/cltest.ex
# Showing only the --file option. The --no-border option has no effect: {"test", 7, [banana: "split"]}
# --------------------------------------------------------------------------------------------------------------------------------------------------
```

---
**Note:** The first space on the label text is always discarded. The rest of the spaces stay there. This is intentional to keep it as consistent as possible
with `IO.inspect` who does not trim white spaces. For example:

```elixir
Cl.inspect({"test", 7}, label: "-b      Test With border", syntax_colors: [number: :blue])
#lib/cltest.ex
#Clouseau.ClTest:26
#     Test With border: {"test", 7}
#------------------------------------------------------------------------------------------
```

The distance between the switch and the text is 6 spaces while the result displays 5 spaces. If, for some reason, you depend on `IO.inspect` not triming the
white space, keep this behavior in mind.


---

### The available switches are:


| Switch    | Type     | Default | Shortcut | Description                                                                                        |
|-----------|----------|---------|----------|----------------------------------------------------------------------------------------------------|
| file:     | :boolean | true    | f        | Display the file where this call happened                                                          |
| full_path | :boolean | false   | none     | Display the file as absolute path or relative to project root. Default is relative to project root |
| module:   | :boolean | true    | m        | Display the module where this call happened                                                        |
| line:     | :boolean | true    | l        | Display the line where this call happened                                                          |
| text:     | :boolean | true    | t        | Display the descriptive text for the label                                                         |
| border:   | :boolean | false   | b        | Display a border under the inspected term                                                          |
| colors:   | :boolean | false   | c        | Colorize the inspected term                                                                        |

If you wish to have your default set of switches you can set options in your config

```elixir
config :clouseau,
default_switches: [module: true, line: true, file: true, border: true, colors: true]
```



## Template

clouseau uses an [EEx](https://hexdocs.pm/eex/EEx.html) template to display the various parts of the label.
The template uses a custom engine `Clouseau.TemplateEngine` instead of the default `EEx.SmartEngine`. The differences are:

* It doesn't add a line break on tag's end. Instead you shoud add a `"\n" `where you want a line break. The reason for this change is beacuse this way the line break can be controlled with conditionals.
* It supports a `has_val?/1` function that returns `false` if the value is one of `nil`, `false` or `""`.
* The `@` function desn't use `Access.fetch/2` but `Map.get/2` to get the value. It does not warn or rise any errors. Instead it returns an empty string.
* It can use IO Lists.


The format of the label is not configurable on the fly. If, for example, it is prefered to display the module before the line, this can be changed only by using a diferent template at compile time.

You can use a custom template by setting in your config. Below is shown the default template as an example.

```elixir
config :clouseau,
template: """
<% import IO.ANSI %>
<%= if has_val?(file), do: from_iolist [:blue,  @file, :reset, "\n"] %>
<%= if has_val?(module), do: from_iolist [:green, @module, ":"] %>
<%= if has_val?(line), do:  from_iolist [:red, @line] %>
<%= if has_val?(module) || has_val?(line), do: from_iolist [:reset, "\n"] %>
<%= if has_val?(text), do: from_iolist [:yellow, @text, :reset, ": "] %>
"""
```

## Inspect Colors

The colors for the inspected term are choosen to match those of iex. If you wish to change any of the default colors you can do so in your config

```elixir
config :clouseau,
  syntax_colors: [
    string: :red,
    number: :yellow
]

```

The above snipet will replace the default colors for strings and numbers.

Or directly in you macro call

```elixir
%{
  "doors" => 2,
  "windows" => 5,
} 
|> Cl.inspect(label: "-bc Test with border and colors", syntax_colors: [number: :red])
```

If the `syntax_colors` option is used, then the default colors or colors used in the `config.exs` are not used.

```elixir
%{
  :answer => 42,
  :comment => "The Answer to the Ultimate Question of Life, The Universe, and Everything."

} 
|> Cl.inspect(syntax_colors: [number: :red])
```

In the above snippet, only the numbers will be colored.

If colors are defined in `config.exs` they will be merged with the default colors. Any defined color will override the default.

Colors can be displayed either by using the `-c` switch in the call, by defining the `colors: true` in `config.exs` or the `syntax_colors` option in the call.


## Credo

clouseau provides two custom credo checks: `Clouseau.Check.Warning.ClInspect` and `Clouseau.Check.Warning.RequireCl`.
To use them just append them to the `:checks` option in your `.credo.exs` file.

```elixir
checks: [

  # ... some checks

  # Custom checks can be created using `mix credo.gen.check`.
  #

  {Clouseau.Check.Warning.ClInspect},
  {Clouseau.Check.Warning.RequireCl},
]
```

# TODO
* Add some tests
* Add dialyzer documentation


