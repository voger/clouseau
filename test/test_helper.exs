Application.put_env(:clouseau, :default_switches, file: false)
ExUnit.start()

Code.require_file("test/clouseau_case.exs")
