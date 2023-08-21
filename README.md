# Nex

A sample order accepting project. This Project encapsulated the following main functions

## 1. Login / Sign-up

<img src="https://github.com/shivyaegis/Flutter_project/assets/103941351/f0a41eb1-0b7a-48ff-9bc0-6529d90b4529" width="250" height="600">

<img src="https://github.com/shivyaegis/Flutter_project/assets/103941351/42e89d01-b630-4f47-be42-a8607a94f604" width="250" height="600">



Login and signup using Firebase authenticated user. Proper messages will be displayed for incorrect attempts and Firebase is used to store authenticated (login details saved) users. After signing up they can log in using their email and password and all cases of misuse or errors are taken care by Firebase library and reported on the application screen. Pressing enter on sign in screen (after inputing details and still on password) you will be registered and if that is successful you will be automatically directed to next screen. A token is given to the concerned userID (but the scope of handling tokens is not of this project). 

Sample:   Email = abc@gmail.com
          Password = password


## 2. Customer Details

<img src="https://github.com/shivyaegis/Flutter_project/assets/103941351/4d4c45a5-38d3-4d21-819c-0ecb3a6da4c0" width="250" height="600">


Customer details are input in the next screen from the login and sign-up page. There is an option to even import existing customer using their mobile number and gst while will be unique. In case no gst is provided it brings up the first registered customer with the given phone number. Thus we can fetch and register customers. A clear fields is given to Clear all the fields in case you get an unwanted entry. 

Sample:   Phone no = 1111111111

Customer details are taken as:

- First name
- Last name
- Company name
- [GST number](https://groww.in/p/tax/gstin)
- Phone number
- Email

After this we go to orders which is step 3 and the customer ID is retrieved before proceeding to this step.


## 3. Orders

<img src="https://github.com/shivyaegis/Flutter_project/assets/103941351/152cf012-7813-4e1c-b530-2dd04dc2a387" width="250" height="600">

<img src="https://github.com/shivyaegis/Flutter_project/assets/103941351/79fb53e5-da7d-42f0-b240-d444224b4bc0" width="250" height="600">



This contains a huge list. 
- Customer info
- Order choices
- Add/View Cart

You can figure what each stands for. There is also a number notifier on the view cart which tells you how many items are in cart. 


## 4. Confirming Order

<img src="https://github.com/shivyaegis/Flutter_project/assets/103941351/56c916ad-64ce-40e7-b01c-4af7081630b2" width="250" height="600">



Order number will be shown which corresponds to the current order number, this updates each time you add something into your order and is in sync with deletion of orders as well. Each order is added individually and removed from the list as it gets added. You can press cancel order which will clear all orders currently given and send you back to 3. Orders.


## 5. Order List 

<img src="https://github.com/shivyaegis/Flutter_project/assets/103941351/e4af149d-8986-4705-8f88-ca78ea83be72" width="250" height="600">



You can quickly view the orders for your current customer by pressing Fetch Customer. If not the hint in the text box shows you which customer ID you were placing the order to. Since this is more towards a business sided application, the user (owner/admin presumably) can also see the orders of other customers by fetching customers by their IDs (we have used simple IDs which are integers but improvement can be made on this, another improvement would be using Firebase rules that only let a user that has created a customer to modify records of that customer). 

Then you will get a list of all the orders, upon which you can delete any individual order and the list gets updated automatically and database will also get changed.


## Conclusion

So this is it for my first flutter project. I am really proud to have completed this project all by myself, there were no tutorials I was following for this and the only help I took was from Flutter documentation to figure out how different widgets and functions work and how to code this app into life. There are MANY flaws that I can see already like it is very hard-coded and the lack of segmentation and creating function blocks which can be callable instead of coding widgets every time. However, I would go towards improving these flaws in the new applications/projects I would be working on as well as creating a documentation for using this app.
