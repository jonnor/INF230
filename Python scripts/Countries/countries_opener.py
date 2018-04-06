# -*- coding: utf-8 -*-
"""
Created on Tue Mar  6 15:15:05 2018

@author: Aleksander
"""

"""
This script file opens the textfile countryinfo.txt and extracts info
and creates .sql script files which can be used to create a database with country information
"""

""" set up all the lists and names that will be used later """
sql_script = [] # empty list to store the entire sql script
countries_script = []
cities_script = []
inhabitants_script = []
borders_script = []

""" Read and collect the necessary information from the .txt file"""
infile = open('countryinfo.txt','r')

for t in range(0,50): # skip the first 50 lines as they contain comments (bla bla bla)
    infile.readline() # simply reads a line without doing anything with it (skip)
    
header = infile.readline() # line 51 contains the headers, saves it in the variable header
header = header.rstrip().split('\t') # splits the header into a list. It is split using tab as a seperator (\t)

for i in range(len(header)): # adds a index number in front of each header for easier identification
    header[i] = str(i)+' '+header[i]
print(header) # prints the headers with the added numbers so they can be indexed easier

# creates the first INSERT INTO line and add them to each list
countries_insert_statement = 'INSERT INTO countries (countryID,name,area,capital) VALUES\n'
countries_script.append(countries_insert_statement)

cities_insert_statement = 'INSERT INTO cities (cityID,name,countryID) VALUES\n'
cities_script.append(cities_insert_statement)

inhabitants_insert_statement = 'INSERT INTO inhabitants (countryID,year_col,amount) VALUES\n'
inhabitants_script.append(inhabitants_insert_statement)

borders_insert_statement = 'INSERT INTO borders (countryID1,countryID2) VALUES\n'
borders_script.append(borders_insert_statement)


""" Go through each line and add the relevant information from each line to the correct list"""
cityID = 0 # bogus cityID number, will be counted up for each city.
starting_year = 1970 # when the historical inhabitants overview starts
end_year = 2015

for line in infile:
 
    sline = line.rstrip().split('\t')
    
    country_code = '"'+sline[0]+'"'
    country_name = '"'+sline[4]+'"'
    capital = '"'+sline[5]+'"'
    area = sline[6]
    population = sline[7]
    

    
    city_line = '({},{},{}),\n'.format(cityID,capital,country_code)
    cityID += 1
    cities_script.append(city_line)
    
    country_line = '({},{},{},{}),\n'.format(country_code,country_name,area,capital)
    countries_script.append(country_line)
    
    # borders needs a bit more work than city and country
    if len(sline)==18:
        border_list = sline[17].split(',')
    else:
        border_list = []
        
    for i in range(len(border_list)):
        border_line = '('+country_code+','+'"'+border_list[i]+'"'+'),\n'
        borders_script.append(border_line) 
    
    
    # create the historical population data (grow by 5% each year)
    year = end_year
    pops = int(population)
    while year>=starting_year:
        pops = pops*0.95
        year_line = '('+country_code+','+str(year)+','+str(int(pops))+'),\n'
        inhabitants_script.append(year_line)
        year -= 1
        
infile.close() # close the file as we are done working with it
""" Done reading and formatting the information from the .txt file """


# replace the final comma (,) with a semicolon (;) for each insert script
countries_script[-1]=countries_script[-1].rstrip().rstrip(',')+';' # replaces the comma at the end with ;
borders_script[-1]=borders_script[-1].rstrip().rstrip(',')+';' # replaces the comma at the end with ;
cities_script[-1]=cities_script[-1].rstrip().rstrip(',')+';' # replaces the comma at the end with ;
inhabitants_script[-1] = inhabitants_script[-1].rstrip().rstrip(',')+';' # replaces the comma at the end with ;


""" Write the information that we have collected from the .txt file into an sql file"""
outfile = open('countries.sql','w') # create a new file to write to ('w' indicates write)
outfile.writelines(countries_script) # write all lines from the list sql_script
outfile.close() # close the file as we are done with it.

outfile = open('borders.sql','w')
outfile.writelines(borders_script)
outfile.close()

outfile = open('cities.sql','w')
outfile.writelines(cities_script)
outfile.close()

outfile = open('inhabitants.sql','w')
outfile.writelines(inhabitants_script)
outfile.close()

# combined script
outfile = open('country_base.sql','w')

outfile.write('DROP DATABASE IF EXISTS countries_of_the_world;\n')
outfile.write('CREATE DATABASE IF NOT EXISTS countries_of_the_world;\n')
outfile.write('USE countries_of_the_world;\n')

#drops = 'Drop table if exists countries; drop table if exists borders; drop table if exists cities; drop table if exists inhabitants;\n\n'
create_country = 'CREATE TABLE countries\n(countryID CHAR(2),name VARCHAR(100),area INT,capital VARCHAR(100), PRIMARY KEY (countryID));\n\n'
create_borders = 'CREATE TABLE borders\n(countryID1 CHAR(2),countryID2 CHAR(2), PRIMARY KEY (countryID1,countryID2),CONSTRAINT FOREIGN KEY ID1FK (countryID1) REFERENCES countries(countryID), CONSTRAINT ID2FK FOREIGN KEY (countryID2) REFERENCES countries(countryID));\n\n'
create_cities = 'CREATE TABLE cities\n(cityID INT,name VARCHAR(100),countryID CHAR(2) NOT NULL,PRIMARY KEY (cityID), CONSTRAINT FOREIGN KEY (countryID) REFERENCES countries(countryID));\n\n'
create_inhabitants = 'CREATE TABLE inhabitants\n(countryID CHAR(2),year_col INT,amount INT, PRIMARY KEY (countryID,year_col),CONSTRAINT FOREIGN KEY (countryID) REFERENCES countries(countryID));\n\n'

#outfile.write(drops)
outfile.write(create_country)
outfile.write(create_borders)
outfile.write(create_cities)
outfile.write(create_inhabitants)

outfile.writelines(countries_script)
outfile.writelines(borders_script)
outfile.writelines(cities_script)
outfile.writelines(inhabitants_script)
outfile.close()
    