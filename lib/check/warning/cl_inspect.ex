defmodule Clouseau.Check.Warning.ClInspect do
  @moduledoc """
    Cl.inspect is a IO.inspect enhancement meant for debugging and testing
    session. Usage in production code is discuraged because of the extra debugging
    stuff it adds in output and the extra processing it does to create the label tag.

    This check warns about Cl.inspect calls, because they might have been committed
    in error.
  """

  @explanation [check: @moduledoc]
  @call_string "Cl.inspect"

  # you can configure the basics of your check via the `use Credo.Check` call
  use Credo.Check, base_priority: :high, category: :warning

  @doc false
  def run(source_file, params \\ []) do

    issue_meta = IssueMeta.for(source_file, params)
    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

 defp traverse({{:., _, [{:__aliases__, _, [:Cl]}, :inspect]}, meta, _arguments} = ast, issues, issue_meta) do
    {ast, issues_for_call(meta, issues, issue_meta)}
  end
  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  def issues_for_call(meta, issues, issue_meta) do
    [issue_for(issue_meta, meta[:line], @call_string) | issues]
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue issue_meta,
      message: "There should be no calls to Cl.inspect/1.",
      trigger: trigger,
      line_no: line_no
  end
end

