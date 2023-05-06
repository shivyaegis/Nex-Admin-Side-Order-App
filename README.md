# Skull

A sample order accepting project. This Project encapsulated the following main functions

## 1. Login / Sign-up

![WhatsApp Image 2023-05-06 at 03 35 14](https://user-images.githubusercontent.com/103941351/236576284-18834900-3189-48bf-ad4d-dd0b6deee3af.jpg)

![WhatsApp Image 2023-05-06 at 03 35 45](https://user-images.githubusercontent.com/103941351/236576339-ef4d9b05-7a7c-4e62-8e8e-9c4eca071990.jpg)

Login and signup using Firebase authenticated user. Proper messages will be displayed for incorrect attempts and Firebase is used to store authenticated (login details saved) users. After signing up they can log in using their email and password and all cases of misuse or errors are taken care by Firebase library and reported on the application screen. Pressing enter on sign in screen (after inputing details and still on password) you will be registered and if that is successful you will be automatically directed to next screen.

## 2. Customer Details


https://user-images.githubusercontent.com/103941351/236576997-806321df-5043-4d9b-b3cf-137bd1de3b43.mp4


Customer details are input in the next screen from the login and sign-up page. There is an option to even import existing customer using their mobile number and gst while will be unique. In case no gst is provided it brings up the first registered customer with the given phone number. Thus we can fetch and register customers. A clear fields is given to Clear all the fields in case you get an unwanted entry. 

Customer details are taken as:

- First name
- Last name
- Company name
- [GST number](https://groww.in/p/tax/gstin)
- Phone number
- Email

After this we go to orders which is step 3

## 3. Orders


https://user-images.githubusercontent.com/103941351/236577764-76cccb8a-84b1-46f9-a6db-27fed75ddf08.mp4


This contains a huge list. 

- Customer info
- Order choices
- Add/View Cart

You can figure what each stands for. There is also a number notifier on the view cart which tells you how many items are in cart.

## 4. Confirming Order

// in developement
