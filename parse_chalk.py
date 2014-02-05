from BeautifulSoup import BeautifulSoup
import csv, re

def parse(infile, writer, wk):
    soup = BeautifulSoup(infile.read())
    posts = soup.findAll('tr',attrs={'id':re.compile('^layer_')})
    for post in posts:
        details = list()
        temp = post.findAll('td')
        details.append(str(wk))
        details.append(temp[4].text)
        details = details + temp[5].text.split(' ')
        writer.writerow(details)

if __name__=='__main__':    
    outfile = open('data.txt','wb')
    writer = csv.writer(outfile)
    for wk in range(1,11):
        fname = '\\week{0}.txt'.format(wk)
        print fname
        infile = open(path + fname,'r')
        scrapeIt(infile, writer, wk)
        infile.close()
    outfile.close()
