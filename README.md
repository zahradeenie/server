# HTTP Server

I've created a http server before in Elixir but that was actually using the Phoenix framework. This project is following The Pragmatic Studio's Developing with Elixir/OTP course which is giving me more depth into data structures, transforming data, pattern matching, using modules and more. Instead of writing about how to build the server, I'm going to write about the concepts that I'm learning while taking this course.

## Intro to Elixir

### Data
All data structures in Elixir are 100% immutable. There's no `object.new_property = value` or reassigning values in one place but also in another place like JavaScript. Instead, what you need to do is take the data and transform it to what you want and even then, you're never mutating the original data - you're given a new structure with the transformed data. This has been the most challenging for me so far. It's difficult to stop thinking of the `=` as assignment when that's all you do with it in JS.

The types of data structures
- Maps
- Keyword Lists
- Nested data strucutres

**Maps**
Maps are weird looking things in Elixir: `map = %{ :key => value }`. That's one way of declaring a map but you can also use atoms as keys for a map - `map = %{ key: value }` which gives you a nice way of accessing the atom values from the map: `map.key` instead of `map[:key]`. Using atoms as keys also means that when you try to access a key that doesn't exist, you'll get a nice error message instead of `nil`

some useful info to know about maps:
- Maps allow any value as a key.
- Maps’ keys do not follow any ordering.

There's a nice way of updating a map's value if the key already exists: `map = %{ key: 'hello', key_2: 'world' }` --> `Map.put(map | key_2: 'zahra')` = `%{ key: 'hello', key_2: 'zahra' }`. Nifty!


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `server` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:server, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/server](https://hexdocs.pm/server).

