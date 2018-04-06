#!/usr/bin/python
# PyGrabDavis DAVIS Weather Station Import/Export

# Knut Kvaal, NMBU 2015-2016
# Project INF120 / INF130

# Version: 0.2

# Revision history
# 3.24.15 Commandline arguments implemented
# Completed commandlines
# 3.25.15 Fixed blanks in solar and windspeed causing varchars as import
#         Fixed some Characters in windgust and rain
#         fIXED string in Bar trend attribute
# 3.26.15 Fixed na value before insert to database (replace -999)
# 3.27.15 Fixed '.' value before insert to database (replace -999)
#         Generic host
# 3.29.15 Fixed  (replace -999 to ,-999,)
# 4.01.15 Issue: Number 2 is never logged. m2 in strips. solar etc

# 4.03.15 Weather station number ID: WSID has to be implemented to be used
#         in lookup tables
# 11.4.15 -999 changed to NULL
# 15.4.15 -n/a changed to NULL
# 16.03.16 Fixed close()
# 18.03.16 Try for connections and insert rows. Cosmetics. 
#          Default values changed
#          Corrected problem with online when not disk
# 13.03.17 Converted to Python3 verdsion.
# 18.03.18 Restructured row parsing
# 18.03.18 More descriptive feedback during runtime
# 18.03.18 Possibility of running from and IDE (not from command line)
# 18.03.18 Renamed commaseperator to decimalseperator (clearification), variable name is still the same 
# 18.03.18 More comments

# Known issues;
# Duplicate keys may occur on csv.file if restarting script within 1 minute of stopping.

import urllib.request, urllib.parse, urllib.error
from bs4 import BeautifulSoup
import os
import time
from dateutil.parser import parse
import pymysql
import sys, getopt

