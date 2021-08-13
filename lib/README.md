# GPT3 First Flight
Since OpenAI doesn't allow for batch processing so I used Elixir's Task module to
implement concurrency while reducing the overall time taken for executing multiple queries. With this implementation, the test cases took a total of 3.6s to finish!  
Here's the test outline:  
| test name  | Size of input list | Number of API calls |  
|------------|--------------------|---------------------|
|Poll answer |2                   |2                    |
|Sentiment classification|2       |2                    |
|Content filtering|3              |3                    |

That's a total of 7 requests running concurrently which completed 
in  3.1s! 
![test time info](../output_imgs/tests.png "test time info")

**All inputs must be passed in a list, irrespective of the total number of inputs.**
## Classification
Here are the outputs I got for some test cases.
The inputs that I gave here are w.r.t our final year project which is a
social media based complaint aggregation system. This classifier, depending upon the text, will help us distinguish between a complaint and a feedback.

![Input in natural language](../output_imgs/classification.png "Input in natural language")

*This is for the input given in English along with some spelling and grammatical errors.  
Note that the errors didn't matter and the correct response was returned. Here, the third input was given with double negatives. A lexicon based analyser would've misinterpreted it with the weights, but GPT3 did not.  
The final input has a grammatical error as well as part of the input is in Konkani. The result still came out correct.*

## Poll answer classification
It so happens that you put out a well thought out poll/survey to get meaningful answers from your respondents but they don't take it seriously
and give vague or irrelevant answers toyour questions. Weeding them out manually can be a pain, time consuming and most importantly, a waste of time.

So here's a classifier that does most of the heavy lifting for you. Just pass in a list answer and see what it has to say!

!["Different poll answers and their result"](../output_imgs/classification-poll.png "Different poll answers and their result")

### Caveat(s)
1. Make sure the input you give is in fact relevant in some way to the poll. Any long answer input will be considered valid even if it is
irrelevant to the poll. Here's what I'm talking about


    !["Irrelevant input result"](../output_imgs/poll-irrelevant.png "Irrelevant input result")


## Content filtering
This API is used to filter text based content as safe, sensitive or unsafe. It works pretty well for commonly used NSFW words.
However, certain slangs are interpreted as unsafe. This filter is in beta, so there's possibility of high number of false positives
to appear. Here are the results


![content-filtering](../output_imgs/content-filter.png "content filtering at work")

Note: *Any opinions expressed here are random sentences taken from the internet ONLY for testing purposes. These are not to be construed as the opinions of the author of the repo nor that of OpenAI nor of GPT3.*

So you want to avoid showing those sentences that have been marked `unsafe` or if you want to implement a stricter policy, you can omit the ones marked `sensitive`.