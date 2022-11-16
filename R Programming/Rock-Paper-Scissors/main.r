#install dplyr
#install.packages("dplyr")
#library(dplyr)
#import function
source('function.r')
# Statistics
stat <- data.frame(Game_No = numeric(),
                   Date = character(),
                   Hand = character(),
                   Result = character(),
                   Streak = numeric(),
                   User = character())
gameno = 0
streak = 0
p = 0

print('Welcome to Rock Paper Scissors game')
print('Please enter your name')
username <- readLines('stdin',n=1)
menu()