def processURL(attributeList,sHeader,url,wsid):
    """
    Read the actual URL and let BeautifulSoup handle the rest
    """
    
    try:
        html = urllib.request.urlopen(url).read()
    except:
        print("No connection. Waiting 2 min to try again or stop..")
        time.sleep(float(120.0))
        html = urllib.request.urlopen(url).read()
        
    #soup = BeautifulSoup(html,"html5lib")      
    soup = BeautifulSoup(html,"lxml")
    
    # kill all script and style elements
    for script in soup(["script", "style"]):
        script.extract()    # rip it out

    
    # get text
    text = soup.get_text()
    
    # break into lines and remove leading and trailing space on each
    lines = (line.strip() for line in text.splitlines())
    
    # break multi-headlines into a line each
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    # drop blank lines
    text = '\n'.join(chunk for chunk in chunks if chunk)
    
    # Split the text into separate lines
    textlines=text.split('\n')
    
    # Find id line (index 2)
    
    translation_table = dict.fromkeys(list(map(ord, ',')), None)
    sCurrentCond = textlines[2].translate(translation_table)
    vDateKey = str(sCurrentCond.split("of ")[1:][0])
    header=[]
    attributeList=[]
    header.append('idtime;')    
    attributeList.append(vDateKey)
    # Weather station ID
    header.append('wsid;')
    attributeList.append(wsid)
    if 'Outside Temp'  in textlines:
        header.append('otemp;')
        outTemp=textlines.index('Outside Temp')
        translation_table = dict.fromkeys(list(map(ord, 'C %')), None)
        textlines[outTemp+1] = textlines[outTemp+1].translate(translation_table)
        vOutTemp=str(textlines[outTemp+1])
        attributeList.append(vOutTemp)

    
    if 'Outside Humidity'  in textlines:
        header.append('ohum;')
        outHum=textlines.index('Outside Humidity')
        translation_table = dict.fromkeys(list(map(ord, 'C %')), None)
        textlines[outHum+1] = textlines[outHum+1].translate(translation_table)
        vOutHum=str(textlines[outHum+1])
        attributeList.append(vOutHum)

    
    if 'Inside Temp'  in textlines:
        header.append('itemp;')
        inTemp=textlines.index('Inside Temp')
        translation_table = dict.fromkeys(list(map(ord, ' C')), None)
        textlines[inTemp+1] = textlines[inTemp+1].translate(translation_table)
        vInTemp=str(textlines[inTemp+1])
        attributeList.append(vInTemp)

    
    if 'Inside Humidity'  in textlines:
        header.append('ihum;')
        inHum=textlines.index('Inside Humidity')
        translation_table = dict.fromkeys(list(map(ord, 'C %')), None)
        textlines[inHum+1] = textlines[inHum+1].translate(translation_table)
        vInHum=str(textlines[inHum+1])
        attributeList.append(vInHum)

    
    if 'Wind Speed'  in textlines:
        header.append('windspeed;')
        windSpeed=textlines.index('Wind Speed')
        translation_table = dict.fromkeys(list(map(ord, ' m/shKTkt')), None)
        textlines[windSpeed+1] = textlines[windSpeed+1].translate(translation_table)
        vWindSpeed=str(textlines[windSpeed+1])
        attributeList.append(vWindSpeed)

    
    if 'Wind Gust Speed'  in textlines:
        header.append('windgust;')
        windGustSpeed=textlines.index('Wind Gust Speed')
        translation_table = dict.fromkeys(list(map(ord, ' m/sKTkh')), None)
        textlines[windGustSpeed+1] = textlines[windGustSpeed+1].translate(translation_table)
        vWindGustSpeed=str(textlines[windGustSpeed+1])
        attributeList.append(vWindGustSpeed)

    
    if 'Wind Chill'  in textlines:
        header.append('windchill;')
        windChill=textlines.index('Wind Chill')
        translation_table = dict.fromkeys(list(map(ord, ' C')), None)
        textlines[windChill+1] = textlines[windChill+1].translate(translation_table)
        vWindChill=str(textlines[windChill+1])
        attributeList.append(vWindChill)

    
    if 'Barometer'  in textlines:
        barometer=textlines.index('Barometer')
        header.append('barometer;')
        translation_table = dict.fromkeys(list(map(ord, 'hPamb')), None)
        textlines[barometer+1] = textlines[barometer+1].translate(translation_table)
        vBarometer=str(textlines[barometer+1])
        attributeList.append(vBarometer)

        
    if 'Bar Trend'  in textlines:
        barometer=textlines.index('Bar Trend')
        header.append('bartrend;')
        translation_table = dict.fromkeys(list(map(ord, ' ')), None)
        textlines[barometer+1] = textlines[barometer+1].translate(translation_table)
        vBarometer='"'+str(textlines[barometer+1])+'"'
        attributeList.append(vBarometer)
     
    
    if 'Heat Index'  in textlines:
        header.append('heatind;')
        heatIndex=textlines.index('Heat Index')
        translation_table = dict.fromkeys(list(map(ord, ' C')), None)
        textlines[heatIndex+1] = textlines[heatIndex+1].translate(translation_table)
        vHeatIndex=str(textlines[heatIndex+1])
        attributeList.append(vHeatIndex)

    
    if 'Dew Point' in textlines:
        header.append('dew;')
        dewPoint=textlines.index('Dew Point')
        translation_table = dict.fromkeys(list(map(ord, ' C')), None)
        textlines[dewPoint+1] = textlines[dewPoint+1].translate(translation_table)
        vDewPoint=str(textlines[dewPoint+1])
        attributeList.append(vDewPoint)

    
    if 'Wind Direction' in textlines:
        header.append('winddir;')
        windDirection=textlines.index('Wind Direction')
        translation_table = dict.fromkeys(list(map(ord, 'ENWS ')), None)
        #Degree sign in unicode. DO an encoding
        #http://stackoverflow.com/questions/9942594/unicodeencodeerror-ascii-codec-cant-encode-character-u-xa0-in-position-20
        textlines[windDirection+1] = textlines[windDirection+1].translate(translation_table)
        vWindDirection=textlines[windDirection+1].encode('utf-8').strip()

        # handle the vwindDirection string
        #\xa0\xc2 needs to be stripped first and last in string
        dum=vWindDirection[2:len(vWindDirection)-2]   
        # Convert to Python3 needs this as dum becomes a byte-string!
        dum=str(dum,'utf-8')
        
        #dum=int.from_bytes(dum,byteorder='big',signed=False)

        attributeList.append(dum.lstrip())

    
    if 'Solar Radiation' in textlines:
        header.append('solar;')
        solarRadiation=textlines.index('Solar Radiation')
        translation_table = dict.fromkeys(list(map(ord, ' Ww')), None)
        textlines[solarRadiation+1] = textlines[solarRadiation+1].translate(translation_table)
        vSolarRadiation=str(textlines[solarRadiation+1])
        # Take away /m2
        vSolarRadiation= vSolarRadiation.replace(' ', '')[:-3].upper()
        attributeList.append(vSolarRadiation)

    
    if 'UV Radiation' in textlines:
        header.append('uv;')
        uvRadiation=textlines.index('UV Radiation')
        translation_table = dict.fromkeys(list(map(ord, 'w')), None)
        textlines[uvRadiation+1] = textlines[uvRadiation+1].translate(translation_table)
        vUVRadiation=str(textlines[uvRadiation+1])
        # Take away /m2
        #vUVRadiation= vUVRadiation.replace(' ', '')[:-3].upper()
        attributeList.append(vUVRadiation)

    
    if 'Year' in textlines:
        header.append('rain')
        rain=textlines.index('Year')
        translation_table = dict.fromkeys(list(map(ord, 'm/Hour')), None)
        textlines[rain+2] = textlines[rain+2].translate(translation_table)
        vRain=str(textlines[rain+2])
        attributeList.append(vRain)
    
    
    sHeader=''.join(header)
    
    #http://www.tutorialspoint.com/python/time_strptime.htm
    # Transform to preffered date and time representation
    # Take this away if string for excel is wanted...
    # Excel imports the prefferd date as date fields
    #Default for MySQL_
    #http://stackoverflow.com/questions/14291636/what-is-the-proper-way-to-convert-between-mysql-datetime-and-python-timestamp
    timeStamp=attributeList[0]
    f = '%Y-%m-%d %H:%M:%S'
    #TimeStampD= parse(timeStamp).strftime('%c')
    TimeStampD= parse(timeStamp).strftime(f)
    
    #TimeStampD= parse(timeStamp).strftime('%c')
    attributeList[0]=TimeStampD
    
    return(attributeList,sHeader,textlines)

