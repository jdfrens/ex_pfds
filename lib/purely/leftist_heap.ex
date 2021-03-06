defmodule Purely.LeftistHeap do
  @moduledoc """
  Implementation of a [leftist heap (a.k.a. "leftist tree")](https://en.wikipedia.org/wiki/Leftist_tree)
  """

  alias Purely.BinaryTree

  @type empty :: BinaryTree.empty()
  @type t :: empty | BinaryTree.t()

  @empty {}

  use Purely.Heap, empty_type: __MODULE__.empty(), type: __MODULE__.t()

  def empty?(h), do: h == @empty

  def put(h, value) do
    merge(build(value), h)
  end

  def min(@empty), do: nil
  def min({{_, value}, _, _}), do: value

  def remove_min(@empty), do: nil
  def remove_min({_, l, r}), do: merge(l, r)

  def merge(h1, @empty), do: h1
  def merge(@empty, h2), do: h2

  def merge({{_, v1}, l1, r1} = h1, {{_, v2}, l2, r2} = h2) do
    cond do
      v1 < v2 ->
        build(v1, l1, merge(r1, h2))

      true ->
        build(v2, l2, merge(h1, r2))
    end
  end

  defp rank(@empty), do: 0
  defp rank({{rank, _}, _, _}), do: rank

  defp build(v), do: build(v, @empty, @empty)

  defp build(v, l, r) do
    cond do
      rank(l) >= rank(r) ->
        {{rank(r) + 1, v}, l, r}

      true ->
        {{rank(l) + 1, v}, r, l}
    end
  end
end
