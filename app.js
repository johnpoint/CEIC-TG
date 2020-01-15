const superagent = require('superagent');
const cheerio = require('cheerio');
const fs = require('fs');

const reptileUrl = "http://www.ceic.ac.cn/speedsearch?time=1";


const botApi = "";// telegram bot token
const chatApi = ""; // telegram chat id

const tgUrl = "https://api.telegram.org/bot" + botApi + "/sendMessage?chat_id=" + chatApi;

superagent.get(reptileUrl).end(function (err, res) {
    if (err) {
        return
    }
    var arr = [];
    let $ = cheerio.load(res.text);
    $('td').each(function (i) {
        arr[i] = $(this).text();
    });
    fs.readFile(__dirname + '/data.json', function (err, data) {
        if (JSON.stringify(arr) == data.toString() || JSON.stringify(arr) == "[]") {
            console.log("pass");
        } else {
            fs.writeFile(__dirname + '/data.json', JSON.stringify(arr), function (err) {
                console.log("new alert");
                superagent.get(tgUrl + "&parse_mode=Markdown&text=" + encodeURIComponent("地震速报") + "%0A" +
                    encodeURIComponent("时间: " + arr[1]) + "%0A" + encodeURIComponent("等级: " + arr[0]) + "%0A" +
                    encodeURIComponent("位置: " + arr[5]) + "%0A" + encodeURIComponent("深度(km): " + arr[4])).end(function (err, res) {
                        console.log(res.text);
                    })
            })
        }
    })
});