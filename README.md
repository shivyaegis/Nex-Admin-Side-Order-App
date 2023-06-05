# Skull

A sample order accepting project. This Project encapsulated the following main functions

## 1. Login / Sign-up


![WhatsApp Image 2023-06-05 at 22 56 27](https://github.com/shivyaegis/Flutter_project/assets/103941351/504c4fdd-603c-481e-9343-ba615fd89eb6)


![WhatsApp Image 2023-06-05 at 22 56 21](https://github.com/shivyaegis/Flutter_project/assets/103941351/57dd2ded-366b-488b-8fc7-8ffae3bbabec)


Login and signup using Firebase authenticated user. Proper messages will be displayed for incorrect attempts and Firebase is used to store authenticated (login details saved) users. After signing up they can log in using their email and password and all cases of misuse or errors are taken care by Firebase library and reported on the application screen. Pressing enter on sign in screen (after inputing details and still on password) you will be registered and if that is successful you will be automatically directed to next screen. A token is given to the concerned userID (but the scope of handling tokens is not of this project). 

Sample:   Email = abc@gmail.com
          Password = password


## 2. Customer Details


![WhatsApp Image 2023-06-05 at 22 56 21](https://github.com/shivyaegis/Flutter_project/assets/103941351/f9cfbee7-11a6-44d2-9dbe-2c8f05827093)


![WhatsApp Image 2023-06-05 at 22 56 28](https://github.com/shivyaegis/Flutter_project/assets/103941351/ae1794fd-0d36-4d86-a463-58706f7be3f3)


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


![WhatsApp Image 2023-06-05 at 22 56 21](https://github.com/shivyaegis/Flutter_project/assets/103941351/17b199e8-4e4b-4877-9aae-b9de3b76d6c8)

This contains a huge list. 
- Customer info
- Order choices
- Add/View Cart

You can figure what each stands for. There is also a number notifier on the view cart which tells you how many items are in cart. 


## 4. Confirming Order


https://github.com/shivyaegis/Flutter_project/assets/103941351/ac55bbd4-b000-48be-a390-13c9cae4d447

Order number will be shown which corresponds to the current order number, this updates each time you add something into your order and is in sync with deletion of orders as well. Each order is added individually and removed from the list as it gets added. You can press cancel order which will clear all orders currently given and send you back to 3. Orders.


## 5. Order List 


https://github.com/shivyaegis/Flutter_project/assets/103941351/e7da66f6-2be2-430b-b5fe-287345bdcae3

You can quickly view the orders for your current customer by pressing Fetch Customer. If not the hint in the text box shows you which customer ID you were placing the order to. Since this is more towards a business sided application, the user (owner/admin presumably) can also see the orders of other customers by fetching customers by their IDs (we have used simple IDs which are integers but improvement can be made on this, another improvement would be using Firebase rules that only let a user that has created a customer to modify records of that customer). 

Then you will get a list of all the orders, upon which you can delete any individual order and the list gets updated automatically and database will also get changed.


## Conclusion

So this is it for my first flutter project. I am really proud to have completed this project all by myself, there were no tutorials I was following for this and the only help I took was from Flutter documentation to figure out how different widgets and functions work and how to code this app into life. There are MANY flaws that I can see already like it is very hard-coded and the lack of segmentation and creating function blocks which can be callable instead of coding widgets every time. However, I would go towards improving these flaws in the new applications/projects I would be working on as well as creating a documentation for using this app.
