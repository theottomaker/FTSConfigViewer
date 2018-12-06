# FTS Configuration Viewer
# ottO Bédard, MSc.
# Environment and Climate Change Canada
# 2018-12-05
# v2.2
# otto.bedard@canada.ca
# Developed for Water Survey of Canada for ease of reading configuration files from FTS H1/H2 data loggers

# v 2.2
# added Menu List and Version Checking capability


# GUI PROGRAMMING Work
import os
from shutil import copy
from appJar import gui

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

    app.setImage("LP",'star.gif')
    app.setImage("EV",'star.gif')
    
    app.setButtonState("Choose EVR.txt File","disabled")
    app.setButtonState("Process Files","disabled")


# Check the LP# File to see if it is good
def lp(btn):


    try:
        global evr_filename
        global lp_filename

        lp_filename = app.openBox("Choose FTS Config File","",[('FTS Config','*.xml')])  
        print('Attempting to Open: ' + lp_filename)
        file = open(lp_filename,'r')
        print('File Opened')

        # read the first line, so that we don't read it in later
        file.read()

        # We are good, so close the file and update the check boxes
        file.close()
        print('File Closed')
        # We read the file, so we can update the star to a check
        app.setImage("LP",'check.gif')
        app.setButtonState("Process Files","active")
        app.setButtonState("Choose EVR.txt File","active")


    except:
        print('Something went wrong!!!')
        # Somethign went wrong!
        app.setImage("LP",'x.gif')
        app.setButtonState("Process Files","disabled")


       
# This function will load the Visit Report File and see if it is good
def evr(btn):
   
    # Try to load the EVR File
    try:

        global evr_filename
        global lp_filename

        # Get the user to point us to the file
        evr_filename = app.openBox("Choose FTS End Visit Report","",[('FTS EVR','*.txt')])
        print('Attempting to Open: ' + evr_filename)
        # Open the file
        evr_file = open(evr_filename,"r")
        print('File Opened')
        # Read the file content as a check
        evr_file_content = evr_file.read()
        # print(evr_file_content)
        # CLose the file
        evr_file.close()
        print('File Closed')
        # We read the file, so we can update the star to a check
        app.setImage("EV",'check.gif')
            
    except:
        # Something went wrong!
        print("Something went wrong openning:" + evr_filename)
        # Change the image
        app.setImage("EV",'x.gif')
        # Disable the Process button
        app.setButtonState("Process Files","disabled")

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
        # Provide more information
        print('About')
    elif item == "Check Version":
        # Open the version checking dialog
        print('Version Check')
        
     
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


    # YOU ARE HERE!!!!
    # Something is wrong here!! Try to figure out how to see if the file exists!!

    if evr_filename is not '0':
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
    newfile.write('<?xml version="1.0" encoding="utf-8"?><?xml-stylesheet type= "text/xsl" href="FTSConfigViewer.xsl"?><XMLRoot>')
  
    # If there is NO EVR LOADED, SKIP THIS!!!

    if evr_filename is not '0':
        # Append the File with the NEW data
        newfile.write('<VisitReport ')
        newfile.write(''.join(evr_output))
        newfile.write('></VisitReport>')
        
    newfile.write(filecontent)

    # Close the file
    newfile.close()
      
    # Feedback
    print("Contents of newfile written!")

    # let's copy the style sheet to the correct folder
    pathname = os.path.dirname(newfilename)+ '/FTSConfigViewer.xsl'
    print('Copying stylesheet to: ' + pathname)
    copy('FTSConfigViewer.xsl',pathname)

    # open that file in the default program (web browser likely - hopefully!!!)
    print('Open new xml for viewing!')
    os.startfile(newfilename)


# Start an APP instance and the settings
app = gui("FTS Config Viewer")
app.setResizable(False)
app.setSticky("news")
app.setExpand("both")
#app.setFont(24)
app.setGuiPadding(20,20)
app.setBg("white")


# Add all the labels and the buttons

app.addLabel("title",'FTS Config Viewer',0,0,4)
app.getLabelWidget("title").config(font="Times 24")

app.addImage('WSC','wsc.gif',1,0,4)
app.addLabel("Nothing",'---------------------------------------------------------------------',2,0,4)


app.addButton("Choose LP#.xml File", lp, 3, 1)
app.addImage('LP','star.gif',3,0)
app.setButtonFont("LP","Verdana 18")

app.addButton("Choose EVR.txt File", evr,4,1)
app.addImage('EV','star.gif',4,0)

app.addLabel("Nothing2",' ',5,0,3)

app.addButton("Process Files", process,6,1)
app.addLabel("Nothing3",' ',7,0,3)

app.addButton("Reset", reset, 8,1)
app.addButton("Exit", exit,9,1)


app.addLabel("Instructions",'Load Logger Configuration File\n\n *Optional -- Load End Visit Report\n for supplemental information\n\n\nProcess File for viewing\n in web browser',3,3,rowspan=4)
app.setLabelBg("Instructions","white")
app.getLabelWidget("Instructions").config(font="Times 14")


# Start with disabled buttons for Processing and for the End Visit Report
app.setButtonState("Process Files","disabled")
app.setButtonState("Choose EVR.txt File","disabled")

# Add a menu for the help and version checking options
app.addMenuList("File",["Help","About","Check Version","-","Exit"],menuPress)

# Launch the APP
app.go()