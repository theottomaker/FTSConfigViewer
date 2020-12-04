# FTS Configuration Viewer
# ottO Bédard, MSc.
# Environment and Climate Change Canada
# otto.bedard@canada.ca
# Developed for Water Survey of Canada for ease of reading configuration files from FTS H1/H2 data loggers

# v2.5 2020-12-04
# changed local .xsl to github repository for FireFox fix and long term adaptability.

# v2.3/4 added none-FTP version checking
# 2019-12-04

# v 2.2 # added Menu List and Version Checking capability


# GUI PROGRAMMING Work
import os
from ftplib import FTP
from shutil import copy
from appJar import gui

import requests


global evr_filename
evr_filename = '0'
global lp_filename
lp_filename='0'


# Exit Button Process
def exit(btn):
    # Exit the program
    app.stop()

# Reset Button process
def reset(btn):
    # Reset the filenames, change images, and diable buttons
    global evr_filename
    evr_filename='0'
    global lp_filename
    lp_filename='0'

    # Reset the options, and update the colours
    app.setButtonState("Load End Visit Report","disabled")
    app.setButtonState("View Summary","disabled")
     
    app.setButtonState("Load Logger LP#.xml","active")

    app.setButtonFg("Load Logger LP#.xml","black")
    app.setButtonFg("Load End Visit Report","black")
    app.setButtonBg("Load Logger LP#.xml","whitesmoke")
    app.setButtonBg("Load End Visit Report","whitesmoke")


# Check the LP# File to see if it is good
def lp(btn):


    try:
        global evr_filename
        global lp_filename

        lp_filename = app.openBox("Choose FTS Config File","",[('FTS Config File','*.xml')])  
        print('Attempting to Open: ' + lp_filename)
              
        #Check for empty file!
        exists = os.path.isfile(lp_filename)
        
        if exists:
            

            file = open(lp_filename,'r')
            print('File Opened')

            # read the first line, so that we don't read it in later
            file.read()

            # We are good, so close the file and update the check boxes
            file.close()
            print('File Closed')

            # We read the file, so we can update the button colour
            app.setButtonFg("Load Logger LP#.xml","green")

            # Enable the next steps in the workflow
            app.setButtonState("Reset","active")
            app.setButtonState("Load End Visit Report","active")
            app.setButtonState("View Summary","active")
        
        else:
            # Oh dear, they didn't load anything
            print("no file selected")
            app.infoBox("Information","Please select an FTS datalogger .xml configuration file.")   


    except:
        
        # Something went wrong!
        print("Something went wrong opening:" + lp_filename)
        
        # Change the button colours
        app.setButtonFg("Load Logger LP#.xml","red")

        # Disable the Process button
        app.setButtonState("View Summary","disabled")

        # Through a pop up with an error
        app.errorBox("Error!","An error has occured in loading the file.\nPlease select Reset and start over.\n\n Thanks")
      
# This function will load the Visit Report File and see if it is good
def evr(btn):
   
    # Try to load the EVR File
    try:

        global evr_filename
        global lp_filename

        # Get the user to point us to the file
        evr_filename = app.openBox("Choose FTS End Visit Report","",[('FTS EVR','*.txt')])
        print('Attempting to Open: ' + evr_filename)
        
        #Check for empty file!
        exists = os.path.isfile(evr_filename)
        
        if exists:
            # We have a file, Load er up
            print("file selected")

            # Open the file
            evr_file = open(evr_filename,"r")
            print('File Opened')
            # Read the file content as a check
            evr_file_content = evr_file.read()
            # print(evr_file_content) # for debugging
            # CLose the file
            evr_file.close()
            print('File Closed')
        
            # We read the file, so we can update the button colour
            app.setButtonFg("Load End Visit Report","green")

        else:
            # Oh dear, they didn't load anything
            print("no file selected")
            app.infoBox("Information","Please select an End Visit Report to use this feature.") 
            # Change the colour to red to indicate that they didn't load anything
            app.setButtonFg("Load End Visit Report","red")

        
            
    except:
        # Something went wrong!
        print("Something went wrong opening:" + evr_filename)
        
        # Change the button colours
        app.setButtonFg("Load End Visit Report","red")
        app.setButtonFg("Load Logger LP#.xml","red")
        # Change the button colours
        app.setButtonBg("Load End Visit Report","red")
        app.setButtonBg("Load Logger LP#.xml","red")

        # Disable the buttons to make the user start over
        app.setButtonState("View Summary","disabled")
        app.setButtonState("Load Logger LP#.xml","disabled")
        app.setButtonState("Load End Visit Report","disabled")



        # Through a pop up with an error
        app.errorBox("Error!","An error has occured in loading the file.\nPlease select Reset and start over.\n\nThanks")