# MAIN PROGRAM

def main(argv):
    
    # Ideas from
    #http://stackoverflow.com/questions/328356/extracting-text-from-html-file-using-python
    #http://stackoverflow.com/questions/3925614/how-do-you-read-a-file-into-a-list-in-python
    
    # The Davis Weather Sations URL. More to find on weatherlink.com
    # View=summary - textbased summary
    # Headers=0 - No headers in page
    # type=1 - Metric measures
    # davisUrl = "http://www.weatherlink.com/user/nmbudavis/index.php?view=summary&headers=0"
    # davisUrl="http://www.weatherlink.com/user/krokeide/index.php?view=summary&headers=0"
    # davisUrl="http://www.weatherlink.com/user/frankekberg/index.php?view=summary&headers=0"
    # davisUrl="http://www.weatherlink.com/user/la5zo/index.php?view=summary&headers=0"
    # davisurl="http://www.weatherlink.com/user/gahchokue/index.php?view=main&headers=1&type=1"
    # davisUrl="http://www.weatherlink.com/user/evigil/index.php?view=summary&headers=0"
    # The table and database has to be established after first run of this program
    # Import data with phpMyAdmin to establish the tables before insert to database
    # Need to edig the database parameters for now..
    # usage: PyGrabDavis.py -u <urlfile> -o <outputfile> -c <sep> -d -i <inverval>
    #        -s <host> -t <table> -r < user> -p <password> -t <table>
    #        -b <database> -w <wstationid>

    # Usage: PyGrabDavis.py -u <urlfile> -o <outputfile> -c <sep> -d -i <inverval>
    # Parameters:   -u URL
    #               -o outputfile (csv)
    #               -c separator in csv file (, og .)
    #               -d database insert (db=davis, table=tdavis)
    #               -i interval sleep for refresh of URL
    #               -s host of MySQL server
    #               -t table of data in database
    #               -r user
    #               -p password
    #               -t table
    #               -b database
    #               -w weatherstation id (for lookup)
    # Initial default parameters
    interval=10.0 # wait interval in s for change of davisURL content
    #davisUrl = "http://www.weatherlink.com/user/heddal/index.php?view=summary&headers=0"
    davisUrl = "http://www.weatherlink.com/user/d10tagbina/index.php?view=summary&headers=0"
    #davisUrl = "http://www.weatherlink.com/user/ccolbran/index.php?view=summary&headers=0"
    registerOnline=False
    registerDisk=False
    wsID=0 # weather station ID
    table=''
    database=''
    user=''
    password=''
    # commaSeparator for Windows or Mac
    commaSeparator='.'
    outfile=''
    host='localhost'
    values=''
    header=''
    oldKey='' # flag for new event on davisUrl

    # read input list 
    try:
        opts, args = getopt.getopt(argv,"hu:o:c:di:r:t:b:p:s:w:",["urlfile=","outfile=","comma=","interval=","user=","passwd=","table=","database=","host=","wstationid"])
    except getopt.GetoptError as err:
        print(err)
        print('usage: PyGrabDavis.py -u <urlfile> -o <outputfile> -c <sep> -d -i <inverval> -s <host> -t <table> -r < user> -p <password> -t <table> -b <database> -w <wstationid>')
        sys.exit(2)

    # go through each input argument and store them in variables
    for opt, arg in opts:
        if opt == '-h': # display helt if -h tag is present
            print('usage: PyGrabDavis.py -u <urlfile> -o <outputfile> -c <sep> -d -i <inverval> -s <host> -t <table> -r < user> -p <password> -t <table> -b <database> -w <wstationid>')
            sys.exit()
        elif opt in ("-u", "--urlfile"):
            davisUrl = arg
            
        elif opt in ("-i", "--interval"):
            interval = arg
            if int(interval)<10:
                print("Don't check more often than each 10s")
                sys.exit(2)
            
        elif opt in ("-o", "--outfile"):
            outfile = arg
            
            registerDisk=True
        elif opt in ("-r", "--user"):
            user = arg
            
        elif opt in ("-p", "--passwd"):
            password = arg
            
        elif opt in ("-t", "--table"):
            table = arg
            
        elif opt in ("-w", "--wstationid"):
            wsID = arg
            
        elif opt in ("-b", "--database"):
            database = arg
            
        elif opt in ("-c","--comma"):
            commaSeparator = arg
            
        elif opt in ("-s","--host"):
            host=arg
            
        elif opt =='-d':
            registerOnline = True
            
    # print input summary
    print('\nLogging parameters summary')
    print('-'*40)
    print('URLfile: ', davisUrl)
    print('Weather Station ID:',wsID)

    print('')
    print('registerOnline:',registerOnline)
    if registerOnline:
        print('  Host:', host)
        print('  Database:',database)
        print('  User:',user)
        print('  Table:',table)
    print('')
    print('registerDisk:',registerDisk)
    if registerDisk:
        print('  Outputfile:', outfile)
    print('')
    print('Formatting and frequency')
    print('  Interval:',interval)
    print('  decimalSeparator:"',commaSeparator,'"')
    print('-'*40)
    print('')
    time.sleep(1)
    
    
    # try to connect to the database if on line logging is enabled
    if registerOnline:
        print("Trying to connect to",host)
        try:
            conn = pymysql.connect(host=host, port=3306, user=user, passwd=password, db=database)
            cur = conn.cursor()
            cur.execute("use "+database)
        except Exception as e:
            print("\nError: {} \nFailed. Check your connection parameters".format(e))
            sys.exit()
            
        print("Connection ok ;)\n")
        time.sleep(1)          
            
    
    # start the logging process
    while True:
        # Process the davisURL webpage and return values=table row values
        values,header,textlines=processURL(values,header,davisUrl,wsID)
        
        key=values[0] # use the date (first value) to prevent the same line beeing inserted multiple times
        
        if key==oldKey:
            print('Checking website, datetime is:',key)
        else:
            print('Checking website, datetime is:',key,'<---- NEW VALUE!!!')
        
        if key!=oldKey: # if there is a new datetime, write to disk/database
            print('')
            print("Datetime is unique (new). Trying to save a row.")
            #preprocess values
            
            # creating csv string
            csvsValues = ';'.join(str(e) for e in values)
            csvsValues = csvsValues.replace('Cal', '0') # 0 wind Calm replace 
            csvsValues = csvsValues.replace('.', commaSeparator)

            # creating database string
            dbsValues = ';'.join(str(e) for e in values[1:])
            dbsValues = dbsValues.replace('Cal', '0') # 0 wind Calm replace 
            dbsValues = dbsValues.replace(';', ',') # replace ; to , in string
            dbsValues = dbsValues.replace('na', 'NULL')
            dbsValues = dbsValues.replace('n/a', 'NULL')
            dbsValues = dbsValues.replace(',.,' ,',NULL,')
            sHeader=header[7:].replace(';',',')
            
            # Write to file
            if registerDisk:
                # Write the header if file not exists
                if not os.path.isfile(outfile):
                    print("No csv file detected, creating new one: {}".format(outfile))
                    f=open(outfile,'w')
                    f.write(header)
                    f.write('\n')
                    f.flush()
                    f.close()
                    time.sleep(1)
                
                print('  ->writing row to csv: {}'.format(outfile))
                fd = open(outfile,'a')
                fd.write(csvsValues)
                fd.write('\n')
                fd.flush()
                fd.close()
                time.sleep(1)
                                                    
            if registerOnline:
                print("  ->Writing to table {}.{}. SQL query:".format(database,table))
                
                sqlcmd="INSERT INTO "+table+" (idtime,"+sHeader+") VALUES ('"+values[0]+"',"+dbsValues+")"
                print(sqlcmd)
                try:
                    cur.execute(sqlcmd)
                    cur.execute("commit")
                    time.sleep(1)
                    print("  ->Insert successful")
                except Exception as e:
                    print(e)
                    print("Retrying insert")                        
                    conn = pymysql.connect(host=host, port=3306, user=user, passwd=password, db=database)
                    cur = conn.cursor()
                    cur.execute("use "+database)
            oldKey=key
            print('')     

        # Get out of the loop with Ctrl-c
        time.sleep(float(interval))
        
       

