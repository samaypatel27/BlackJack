card_scene = simpleGameEngine('retro_cards.png',16,16,4, [255, 255, 255]);
skipSprites = 20;
% sprites that are skipped since the first card is at the 21st index

money = 500;
% starting money amount for the player

fprintf("\n********************************************\n");
fprintf("Welcome to the VENETIAN RESORT LAS VEGAS! \nYour starting bet is $%i", money);

e_quest = "\nWhat structure notorious for its 3.97 degree tilt is the freestanding bell tower of a cathedral \nin its namesake Italian town? The structure's tilt comes from the soft ground of its unstable foundation." + ...
    "\n[a] Leaning Tower of Pisa" + ...
    "\n[b] The Eiffel Tower" + ...
    "\n[c] Shanghai Tower" + ...
    "\n[d] Burj Khalifa";
e_ans = "a";
% engineering question asked if the player runs out of money

playAgain = true;
% the game should be repetitive, unless the player opts out

while playAgain
    fprintf("\n********************************************\n");
    fprintf("CURRENT MONEY: $%i", money);
    fprintf("\nPress space bar to HIT");
    fprintf("\nPress s to STAND")
    % outputs keyboard functions for the player to play
    bet = input("\nHow much would you like to bet? ");
    while (bet > money)
        fprintf("\nINVALID BET. Please bet a lower number.");
        bet = input("\nHow much would you like to bet? ");
    end
    % traps user input if player bets more than their current balance

    deck = ones(1, 52);
    % generates a vector of number of 1 to 52, since there are 52 cards in
    % a deck

    c = 1;
    % variable to keep track of the indexes of the cards being used from
    % the deck vector

    shuffleOrder = randperm(52);
    % this vector shuffles the numbers of 1 to 52
    for i=1:52
        deck(i) = shuffleOrder(i) + 20;
        % assigns to card values
    
    end
    
  
    dealer_vector = [deck(c), 4];
    c = c + 1;
   
    player_vector = [0, 0];
    player_vector(1) = deck(c);
    c = c + 1;
    player_vector(2) = deck(c);

    % initalizes dealer and player vectors

    c = c + 1;
    matrix = ones(3,15);
    % creates a blank matrix
    
    total_playerCards = 2;
    total_dealerCards = 1;
    
    matrix(1,1:2) = dealer_vector(1,:);
    matrix(3,1:total_playerCards) = player_vector;
    % assigns player and dealer vector of cards to the matrix
    
    pCardCount = getCardCount(player_vector);
    temp_dealer_vector = dealer_vector(1);
    dCardCount = getCardCount(temp_dealer_vector);
    dealer_vector = temp_dealer_vector;
    % gets player and dealer card count by calling function, assuming ace
    % is 1
    
    pCardCount11 = getCardCount11(player_vector, pCardCount);
    dCardCount11 = getCardCount11(dealer_vector, dCardCount);
    % gets card count assuming ace is 11
    
    drawScene(card_scene, matrix);
    
    playerBust = false;
    playerStand = false;
    dealerBust = false;
    % variables initalized for loop to run

    p_min_value = 0;
    d_min_value = 0;
    p_max_value = 0;
    d_max_value = 0;
    % variables that keep track of player min/max value, based upon Ace
    % value
    

    while (~(playerBust) && ~(playerStand))
        key = getKeyboardInput(card_scene);
        if (key == "space")
            % checks if user hits space to "hit"
            player_vector(length(player_vector) + 1) = deck(c);
            % adds a new deck to the set
            c = c + 1;
            total_playerCards = total_playerCards + 1;
            matrix(3,1:total_playerCards) = player_vector;
            % updates the matrix output/user interface

            pCardCount = getCardCount(player_vector);
            pCardCount11 = getCardCount11(player_vector, pCardCount);
            % calculates the new hit value

            pause(0.5);
            
            drawScene(card_scene, matrix);
            % draws the updated scene with the new card after the player
            % hit
            p_min_value = min(pCardCount, pCardCount11);
            p_max_value = max(pCardCount, pCardCount11);
            % obtain min and max values, used at the end of the program


            if (p_max_value <= 21)
                pCardCount = p_max_value;
            elseif (p_min_value <= 21)
                pCardCount = p_min_value;
            else
                playerBust = true;
                
            end
            % above are conditional statements to check if the player
            % busted
        end
        if (key == "s")
            % player stands
            playerStand = true;
        end
        pause(1);
    end
    
    if (~(playerBust))
        % allows dealer to play if the dealer did not bust
        while ((dCardCount < 17) && (~(dealerBust)))
            % ensures the dealer keeps drawing cards (assuming ace is 1)
            % while also checking that the boolean, dealerBust, hasn't been
            % set to true yet
    
    
            dealer_vector(total_dealerCards + 1) = deck(c);
            % updates dealer cards
    
            c = c + 1;
            total_dealerCards = total_dealerCards + 1;
            matrix(1,1:total_dealerCards) = dealer_vector;
            % updates the matrix output/user interface

            dCardCount = getCardCount(dealer_vector);
            dCardCount11 = getCardCount11(dealer_vector, dCardCount);
            % updates both dealer card counts

            pause(0.5);
            drawScene(card_scene, matrix);
            % draws the updated scene with the new card after the player
            % hit
            
            d_min_value = min(dCardCount, dCardCount11);
            d_max_value = max(dCardCount, dCardCount11);
            % obtain min and max values, used at the end of the program
    
            if (d_max_value <= 21)
                dCardCount = d_max_value;
            elseif (d_min_value <= 21)
                dCardCount = d_min_value;
            else
                dealerBust = true;
                
            end
            % above are conditional statements to check if the dealer
            % busted
        end
    
    end
    
    p_min_value = min(pCardCount, pCardCount11);
    p_max_value = max(pCardCount, pCardCount11);
    d_min_value = min(dCardCount, dCardCount11);
    d_max_value = max(dCardCount, dCardCount11);
    % recalculates min and max value based upon updated CardCount /
    % CardCount11 values
    
    fprintf("\n_______________________________________________\n");
    % below are conditional statements that update the players betting
    % money and notify the player by outputting whether the player won or
    % lost

    if (playerBust)
        fprintf("You BUSTED HAHAHAHAHA. You lost $%i", bet);
        money = money - bet;
    elseif (dealerBust && ~(p_min_value == 21 || p_max_value == 21))
        fprintf("The dealer busted! You win $%i", bet);
        money = money + bet;
    
    elseif (p_min_value > d_min_value || p_max_value > d_min_value)
        if (p_min_value == 21 || p_max_value == 21)
            fprintf("You won with blackjack! You win $%i", floor(bet * 1.5));
            % winning with blackjack (card count of 21) results in 1.5 
            % times the money earned
            money = money + floor(bet * 1.5);
        
        else
            fprintf("You win! You got $%i", bet)
            money = money + bet;
        end
    
    elseif (p_min_value == d_min_value || p_max_value == d_min_value)
        fprintf("It's a tie!!!");
        
    else
        fprintf("The dealer wins! You lost $%i", bet)
        money = money - bet;
    end
    fprintf("\n_______________________________________________\n");
    fprintf("You current balance is: $%i", money);
    % prints new balance

    pause(1.5);
    if (money == 0)
        % gives player oppurunity to answer engineering question to redeem
        % money
        fprintf("\nYour broke LMAO. I'll give you a chance to earn some money." + ...
            " Here's an engineering question: ");
        fprintf(e_quest);
        answer = input("\nWhat's the answer? ", "s");
        if (answer == "a")
            fprintf("\n That is correct!");
            money = 500;
        else
            fprintf("\nHaha bozo. That's wrong. Exiting game...");
            playAgain = false;
        end
    end
    
    if (playAgain)

        play_again = input("\nDo you want to play another hand? (y/n): ", 's');
        % asks the player if they want to run the progrma again
        if play_again ~= 'y'
            fprintf("Thanks, your final balance is %i\n", money);
            playAgain = false;
        end
    end

end










