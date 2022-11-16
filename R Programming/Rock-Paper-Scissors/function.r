#create clist function
clist = function(v){
  cat(v,fill = 1,
      labels = paste("(", 1:length(v),"):"))
}

#
menu <- function() {
  p <- 0
  menu <- 0
  while (p == 0) {
    print('### Main menu ###')
    print('( 1 ): Start game')
    print('( 2 ): Statistics')
    menu_sel <- readLines('stdin',n=1)
    if (!(menu_sel %in% c(1,2))) {
      print('Please enter number')
    } else if (menu_sel == 1) {
      game()
    } else {
      if (nrow(stat) > 0) {
        print(stat)
        Sys.sleep(1)
      } else {
        print('No stat found')
        Sys.sleep(1)
      }
    }
  }
}

#result function
win <- function() { 
  print('Result : Win')
  streak <<- streak+1
  result <<- 'Win'
  Sys.sleep(0.6)
}
lose <- function() {
  print('Result : Lose')
  streak <<- 0
  result <<- 'Lose'
  Sys.sleep(0.6)
}
draw <- function() {
  print('Result : Draw')
  result <<- 'Draw'   
  Sys.sleep(0.6)
}

#game function
game <- function() {
  goback <- 0
  hands <<- c('Rock','Paper','Scissors','Main Menu')
  com <<- numeric()
  user <<- numeric()
  save <- function() {    #create save function
  stat[nrow(stat)+1,] <<- c(gameno,as.character(Sys.time()),hands[user],result,streak,username)   
  }
  while (goback == 0) {
    print(paste('Streak : ',streak))
    Sys.sleep(0.6)
    print('Choose your hand')
    clist(hands)
    user <<- as.numeric(readLines('stdin',n=1))
    com <<- sample(c(Rock = 1, Paper = 2,Scissors = 3),1)
    gameno <<- gameno+1
    if (!(user %in% 1:4)) {
      print('Please choose your hand')
    } else if ( user == 1 ) {
        print(paste('Your hand :',hands[user]))
        print(paste("Com's hand :",hands[com]))
          Sys.sleep(0.6)
        if ( com == 1 ) {
          draw()
          save()
        } else if ( com == 2) {
          lose()
          save()
        } else {
          win()
          save()
        }
    } else if ( user == 2 ) {
        print(paste('Your hand :',hands[user]))
        print(paste("Com's hand :",hands[com]))
          Sys.sleep(0.6)
        if ( com == 1 ) {
          win()
          save()
        } else if ( com == 2) {
          draw()
          save()
        } else {
          lose()
          save()
        }
    } else if ( user == 3 ) {
        print(paste('Your hand :',hands[user]))
        print(paste("Com's hand :",hands[com]))
          Sys.sleep(0.6)
        if ( com == 1 ) {
          lose()
          save()
        } else if ( com == 2) {
          win()
          save()
        } else {
          draw()
          save()
        }
    } else {
      goback <- 1
      menu()
    } 
  }  
}
