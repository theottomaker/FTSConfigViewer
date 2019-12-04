import requests

message_url = "https://raw.githubusercontent.com/theottomaker/FTSConfigViewer/master/webversion.txt"
response = requests.get(message_url)


if response:
    print("Success")
else:
    print("Failure")
            

#testtext = response.text()
#print(testtext)
