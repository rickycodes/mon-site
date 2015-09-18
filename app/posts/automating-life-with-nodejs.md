Recently, a friend of mine approached me regarding a "life" task he was regularly performing. Everyday when the market closed he would visit <a href='http://www.hl.co.uk/shares/stock-market-summary/ftse-100'>hl.co.uk</a>, copy the market summary data, manually sort and format said data and include it in a blog post on his companies website. He was curious if this process could be automated somehow and how easy it would be to write such a program.

## Why node.js?

I like <a href='https://nodejs.org/'>node.js</a> and believe JavaScript as a language is relatively easy to learn, understand and teach. I also felt that it was well suited to the problem at hand. (Obviously something similar could be written in python, C, whatever).

## Getting started

I'm going to use two `node_modules` to write this script, <a href='https://github.com/cheeriojs/cheerio'>Cheerio</a> and node's own http interface (_you could use a plethora of other <a href='https://www.npmjs.com/'>npm</a> modules here, I'm sure_):

    const cheerio = require('cheerio')
    const http = require('http')

<a href='https://github.com/cheeriojs/cheerio'>Cheerio</a> is (_basically_) <a href='http://jquery.com/'>jQuery</a> designed specifically for the server and will allow us to easily `find()` <a href='https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model'>DOM</a> nodes and retrieve their `text()` value. We'll be using the <a href='https://nodejs.org/api/http.html#apicontent'>http</a> interface to <a href='https://nodejs.org/api/http.html#http_http_get_options_callback'>`get()`</a> the HTML content.

The relevant URLs are:  
<a href='http://www.hl.co.uk/shares/stock-market-summary/ftse-100/risers'>`http://www.hl.co.uk/shares/stock-market-summary/ftse-100/risers`</a>  
<a href='http://www.hl.co.uk/shares/stock-market-summary/ftse-100/fallers'>`http://www.hl.co.uk/shares/stock-market-summary/ftse-100/fallers`</a>  
<a href='http://www.hl.co.uk/shares/stock-market-summary/ftse-aim-100/risers'>`http://www.hl.co.uk/shares/stock-market-summary/ftse-aim-100/risers`</a>  
<a href='http://www.hl.co.uk/shares/stock-market-summary/ftse-aim-100/fallers'>`http://www.hl.co.uk/shares/stock-market-summary/ftse-aim-100/fallers`</a>

eg:

    const http = require('http')
    const request = http.get('http://www.hl.co.uk/shares/stock-market-summary/ftse-100/risers', function (res) {
      var body = ''
      res.on('data', function (chunk) {
        body+= chunk
      }).on('error', function (err) {
        console.log(err.message)
      }).on('end', function () {
        console.log(body)
      })
    }).end()

The above will log out the entire HTML document @ <a href='http://www.hl.co.uk/shares/stock-market-summary/ftse-100/risers'>`http://www.hl.co.uk/shares/stock-market-summary/ftse-100/risers`</a> to the console:

<img src='/posts/images/example-01.gif' />

If we look at the 4 relevant URLs, we notice that the only distinguishing features between them are the last two segments: `/ftse-100/` or `/ftse-aim-100/` and `risers` or `fallers`

We'll use node's <a href='https://nodejs.org/api/process.html#process_process_argv'>`process.argv`</a> so we can pass arguments to the script to dynamically build target URLs:

    const kind = {
      '100': 'ftse-100/',
      'aim': 'ftse-aim-100/'
    }

    const url = 'http://www.hl.co.uk/shares/stock-market-summary/' + kind[process.argv[2]] + process.argv[3]

    console.log('target URL is: ' + url)

## Putting it all together:

    const cheerio = require('cheerio')
    const http = require('http')
    const chalk = require('chalk')

    if(process.argv.length != 4) {
      console.log(chalk.red('Two arguments required!\nExample arguments: `aim risers`'))
      process.exit(1)
    }

    const kind = {
      '100': 'ftse-100/',
      'aim': 'ftse-aim-100/'
    }

    const url = 'http://www.hl.co.uk/shares/stock-market-summary/' + kind[process.argv[2]] + process.argv[3]

    console.log(chalk.yellow('wait for it...'))

    const request = http.get(url, function (res) {
      var body = ''
      res.on('data', function (chunk) {
        body+= chunk
      }).on('error', function (err) {
        console.log(err.message)
      }).on('end', function () {
        output(body)
      })
    }).end()

    function output (body) {
      const $ = cheerio.load(body)
      const $table = $('[summary="Market index"]')
      const items = []
      const up_down = (process.argv[3] === 'risers') ? '+' : '-'
      const highlight = (process.argv[3] === 'risers') ? chalk.green : chalk.red
      const amount = 5

      if(!$table.find('tr').length) {
        console.log(chalk.red('There are currently no ' + process.argv[3]))
        return
      }

      $table.find('tr').each(function (i, v) {
        if(i > 0) {
          items.push({
            name: $(this).find('td:nth-child(2)').text().replace(' plc', ' Plc'),
            price: $(this).find('td:nth-child(3)').text(),
            change_amount: $(this).find('td:nth-child(4)').text(),
            change_percent: $(this).find('td:nth-child(5)').text().replace(up_down, '').replace('%', '')
          })
        }
      })

      items.sort(function (a, b) {
        return a.change_percent - b.change_percent
      }).reverse().slice(0, amount).forEach(function (v, i) {
        console.log(chalk.bold(chalk.cyan(v.name)) + ' ' + highlight(v.change_amount + ' (' + up_down + v.change_percent + '%) ') + chalk.bold(v.price))
      })
    }
