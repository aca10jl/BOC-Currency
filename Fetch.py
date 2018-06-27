from bs4 import BeautifulSoup
import socks
import socket

# setup socks5 proxy
socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, "127.0.0.1", 2912)
socket.socket = socks.socksocket
def getaddrinfo(*args):
    return [(socket.AF_INET, socket.SOCK_STREAM, 6, '', (args[0], args[1]))]
socket.getaddrinfo = getaddrinfo

from urllib import request
from urllib import parse
import time
import os
from pathlib import Path


# read HTML file and optimize the results
def readHTML(url, encode = 'utf-8', form = None):
	if form == None:
		html = request.urlopen(url).read()
	else:
		data = parse.urlencode(form).encode(encode)
		html = request.urlopen(url, data).read()

	return BeautifulSoup(html, 'html.parser')


# convert HTML table into CSV-formatted data and store it into a file
def table2csv(htmlTable, header = True, csvFile = None, writeType = 'a'):
	csvTable = ''
	if header:
		th = htmlTable.find_all('th')
		for i in range(len(th)):
			if i != len(th) - 1:
				csvTable = csvTable + th[i].get_text() + ','
			else:
				csvTable = csvTable + th[i].get_text() + '\n'

	tr = htmlTable.find_all('tr')
	for i in range(1, len(tr) - 1): # len(tr) - 1 is only applied for BOC case to avoid an empty cell at the end of the table
		td = tr[i].find_all('td')
		for j in range(len(td)):
			if j != len(td) - 1:
				csvTable = csvTable + td[j].get_text() + ','
			else:
				csvTable = csvTable + td[j].get_text()
				if i != len(tr) - 1:
					csvTable = csvTable + '\n'
	
	if csvFile != None:
		f = open(csvFile, writeType)
		f.write(csvTable)

	return csvTable


# save USD data into a file
for i in range(1, 3):
	# construct form data for properly loading HTML
	formData = {}
	formData['erectDate'] = ''
	formData['nothing'] = ''
	formData['pjname'] = '1316' # USD=1316, GBP=1314
	formData['page'] = str(i)

	# seek for HTML table
	soup = readHTML(url = "http://srh.bankofchina.com/search/whpj/search.jsp", form = formData, encode = 'utf-8')
	div = soup.find('div', attrs = {'class':'BOC_main publish'})
	table = div.find('table')

	# store results into a file
	storeData = 'USD.csv'
	tableHeader = False
	if Path(storeData).exists():
		if os.stat(storeData).st_size == 0:
			tableHeader = True
		else:
			tableHeader = False
	else:
		tableHeader = True
	table2csv(table, header = tableHeader, csvFile = storeData)

	# add a delay into the loop to prevent from being banned
	time.sleep(5)


# save GBP data into a file
for i in range(1, 1):
	# construct form data for properly loading HTML
	formData = {}
	formData['erectDate'] = ''
	formData['nothing'] = ''
	formData['pjname'] = '1314' # USD=1316, GBP=1314
	formData['page'] = str(i)

	# seek for HTML table
	soup = readHTML(url = "http://srh.bankofchina.com/search/whpj/search.jsp", form = formData, encode = 'utf-8')
	div = soup.find('div', attrs = {'class':'BOC_main publish'})
	table = div.find('table')

	# store results into a file
	storeData = 'GBP.csv'
	tableHeader = False
	if Path(storeData).exists():
		if os.stat(storeData).st_size == 0:
			tableHeader = True
		else:
			tableHeader = False
	else:
		tableHeader = True
	table2csv(table, header = tableHeader, csvFile = storeData)

	# add a delay into the loop to prevent from being banned
	time.sleep(5)


print('Done!')

