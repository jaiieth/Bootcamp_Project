# Black Jack Game
blackjack <- function() {
#newdeck function
  newdeck <- function(){
    hand <- c(2:10,'j','q','k','a')
    value<- rep(c(2:13,1),4)
    suit <- c(rep('spade',13),rep('club',13),
              rep('heart',13),rep('diamond',13))
    deck <- data.frame(hand=rep(hand,4),
                       suit= suit,value = value)
    #Set card value
    deck$value[deck$hand %in% c('j','q','k')] <- 10
    deck$value[deck$hand == 'a'] <- NA
    #Shuffle
    deck <- shuffle(deck)
    assign('deck',deck,envir =
             parent.env(environment()))
  }
#--------------------------------------------------#  
#deal function
  deal <- function() {
    card <- deck[1,]
    newdeck <- shuffle(deck[-1,])
    assign('deck',newdeck,envir= parent.env(environment()))
    return(card)
  }
#--------------------------------------------------#
#shuffle function
  shuffle <- function(x) {
    random <- sample(1:nrow(x),nrow(x))
    x[random,]
  }
#--------------------------------------------------#  
#draw function
  draw <- function() {
    card <- deal()
    if (is.na(card[3]) & value <= 10) {
      assign('value',value+11,envir =
               parent.env(environment()))
    } else if (is.na(card[3])) {
      assign('value',value+1,envir =
               parent.env(environment()))
    } else {
      assign('value',value+card[[3]],envir =
               parent.env(environment()))
    }
    print(paste0('You got ',toupper(card[1]),' ',
                toupper(substr(card[2],1,1)),
                tolower(substr(card[2],2,
                               nchar(card[2])))))
    print(paste('Total Value:',value))
    if (value > 21) {
      print('You lose')
      assign('d',0,envir=parent.env(environment()))
      menu()
    } else if (value == 21) {
      print('You got black jack')
      assign('d',0,envir=parent.env(environment()))
      menu()
    }
  }
#--------------------------------------------------#
#Start menu
stopn <- 0
  menu <- function(){
    newdeck()
    assign('value',0,
           envir= parent.env(environment()))
    while (stopn!=1) {
    print('Start game ?')
    cat('[Y/N]')
    start_sel <- tolower(readLines('stdin',n=1))
    if (!start_sel %in% c('y','n')) {
      next
    }
    else if (start_sel == 'y') {
      print('Draw a card ?')
      cat('[Y/N]')
      d <- tolower(readLines('stdin',n=1))
      if (d == 'y') {
        draw()
        return(value)
      }
    }
    else {
      print('Thank you for playing')
      stopn <<- 1
      s <<- 1
    }
    }
  }
menu()
  s <- 0
  while (value < 21 & s == 0 & stopn == 0) {
    print('Do you want to draw more?')
    cat('[Y/N]')
    draw_sel <- tolower(readLines('stdin',n=1))
    if (!(draw_sel %in% c('y','n'))) {
      next
    }
    else if (draw_sel == 'y') {
      draw()
    } else {
      print(paste('Your value:',value))
      if (value > 21) {
        print('You lose')
      } else if (value == 21) {
        print('You got black jack')
      }
      d <- 0
      s <- 1
      menu()
    }
  }
}

#start game
blackjack()
