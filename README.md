# GPT3 Test
![Elixir](https://img.shields.io/badge/elixir-%234B275F.svg?style=for-the-badge&logo=elixir&logoColor=white)
![GitHub](https://img.shields.io/github/license/kevinam99/GPT3-First-Steps?color=blue)
![GitHub last commit](https://img.shields.io/github/last-commit/kevinam99/GPT3-kevinam99/GPT3-First-Steps)
   
**TODO: A lot!**
Somebody please tell me how to hide my API key :'(  
For now, I hid it in ```lib/secrets.exs``` and ignored it in .gitignore  

An Elixir client for using OpenAI's GPT3. I have used barebones API without any dependencies except Jason (to work with json) and HTTPoison (to make requests).

So far, I've worked with text classification that includes analysing sentiments and assessing whether a poll/survey answer is relevant to the surveyor. Have a look at [lib/gpt3-test](./lib/gpt3-test/).


### Getting started
1. Store your API key in ```lib/secrets.ex``` as,
```elixir
defmodule Secrets do
  defp api_key() do
    "xx-xxxxxx"
  end
end
```
2. Install the dependencies before running any file. Run
```console
mix deps.get
```

3. To run a test completion task, run 
```console
elixir lib/gpt3_test.ex
```


&nbsp; &nbsp; &nbsp; &nbsp; **Be sure you have Elixir and Mix installed!**

4. Each module can only be run by invoking the ```start``` function with an input query.  
<!-- Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/gpt3_test](https://hexdocs.pm/gpt3_test). -->

### Author
1. Kevin Mathew, <kevinam99.work@gmail.com>
    
    &nbsp; &nbsp; [![Twitter](https://img.shields.io/twitter/url/https/twitter.com/neverloquacious.svg?style=social&label=Follow%20%40neverloquacious)](https://twitter.com/neverloquacious)  
    &nbsp; &nbsp; [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](linkedin.com/in/kevin-a-mathew)