# Menu Processiong
def menuPress(item):
    
    # Figure out which button was pushed, then complete the corresponding request
    if item == "Help":
        # Open the help document
        os.startfile("User_Manual.pdf")
    elif item == "Exit":
        # Exit the program
        app.stop()
    elif item == "About":
        # Provide more information to the user
        app.infoBox("About","This software package was developed specifically for the Water Survey of Canada," +
            "a division of Environment and Climate Change Canada.\n\n" + \
            "This software has no license restrictions and is used at your own risk.\n\n" + \
            "Special thanks to all the technicians that took the time to test and provide feedback for the development.\n\n\n"+\
            "For comments or improvement ideas, contact the developer\nottO Bedard, Hydrometric Technologist\nNorth Bay, Ontario, Canada\notto.bedard@canada.ca")

    elif item == "Check Version":
        # Try to go to GITHUB and get a web version for checking against
        try:


            # 2020-12-04 Remove the stylesheet checking, as it is now just on the web in GITHUB
            
            message_url = "https://raw.githubusercontent.com/theottomaker/FTSConfigViewer/master/webversion.txt"
            response = requests.get(message_url)
            webversion = response.content.decode('Windows-1252')
            # split up the webfile into what we need

            weblines = webversion.splitlines()
            webprogramver = float(weblines[0])
            #webstylever = float(weblines[1])

            # Read the local file now and do a comparison
            # Determine if an update is needed
            lfile = open('version.txt','r')
            #print(lfile) # For debugging
            curprogramver = float(lfile.readline())
            #curstylever = float(lfile.readline())
            lfile.close()
                        
            print("Installed Program Version: ", curprogramver)
            #print("Installed Stylesheet Version: ",curstylever)

            print("Available Program Version: ", webprogramver)
            #print("Available Stylesheet Version: ",webstylever)

            # Do the comparison and determine the outcome
            # Create a message for the user
            usermessage = ""

            if webprogramver > curprogramver:
                # update to main program needed
                usermessage = usermessage + "Main Program Update Required \n    - Please update from version " + str(curprogramver) + " to version " + str(webprogramver) + "\n\n"
            else:
                usermessage = usermessage + 'You are using the most current version of the main program \n\n'


            #if webstylever > curstylever:
                # update to Style Sheet
            #    usermessage = usermessage + 'Stylesheet Update Recommended \n    - Please update from version ' + str(curstylever) + ' to version ' + str(webstylever) + '\n\n'
            #else:
            #    usermessage = usermessage + 'You are using the most current version of the stylesheet \n\n'
        
            usermessage = usermessage + "Please visit the WSC Atlassian Site for the most to date versions"


            print('Comparison complete')
            #print(mainupdate,styleupdate)

            #display the message
            app.infoBox("Version Check Results",usermessage)
            
        
        except:
            # Give an error window
            app.errorBox("Version Checking Error","Version checking encountered an error and did not complete.")
            print('Error!!!')
                         
