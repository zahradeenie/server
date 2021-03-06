# HTTP Server

I've created a http server before in Elixir but that was actually using the Phoenix framework. This project is following The Pragmatic Studio's Developing with Elixir/OTP course which is giving me more depth into data structures, transforming data, pattern matching, using modules and more. Instead of writing about how to build the server, I'm going to write about the concepts that I'm learning while taking this course.

## Intro to Elixir

### Data

All data structures in Elixir are 100% immutable. There's no `object.new_property = value` or reassigning values in one place but also in another place like JavaScript. Instead, what you need to do is take the data and transform it to what you want and even then, you're never mutating the original data - you're given a new structure with the transformed data. This has been the most challenging for me so far. It's difficult to stop thinking of the `=` as assignment when that's all you do with it in JS.

The types of data structures
- Maps
- Lists
- Keyword Lists

**Maps**

Maps are weird looking things in Elixir: `map = %{ :key => value }`. That's one way of declaring a map but you can also use atoms as keys for a map - `map = %{ key: value }` which gives you a nice way of accessing the atom values from the map: `map.key` instead of `map[:key]`. Using atoms as keys also means that when you try to access a key that doesn't exist, you'll get a nice error message instead of `nil`

some useful info to know about maps:
- Maps allow any value as a key.
- Maps’ keys do not follow any ordering.

There's a nice way of updating a map's value if the key already exists: `map = %{ key: 'hello', key_2: 'world' }` --> `Map.put(map | key_2: 'zahra')` = `%{ key: 'hello', key_2: 'zahra' }`. Nifty!

**Atoms**

An atom is a constant whose value is the same as its name.

**Keyword Lists and Structs**

Keyword lists are basically a list of tuples containing your usual key value pairs of an atom and a value: `[{:key, ""}, {:key2, ""}, {:key3, ""}]`

These are usually used to define structs which is used to store default data. A struct is an extension of a map so you can update a struct's values the same way you would a map but the main difference is you can only update the values existing in the struct, you cannot add a value willy nilly.

Oh, also important and handy is knowing that Lists are recursive data structures... more on that later.

### Pattern Matching

A great feature of Elixir is pattern matching and it's exactly what it sounds like. You don't really use if/else statements in Elixir, you use pattern matching. This matches the request/arguments of a function and runs the function if there's a match. Because of this, you need to have a default 'catch all' function to return something in the case of no matches. To pattern match, you need to write as many functions as you need with the same name and arity - these are called 'function clauses'.

An important thing to note is that Elixir pattern matches from top to bottom so your default clause needs to be at the bottom of the other clauses. Part of Elixir's no-bullshit approach to formatting, you're required to group together all function clauses. If you don't you'll get a nice warning from the compiler that you made an oopsie. Love it.

**Pattern matching on maps**

If you're passing a map into a function and you only really want to use a specific value, you can pattern match the key/value into the function's argument. This is useful if you want to do something specific when the value is _x_ vs _y_.
```elixir
def do_something(%{key: "value"}) do
  # something happens here
end
```
If you don't care what the value is, you can add a variable name to the value and use it in the function block.
```elixir
def do_something(%{key: key}) do
  # something happens here with key
end
```

**Pattern matching on lists**

Another nifty gifty from elixir is the ability to pattern match on lists. I've played around with the head tail matching before and I love it. What it does is bind the first value of a list to the head variable and binds the remaining list to the tail value:
```elixir
[head | tail] = [1, 2, 3]
// head = 1, tail = [2, 3]
```
but you can also use this syntax to prepend a value to a list:
```elixir
nums = [1, 2, 3]
[0 | nums]
// [0, 1, 2, 3]
```
This syntax can be called recursively until the is no tail and an empty list is returned. I learned quickly that it's very dangerous to use recursion in JavaScript but it's very very efficient to do this in Elixir because it uses `tail call optimisation` which means no new frames are called onto the call stack. But recursion is not really used this way IRL in Elixir, you'd generally use functions available in the Enum module for traversing and manipulating lists.

### Handy commands

Starting an iex session in the context of the app. The application is compiled when you run this: `iex -S mix`

To compile a module within an iex session: `-c PATH`

To recompile the whole application in an iex session: `recompile()`

To compile a module from the command line: `elxiir PATH`

### Good to know

Elixir strings are binary. same length may have different bites because of special characters. learn more on this.

Module constants can be used to hold data that can be used by any function within a module. It's defined at the top of the module and has the following syntax: `@constant_name [x, y]`

The file extension `.eex` stands for embedded elixir. The EEx module allows you to read .eex files and dynamically fill in the values. To use dynamic values in .eex templates you use the following syntax: `<%= data %>`

A comprehension is a shorthand expression for looping over enumberables. Commonly used in .eex templates.

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

