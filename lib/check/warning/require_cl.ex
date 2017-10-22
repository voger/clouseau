if Code.ensure_loaded?(Credo.Check) and
   Code.ensure_loaded?(Credo.Code) and
   Code.ensure_loaded?(IssueMeta)
  do
  defmodule Clouseau.Check.Warning.RequireCl do
    @moduledoc """
      Requiring Cl.inspect usualy happens during debugging or
      testing in order to use the Cl.inspect macro. Since it's
      usage is discuraged in production "require Cl" should be
      removed also.

      This check warns about "require Cl" calls, because they might have been committed
      in error or may be leftovers from earlier debugging sessions.
    """

    @explanation [check: @moduledoc]
    @call_string "require Cl"

    # you can configure the basics of your check via the `use Credo.Check` call
    use Credo.Check, base_priority: :high, category: :warning

    @doc false
    def run(source_file, params \\ []) do

      issue_meta = IssueMeta.for(source_file, params)
      Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
    end

   defp traverse({:require, _, [{:__aliases__, meta, [:Cl]}]} = ast, issues, issue_meta) do
    # {:require, [line: 2], [{:__aliases__, [counter: 0, line: 2], [:Cl]}
      {ast, issues_for_call(meta, issues, issue_meta)}
    end

    defp traverse(ast, issues, _issue_meta) do
      # IO.inspect ast
      {ast, issues}
    end

    def issues_for_call(meta, issues, issue_meta) do
      [issue_for(issue_meta, meta[:line], @call_string) | issues]
    end

    defp issue_for(issue_meta, line_no, trigger) do
      format_issue issue_meta,
        message: "There should be no calls to \"require Cl\"",
        trigger: trigger,
        line_no: line_no
    end
  end
end
