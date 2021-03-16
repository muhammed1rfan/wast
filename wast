#!/usr/bin/env python3
from sys import argv
from selenium import webdriver
import requests,argparse,re,urllib
from colorama import init
from colorama import Fore, Back, Style
from urllib.parse import urlparse
from urllib.request import urlopen
import urllib.request
import socket
global thepath,thepath2
thepath="x"
thepath2="x"
parser = argparse.ArgumentParser(description="WAST A simple Web Application Security Tool")
parser.add_argument("-u", metavar="url", help="provide the url of the site to be tested",  type=str)
args=parser.parse_args()
url=args.u

def portscanner(url):
    for i in (443,80,8080,8443,22,25,53,110,139,445):
        s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        ip=socket.gethostbyname(url.strip("https://"))
        port=i
        socket.setdefaulttimeout(1)
        result=s.connect_ex((ip,port))
        if result==0:
           print(Fore.GREEN+f"Port {port} is Open")

        s.close

 


def main():
    print(Fore.RED+"""


            WAST - Web Application Security Tool

                                                               
         Written  By muhammed1rfan
    """ )
        
    print(Fore.WHITE+f"Welcome to WAST Waiting for scanning {url}")
    try:
        request =requests.get(url)
        print(Fore.BLUE+"[*] Checking Whether the Website Exist")
        if request.status_code==200:
           print(Fore.GREEN+f"[+] The Web site {url} Exists")
          
    except:
          print(Fore.RED+f"[-] The Web site {url} Does not exist")
          exit()

    while True:

          print(Fore.BLUE+"[*] Please Select the tool You want to use")
          print(Fore.WHITE+"1.Directory BruteForcing")
          print("2.Subdomain Bruteforcing")
          print("3.Send Request and View Responses")
          print("4.Take ScreenShots Of Web pages")
          print("5.Get URLs from the WebPage")
          print("6.Path Traversal Attack Scanner")
          print("7.Open Redirect Attack Scanner")
          print("8.Port Scanner")
          tool = input("> ")
          if tool == "1":
             filename="words.txt"
             reader=open(filename)
             print(Fore.BLUE+f"[*] Checking For Paths in  {url}")
             for line in reader:
                 try:
                     
                     request2 = requests.get(url+"/"+line.rstrip())
                     if request2.status_code==200:
                        print(Fore.GREEN+line.rstrip())
                        
                 except:       
                         pass
            

          if tool =="2":
             filename="sub.txt"
             reader=open(filename)
             print(Fore.BLUE+f"[*] Checking For SubDomains in  {url}")
             for line in reader:
                 try:
                     
                     nurl = url.replace("www",line.rstrip())
                     request3 = requests.get(nurl.rstrip())
                     if request3.status_code==200:
                        print(Fore.GREEN+line.rstrip())
                        
                 except:
                        pass



          if tool=="3":
             method=input(Fore.BLUE+"[*]Which Request Method You Want to use 1.Get 2.Post 3.Head 4.Options : ")
             if method == "1":
                request4=requests.get(url)

             elif method == "2":
                  request4=requests.post(url)

             elif method == "3":
                  request4=requests.head(url)
             elif method == "4":
                  request4=requests.options(url)

             else:
                  print(Fore.RED+"[-]Please Provide the correct Number")
       
             try:
                  print(Fore.GREEN+"[+]The Response Headers")
                  print(request4.headers)
                  print(Fore.GREEN+"[+]The Response Body")
                  print(request4.text)

             except:
                       print(Fore.RED+"[-]Cannot Send Request")



          if tool == "4" :
             filename2=input(Fore.BLUE+"[*]Please Provide the Location of file that Contain Url's to take Screenshots: ")
             reader2=open(filename2)
             driver = webdriver.Chrome('/chromedriver_linux64/chromedriver')
            
             for line in reader2:
   
                 driver.get(line.rstrip())
                 curl=line.rstrip()
                 surl=curl.replace("/"," ")
                 screenshot = driver.save_screenshot(f'/Results/Screenshots/{surl}.png')
                
             
             print(Fore.GREEN+"[+]Images Saved In /Results/Screenshots Folder")
             driver.quit()   

         
          if tool == "5":
            print(Fore.BLUE+"[*]Checking For URLs in the WebSite")
            request4=requests.get(url)
            urlfinder=request4.text
            urls=re.findall('(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?',urlfinder)
            print(urls)
            rurl=url.replace("/"," ")
            for x in ("(",")",",","'","[","]"):
                urls=str(urls).replace(x,"")
            f=open(f'/Results/{rurl}"sURL.txt','w+')
            f.write(repr(urls))
            f.close()
            print(Fore.GREEN+f"[+]File Stored To wast/Results in Name {rurl}")

          if tool == "6":
             global thepath
             print(Fore.BLUE+"[*]Processing For Path Traversal Attack")
             filename="pathtraversal.txt"
             listener=open(filename)             
             try:
                 for line in listener:
                       path=line.rstrip()
                       request =requests.get(url+path+"etc/passwd")
                       if request.status_code==200:
                          print(Fore.GREEN+f"Found Path Traversal Attack")
                          thepath="y"
                       
                 
             except:
                    pass 
             
             if thepath=="x":
                        print(Fore.RED+f"[-]Cannot Find the Possible Payload or Path Traversal Does Not Exist")   

          if tool == "7":
             global thepath2
             print(Fore.BLUE+"[*]Processing For Open Redirect Attack")
             newurl=input("Provide the Url to be Redirected : ")
             filename="openredirect.txt"
             listener2=open(filename)             
             try:
                 for line in listener2:
                       redirect=line.rstrip()
                       redirect=redirect.replace("{payload}",newurl)
                       request =requests.get(url+redirect)
                       if request.status_code==302:
                          print(Fore.GREEN+f"Found Open Redirection Attack")
                          thepath2="y"
                       
                 
             except:
                    pass 
             
             if thepath2=="x":
                        print(Fore.RED+f"[-]Cannot Find the Possible Paramter or Open Redirect Does Not Exist")    
  
 
          if tool == "8":
             print(Fore.BLUE+"[*]Initialising Port Scanner")
             portscanner(url)
             print(Fore.GREEN+"Port Scan Completed Successfully")
                


    


if __name__ == "__main__":
   main()   



        

