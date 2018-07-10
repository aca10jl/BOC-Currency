# setup socks5 proxy, uncomment if necessary
# import socks
# import socket
# socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, "127.0.0.1", 2912)
# socket.socket = socks.socksocket
# def getaddrinfo(*args):
#     return [(socket.AF_INET, socket.SOCK_STREAM, 6, '', (args[0], args[1]))]
# socket.getaddrinfo = getaddrinfo


# import required libraries
from bs4 import BeautifulSoup
from urllib import request
from urllib import parse
from pathlib import Path

import subprocess
import time
import os


# record start time
startTime = time.time()


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


# save currency data into a file
def retriveData(currency = 'GBP', pages = 51, delay = 5):
	tmp = None
	table = None
	for i in range(1, pages):
		# construct form data for properly loading HTML
		formData = {}
		formData['erectDate'] = ''
		formData['nothing'] = ''
		if currency == 'USD':  # USD=1316, GBP=1314
			formData['pjname'] = '1316'
		elif currency == 'GBP':
			formData['pjname'] = '1314'
		else:
			break
		formData['page'] = str(i)

		# seek for HTML table
		soup = readHTML(url = "http://srh.bankofchina.com/search/whpj/search.jsp", form = formData, encode = 'utf-8')
		div = soup.find('div', attrs = {'class':'BOC_main publish'})
		tmp = div.find('table')
		if table == tmp:
			break
		else:
			table = tmp

		# store results into a file
		storeData = 'Data/' + currency + '.csv'
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
		time.sleep(delay)

retriveData('USD')
retriveData('GBP')


# run R script to optimize data and present such data in a figure
subprocess.call (["/usr/bin/Rscript", "--vanilla", "Analysis.R"])


# record end time
endTime = time.time()
timeUsed = endTime - startTime


# show info after jobs are done
print('Done!')
print("Time used: %0.1fs" % timeUsed)

