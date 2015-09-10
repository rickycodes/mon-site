Recently, a friend of mine approached me regarding the automation of a task he was regularly performing. Everyday when the market closed he would visit <a href='http://www.hl.co.uk/shares/stock-market-summary/ftse-100'>hl.co.uk</a>, copy the market summary data, manually sort and format said data and then include it in a blog post on his companies website. He was curious if this process could be automated somehow and how easy it would be to write such a program.

## Why Node.js?

I like Node.js and believe JavasSript as a language is relatively easy to learn, understand and teach. I also felt that it was well suited to the task at hand. Lastly, I wanted to demonstrate how easy it would be to automate such a task and hopefully encourage my friend to lean how to code.

## Getting started

The script needed to perform the above requires only two `node_modules`.

    const cheerio = require('cheerio')
    const http = require('http')

    function wat() {
      lol()
    }
