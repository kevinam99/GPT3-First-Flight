# GPT3 First Flight
![Elixir](https://img.shields.io/badge/elixir-%234B275F.svg?style=for-the-badge&logo=elixir&logoColor=white)
![GitHub](https://img.shields.io/github/license/kevinam99/GPT3-First-Steps?color=blue)
![GitHub last commit](https://img.shields.io/github/last-commit/kevinam99/GPT3-First-Steps)
   
**TODO: A lot!**  
Succeeded in hiding the API key in lib/config/dev.exs  
I don't know what else could be done except adding more functionalities using the API.
An Elixir client for using OpenAI's GPT3. I have used barebones API without any dependencies except Jason (to work with json) and HTTPoison (to make requests).

Since OpenAI doesn't allow for batch processing so I used Elixir's Task module to
implement concurrency while reducing the overall time taken for executing multiple queries.
So far, I've worked with text classification that includes analysing sentiments and assessing whether a poll/survey answer is relevant to the surveyor. Have a look at [lib/gpt3_first_flight/](./lib/gpt3_first_flight/). Please head over to [lib/gpt3_first_flight/](lib/gpt3_first_flight/) for additional documentation. 

&nbsp; &nbsp; &nbsp; &nbsp; **Be sure you have Elixir and Mix installed!**

### Getting started
1. Store your API key in ```lib/config/dev.exs``` as,
```elixir
import Config

config :gpt3_first_flight, api_key: "xx-xxx"
```
A reference [./config/dev.exs.example](./config/dev.exs.example) has also been included.
2. Install the dependencies before running any file. Run
```console
MIX_ENV=dev mix deps.get
```

3. Compile
```console
MIX_ENV=dev mix compile
```

4. Run the tests 
```console
MIX_ENV=dev mix test
```

5. To run a test completion task, run 
```console
MIX_ENV=dev elixir lib/gpt3_first_flight.ex
```

6. Each module can only be run by invoking the ```start``` function with an input query.  **All inputs must be passed in a list, irrespective of the total number of inputs.**

Please head over to [./lib/gpt3_test_flight](./lib/gpt3_test_flight) for additional documentation. 
<!-- Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/gpt3_test](https://hexdocs.pm/gpt3_test). -->

### Author
1. Kevin Mathew, <kevinam99.work@gmail.com>
    
    &nbsp; &nbsp; [![Twitter](https://img.shields.io/twitter/url/https/twitter.com/neverloquacious.svg?style=social&label=Follow%20%40neverloquacious)](https://twitter.com/neverloquacious)
     <a href="https://www.linkedin.com/in/kevin-a-mathew/">
    <img src="https://img.shields.io/badge/linkedin-%230077B5.svg?&style=flat&logo=linkedin&logoColor=white" />
  </a>