if __name__ == "__main__":
    
    answer='y'
    # if running from an IDE or with no input args, fill inn variables
    if len(sys.argv)==1:
        davisUrl = "http://www.weatherlink.com/user/woodbebetter/index.php?view=summary&headers=0&type=1"
        outfile = 'woodbebetter.csv'
        decimalSign = '.'
        registerOnline = True
        registerDisk = True
        interval = 10
        table = 'woodbebetter'
        database = 'testlogging'
        user = 'root'
        Password = 'inf130'
        host = 'localhost'
        wsID = 0
        
        print('you are running without any inputs, do you wish to use the following default values?')
        
        """
          -u <urlfile> -o <outputfile> -c <sep> -d 
          -i <inverval> -s <host> -t <table> -r < user> 
          -p <password> -t <table> -b <database> -w <wstationid>'
        """
        
        sys.argv.append('-u')
        sys.argv.append(davisUrl)
        if registerDisk:
            sys.argv.append('-o')
            sys.argv.append(outfile)
        sys.argv.append('-c')
        sys.argv.append(decimalSign)
        
        sys.argv.append('-i')
        sys.argv.append(interval)
        
        if registerOnline:
            sys.argv.append('-d')
            sys.argv.append('-b')
            sys.argv.append(database)
            
        sys.argv.append('-s')
        sys.argv.append(host)
        
        sys.argv.append('-t')
        sys.argv.append(table)
        
        sys.argv.append('-r')
        sys.argv.append(user)
        
        sys.argv.append('-p')
        sys.argv.append(Password)

        sys.argv.append('-w')
        sys.argv.append(wsID)
        
        for arg in sys.argv[1:]:
            print(arg)
            
        answer=input('y/n:\n')
        
        if answer=='y':
            main(sys.argv[1:])
        else:
            print('not running then, just be like that')
    else:
        # if run from the command line
        main(sys.argv[1:])

