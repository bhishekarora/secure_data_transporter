# Secure Data Transporter
Trasnport  entire discs/mount mounts/folders to remote systems securely (SSL/MD5/Hyper Threaded compression enabled)

<u>If you are looking to transport data to remote systems and need following features</u>

```sh
-Smallest transfer size of the  archive
-Maximum compression which your CPU supports
-Secured SSL Transfer (Mostly clients ask for it)
-Tamper proof Transfer with Hash checks to prevent MITM
-Dont want to install any agents or target system
-Dont have access/admin rights  on target system
-Want some thing quick and secured to transfer disc
-Want to know the BW for uplink and time to transfer first

```
## Architecture
![High level Architecture](https://github.com/bhishekarora/secure_data_transporter/blob/master/img/Architecture.jpg)


## 📜 How to get Started 

  


```sh
Clone it 
===============
git clone https://github.com/bhishekarora/secure_data_transporter.git
===============
You can do a Pre Flight Test  to see how much of **compression**  	your cpu will be able to do and how fast you can **encrypt** the data.

$ chmod +x *
$./preflight_checklist.sh


$ cd secure_data_transporter/sender
$chmod +x *
============================
$ sender/PaylodSender.sh        //  Sender side simple mode
$ sender/PaylodSender.sh -b      //  Sender side BW Test mode
===========================
## Go to receiver system and cd 
$ cd secure_data_transporter/receiver
$ chmod +x *
$ receiver/PayloadReceiver.sh      // Receiver side
$ receiver/PayloadReceiver.sh -b   // Receiver side BW Test mode
```
Follow prompts after the tool starts .

> ** Please note that if using bandwidth mode, port 9000 need to be allowed through firewall,  bandwidth server need this port to give
> up-link statistics.




##  Modes

There are two modes to run ?

 - Simple Mode
 Lets you send data without testing the Bandwidth between two systems
 
- Bandwidth Test mode
Will let you send data but also perform a bandwidth test between two systems to estimate the time required to complete the transfer.
  



Simple Mode
===========
![Demo run without BW Test](https://github.com/bhishekarora/secure_data_transporter/blob/master/img/PayloadSender.png)

BW Test Mode
===========
![Demo run with BW Test](https://github.com/bhishekarora/secure_data_transporter/blob/master/img/PayloadSender_BWmode.png)


## Demo Stats 
```
2 GB uncompressed to ⇒ 1.2 GB in 95 seconds 
Reduction in size  40%  

CPU info - 
Intel i3@2 Ghz Dell system
4 CPU * 2 cores (8 Threads) utilized while compression 

Encryption duration on above hardware  20 Sec
```
