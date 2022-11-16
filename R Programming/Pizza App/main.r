# homework 01
# chatbot(rule-based)
# ordering pizza

# All objects
main_menu = c("Create your pizza", 
              "Send an Order", 
              "Feedback", 
              "Membership")

#Create pizza objects
top = c("Hawaiian",
        "Pepperoni",
        "Veggie",
        "Meat Supreme")
top_price = c(50,50,30,100)
dft = data.frame(Topping = top, Price = top_price)

size = c('Small',
         'Medium',
         'Large',
         'X-Large')
size_price = c(100,150,200,300)
dfs <- data.frame(Size = size, Price = size_price)

crust = c('Pan',
          'Thin',
          'Stuffed-Crusted')
crust_price = c(0,0,50)
dfc <- data.frame(Crust = crust,Price = crust_price)

pizza_sel = c('Topping',
              'Size',
              'Crust',
              'Add to cart',
              'Empty cart',
              'Main menu')

user_sel = c('Choose topping',
             'Choose size',
             'Choose pizza crust')


#invoice objects
total_order = 0
invoice = data.frame(Order_ID = numeric(),
                   Topping = character(),
                   Size = character(),
                   Style = character(),
                   Price = numeric())
#Member objects
auth = rep('Please enter',2)
member = data.frame(member_id = 'admin',
                    member_password = '1234',
                    member_name = 'admin')
login = 0
login_id = character()

mb = function(){
      print('--------------------------')
      print('##### Member Benefit #####')
      print(paste(mem_discount,'% discount for all menu'))
      print('##### Non-Member Benefit #####')
      print(paste(non_mem_discount,'% discount for all menu'))
      print('--------------------------')
  }
mem_discount = 0
non_mem_discount = 0 #set % discount here
discount = 0


#selection objects
price_sel = c(Topping = 0, Size = 0, Crust = 0) 
price = 0
size_sel = 0
top_sel = 0
crust_sel = 0
conf = c('Confirm',
         'Cancel')
#cart
cart = data.frame(Topping = character(),
                  Size = character(),
                  Style = character(),
                  Price = numeric())
#feedback
feedback = data.frame(Date = character(),
                      Detail = character(),
                      Customer = character())

###################################################################
print("Welcome to Pizza Pizza")
#Get customer name
print("What's your name?")
cat('Name: ')
user_name <- readLines("stdin",n=1)
print(paste("Hi",user_name))


