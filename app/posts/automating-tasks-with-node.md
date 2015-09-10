Recently, a friend of mine approached me regarding a task he was regularly performing. Everyday when the market closed he would visit <a href='http://www.hl.co.uk/shares/stock-market-summary/ftse-100'>hl.co.uk</a>, copy the market summary data, manually sort and format said data and include it in a blog post on his companies website. He was curious if this process could be automated somehow and how easy it would be to write such a program.

## Why Node.js?

I like Node.js and believe JavaScript as a language is relatively easy to learn, understand and teach. I also felt that it was well suited to the task at hand. Lastly, I wanted to demonstrate how easy it would be to automate such a process and hopefully encourage my friend to lean how to code.

## Getting started

The script needed to perform the above requires only two `node_modules`:

    const cheerio = require('cheerio')
    const http = require('http')

<a href='https://github.com/cheeriojs/cheerio'>Cheerio</a> is <a href='http://jquery.com/'>jQuery</a> designed specifically for the server and will allow us to easily `find()` <a href='https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model'>DOM</a> nodes and retrieve their `text()` value. We'll be using the <a href='https://nodejs.org/api/http.html#apicontent'>http</a> module to actually `get()` the HTML content from the URLs.

## Putting it all together

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
