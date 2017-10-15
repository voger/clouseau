# Important note:
  This project is a toy project of mine so I can learn various Elixir aspects better.
  While best efforts are made to keep it as safe as possible, I can't make any guaranties
  for it's functionality. Not even for the intended purpose. Keep in mind this is the work
  of a programming student and proceed with caution. **Comments, advice and pull requests are welcome.**


# Presentation
Clouseau is a silly little inspector. Essentialy is an enhancement over the IO.inspect function.
It adds the functionality to display the file, module and line number of the calling location.

# How to install

// TODO: add installation notes.


# How to use

In order to use Clauseau you first must require the 'Cl' module

```elixir
    require Cl
```

Clouseau exports only one macro: `Cl.inspector/2`. Just use it instead of `IO.inspect/2`.


```elixir
Cl.inspector("test2", label: "This is a test")
```

In this case it will use the default options and the default template taken from your config
or using it's default options. Setting the option `default_options` should suffice and no extra
configuration is needed.

The `Cl.inspector/2` can't use different template than the one configured. However you can choose
the items that can be displayed on the fly

```elixir
 Cl.inspector({"test", 7}, label: "lm | test")
 # Elixir.Clauseau.ClTest:5
 # Test showing only module and line: {"test", 7
 ```

In the above `:label` option the display options are separated from the label with the `|` character.

 The available options are:

 * **l** for `:line`
 * **m** for `:module`
 * **f** for `:file`

How these items will be shown is not configurable on the fly. If, for example, it is prefered to display
the module before the line, this can be changed only for the template.


# TODO
* Add some tests



