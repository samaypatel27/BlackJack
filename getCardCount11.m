function [cardCountAce11] = getCardCount11(card_vector, pCardCount)
% calculates cardCount assuming ace is tracked as 11
    cardCountAce11 = 0;
    for i=1:length(card_vector)
        if ((mod(card_vector(i) - 20, 13) == 1))
            cardCountAce11 = 10;
        end
    end
    cardCountAce11 = cardCountAce11 + pCardCount;
    % adds already existing value, of ace being tracked as 1


end