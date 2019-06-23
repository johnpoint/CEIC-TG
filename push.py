#import os
import telebot

TOKEN='874512892:AAH4BGxDYD9GCbNylKftLkd7KKgUc6AMhYE'
chatid='-1001429410193'

bot = telebot.TeleBot(TOKEN)
f = open('report','r')
text=f.readlines()
bot.send_message(chatid,text[0]+text[1]+text[2]+text[3],parse_mode='html')