# The actual processing of the files
def process(btn):
    
    global evr_filename
    global lp_filename

    # indicate where we are at
    print('Processing the files')
    
    # Check for the C:\Temp directory, if not make it
    # We are storing the files the user sees in this directory
    if not os.path.isdir('C:\\temp\\FTSViewer\\'):
        # Let's make a dir
        print('Creating C:\\temp\\FTSViewer\\')
        os.makedirs('C:\\temp\\FTSViewer\\')

    # It is possible that users want to just process the file with the LP config, and not both the EVR
    # We need to check for one of two cases, either just LP, or BOTH, it can't just be EVR.

    if os.path.isfile(evr_filename):
        # Call the EVR Function
        
        # Read in the End Visit Report EVR
        print('Attempting to Open: ' + evr_filename)
    
        # list of information that we want out of the file
        searchitems = ['Logger Model:','Logger Version:','Serial Number:','OS Version:','Software Version:','Serial#:','SW Ver:','Device Type:','Standard:','Antenna Bearing:','Antenna Inclination:']
    
        # make a output file for when we find the test we want
        evr_output=[]

        # Point the program to the file, and open it for reading
        with open(evr_filename, "r") as f:
            #Read in the file
            searchlines = f.readlines()
    
        # a simple counter
        count=0

        # Cycle through the lines of the file
        for i, line in enumerate(searchlines):
        
    
            # Look for any of the words in the list
            for word in searchitems:
       
                if word in line: # We found one of the search items
            
                    # Build up the output, without the \n, for the final output
                    # we are going to develop some xml here

                    current_output = line.split(":",1)
                    leftout = current_output[0]
                
                    # We have to do some extra in case the word has #
                    # if not, just do it regularly
                    leftout = leftout.replace("Serial#","Serial")

                    #print(leftout)
                
                    # It is possible to have two instances of "Device Type" and xml doesn't like that
                    if leftout.find("Device Type") != -1:
                        # found one, up the count
                        count += 1
                        #print (count)

                        if count==2:
                            # We have a second instance of Device Type
                            # add a 2 to the end of the device type
                            leftout=leftout + '2'

                    # create the attribute information
                    rightout = "\"" + current_output[1].strip() + "\" "


                    # Add the tag to the file
                    evr_output.append(leftout.replace(" ","") + "=" + rightout)

        # Close the file
        f.close()

        # WE HAVE THE EVR, now we need the LP# data    

    # Read in the file and do the edit
    
    file = open(lp_filename,'r')
    print('File Opened')

    # read the first line, then the second line, so that we don't read it in later
    file.readline()
    file.readline()
    # Now read the rest of the file
    filecontent = file.read()
    print('Contents read')
    # Close the file
    file.close()
    print('File closed')

    # Add the line we need to the file, then append the openned LP#.xml
    # create a name based on the original filename
        
    newfilename = 'C:\\temp\\FTSViewer\\' + os.path.basename(lp_filename)
    newfilename = newfilename[0:len(newfilename)-4]
    newfilename = newfilename + "_FTSConfigViewer.xml"
    print('Creating newfile: ' + newfilename)
        
    # open the newfile and add the first few new lines
    newfile = open(newfilename,'w')
    newfile.write('<?xml version="1.0" encoding="utf-8"?><?xml-stylesheet type= "text/xsl" href="https://raw.githubusercontent.com/theottomaker/FTSConfigViewer/master/FTSConfigViewer.xsl"?><XMLRoot>')
  
    # If there is NO EVR LOADED, SKIP THIS!!!

    if os.path.isfile(evr_filename):
        # Append the File with the NEW data
        newfile.write('<VisitReport ')
        newfile.write(''.join(evr_output))
        newfile.write('></VisitReport>')
        
    newfile.write(filecontent)

    # Close the file
    newfile.close()
      
    # Feedback
    print("Contents of newfile written!")

    # 2020-12-04 We can remove this, as we are using a GITHUB RAW File
    # let's copy the style sheet to the correct folder
    # pathname = os.path.dirname(newfilename)+ '/FTSConfigViewer.xsl'
    # print('Copying stylesheet to: ' + pathname)
    # copy('FTSConfigViewer.xsl',pathname)

    # open that file in the default program (web browser likely - hopefully!!!)
    print('Open new xml for viewing!')
    os.startfile(newfilename)

# Start an APP instance and the settings
app = gui("FTS Config Viewer")
app.setFont("Verdana 12")
app.setResizable(False)
app.setSticky("news")
app.setExpand("both")
#app.setFont(24)
app.setGuiPadding(20,20)
app.setBg("white")

# Add all the labels and the buttons
app.addLabel("title",'FTS Config Viewer')
app.getLabelWidget("title").config(font="Verdana 24")
app.addLabel("Nothing0",'')

app.addImage('WSC','wsc.gif')
app.addLabel("Nothing1",'')

app.addButton("Load Logger LP#.xml", lp)

app.addButton("Load End Visit Report", evr)


app.addLabel("Nothing2",' ')

app.addButton("View Summary", process)
app.addLabel("Nothing3",' ')

app.addButton("Reset", reset)
app.addLabel("Nothing4",' ')
app.addButton("Exit", exit)

# Start with disabled buttons for Processing and for the End Visit Report
app.setButtonState("View Summary","disabled")
app.setButtonState("Reset","disabled")
app.setButtonState("Load End Visit Report","disabled")

# Add a menu for the help and version checking options
app.addMenuList("File",["Help","About","Check Version","-","Exit"],menuPress)

# Launch the APP
app.go()