#create clist function
clist = function(v){
  cat(v,fill = 1,
      labels = paste("(", 1:length(v),"):"))
}
#empty cart function
emptycart <- function() {
  cart <<- data.frame(Topping = as.character(),
                  Size = as.character(),
                  Style = as.character(),
                  Price = as.numeric())
} 
#Main menu Function
menu <- function() {
  menu_sel <- 0
  while (2>1) {
    print(paste("How can I help you?",user_name))
    clist(main_menu)
    cat('Enter menu: ')
    menu_sel <- as.numeric(readLines('stdin',n=1))
    if (!(menu_sel %in% 1:4)) {
      print('Please enter number')
      menu()
  } else if (menu_sel == 1) {  #Create pizza
      orderpizza()
  } else if (menu_sel == 2) {  #Send order
      if( length(cart[,1]) > 0 ){
        print('Sending order')
        clist(conf)
        cat('Enter number: ')
        conf_sel = as.numeric(readLines('stdin',n=1))
        if (conf_sel == 1) {
          if (login == 0) {
            discount <<- non_mem_discount
          }
          total_order <<- total_order + 1
          print('###########################################')
          print('######## Your order has been sent! ########')
          print('###########################################')
          print(paste('## Time',Sys.time()))
          print(paste('## Order ID :',total_order))
          print('## Order Detail ##:')
          print(cart)
          total_price <- sum(as.numeric(cart[,4]))
          print(paste('Sub Total :',total_price))
          if (login == 1) { #Print total price for member
            print(paste(discount,'% Member discount :',
                        total_price*(0.01*discount)))
            print(paste('Total :',total_price*0.01*(100-discount)))
            print(paste('## Member ID:',login_id))
        } else { #print total price for non-member
            print(paste('Discount :',total_price*(0.01*discount)))
            print(paste('Total :',total_price*0.01*(100-discount)))
        }
            print('-------------------------------------------')
            print(paste('## Customer:',user_name))
            print('-------------------------------------------')
          for (i in 1:nrow(cart)) {
            invoice[nrow(invoice)+1,] <<- c(total_order,cart[i,])
          }
          #print(invoice)
          emptycart()
      }
      
    } else {  #Cart empty error
      print('Your cart is empty')
    }
  } else if (menu_sel == 3) {  #Send feedback
      print('Please type your feedback')
      user_fb <- readLines('stdin',n=1)
      print('Sending feedback')
      clist(conf)
      cat('Enter number: ')
      conf_sel = as.numeric(readLines('stdin',n=1))
      if (conf_sel == 1) {
        feedback[nrow(feedback)+1,] <<-c(as.character(Sys.time()),
                                         user_fb,user_name)
        print('Your feedback has been sent')
        print('Thank you for your feedback')
      }
      print(feedback)
      menu()
  } else if (menu_sel == 4 & login == 0) { # Member
      print('( 1 ): Log in')
      print('( 2 ): Register')
      print('( 3 ): Member Benefit')
      cat('Enter number: ')
      mem_sel <- readLines('stdin',n=1)
      if (mem_sel == 1 & login == 0) {
        print('#### Member Login ####')
        cat('Member ID: ')
        auth[1] <<- tolower(readLines('stdin',n=1))
        cat('Password: ')
        auth[2] <<- readLines('stdin',n=1)
        if (!(auth[1] %in% member$member_id)) { #if member is not in database
          print('Incorrect ID or password')
      } else { #if password is incorrect
          if (!(auth[2] == member[(member$member_id == auth[1]),2])) { 
            print('Incorrect ID or password')
        } else if (auth[2] == member[(member$member_id == auth[1]),2] &auth[1] == member$member_id[1]) { # ADMIN
            login <<- 2
            discount <<- mem_discount
            login_id <<- auth[1]
            user_name <<- member$member_name[member$member_id ==
                                             auth[1]]
            print('Welcome Admin')
        } else if (auth[2] == member[(member$member_id == auth[1]),2]) {#MEMBER
            login <<- 1
            discount <<- mem_discount
            login_id <<- auth[1]
            user_name <<- member$member_name[member$member_id == auth[1]]
            auth <<- rep('Please enter',2)
            print(paste('Welcome',user_name))
          }  
      }
    } else if (mem_sel == 2) {
        print('Member Registration')
        print('Please enter your ID')
        cat('ID: ')
        r_id <<- tolower(readLines('stdin',n=1))
        if ( r_id %in% member$member_id ) { 
          print('This ID is already being used')
      } else {
            print('Please enter your password')
            cat('Password: ')
            r_password <<- readLines('stdin',n=1)
            print('Please enter your name')
            cat('Name: ')
            r_name <<- toupper(readLines('stdin',n=1))
            member[nrow(member)+1,] <<- c(r_id,r_password,r_name)
            #print(member)
            print('Registration successful')
         }
    } else if (mem_sel == 3) {
        mb()
      }
  } else if (menu_sel == 4 & login == 1) { #Member logged in
      print('( 1 ): Member Benefit')
      print('( 2 ): Log out')
      cat('Enter number: ')
       mem_sel2 <- readLines('stdin',n=1)
       if (mem_sel2 == 1) {
         mb()
     } else if (mem_sel2 == 2) {
         print('You have logged out')
         user_name <<- character()
         login <<- 0
       }
  } else if (menu_sel == 4 & login == 2) { #Admin logged in
      print('( 1 ): Member Benefit')
      print('( 2 ): Log out')
      cat('Enter number: ')
      mem_sel2 <- readLines('stdin',n=1)
      if (mem_sel2 == 1) {
        print('( 1 ): Set member discount')
        print('( 2 ): Set non member discount')
        cat('Enter number: ')
        adm_sel <- readLines('stdin',n=1)
        if (adm_sel == 1) { #set member discount
          print('Set member discount(%)')
          cat('Enter number: ')
          mem_discount <<- as.numeric(readLines('stdin',n=1))
      } else if (adm_sel == 2) {
          print('Set non member discount(%)')
          cat('Enter number: ')
          non_mem_discount <<- as.numeric(readLines('stdin',n=1))
        }
    } else if (mem_sel2 == 2) {
       print('You have logged out')
       user_name <<- character()
       login <<- 0
      } 
  }
  }
}
#Orderpizza Fucntion
orderpizza = function() {
  goback = 0
  while (goback == 0){
    print('################ Your Cart ################')
    if (nrow(cart) == 0) {
      print('------------ Your cart is empty -----------')
    } else {
    print(cart)
    }
    print('###########################################')
    print('Create Pizza:')
    cat(user_sel,fill=1,labels = paste(pizza_sel,":"))
    print(paste('Price :',sum(price_sel)))
    print('-------------------------------------------')
    print("Create your pizza")
    clist(pizza_sel)
    cat('Enter number: ')
    pizza_cust <<- readLines("stdin",n=1)
    if (pizza_cust == 1) {                          #Select Topping
      print("Select Topping")
      print(dft)
      cat('Enter number: ')
      top_sel <<- as.numeric(readLines("stdin",n=1))
      if (!(top_sel %in% 1:length(top))) {
        print('Not available')
      } else {
        user_sel[1] <<- dft[top_sel,1]
        price_sel[1] <<- dft[top_sel,2]
      }
      
    } else if(pizza_cust == 2) {                    #Select Size
        print("Select Size")
        print(dfs)
        cat('Enter number: ')
        size_sel <<- as.numeric(readLines("stdin",n=1))
        if (!(size_sel %in% 1:length(size))) {
          print('Not available')
        } else {
            user_sel[2] <<- dfs[size_sel,1]
            price_sel[2] <<- dfs[size_sel,2]
          }
    } else if(pizza_cust == 3) {                    #Select Crust
        print("Select Style")
        print(dfc)
        cat('Enter number: ')
        crust_sel <<- as.numeric(readLines("stdin",n=1))
        if (!(crust_sel %in% 1:length(crust))) {
          print('Not available')
        } else {
            user_sel[3] <<- dfc[crust_sel,1]
            price_sel[3] <<- dfc[crust_sel,2]
          } 
    }  else if(pizza_cust == 4&                    #Add to cart
              user_sel[1]!='Choose topping' & 
              user_sel[2]!='Choose size' &
              user_sel[3]!='Choose pizza crust') {
      cart[nrow(cart)+1,] <<- c(user_sel,sum(price_sel))
      print('-------------------------------------------')
      print(paste("Added -",user_sel[2],tolower(user_sel[3]),
                  tolower(user_sel[1]),"- pizza to cart"))
      print('-------------------------------------------')
      #reset parameter
      size_sel <<- 0
      top_sel <<- 0
      crust_sel <<- 0
      user_sel <<- c('Choose topping',
                     'Choose size',
                     'Choose pizza crust')
    } else if (pizza_cust == 4) {                  #Add to cart failed
      print("Please choose all options")
    } else if (pizza_cust == 5) {                  #empty cart
      emptycart()
    } else {                                       #main menu
      goback = 1
      #menu()
    }
  }
}
menu()
