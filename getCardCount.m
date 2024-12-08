function [cardCount] = getCardCount(card_vector)
% calculates cardCount assuming ace is tracked as 1
    cardCount = 0;
    for i=1:length(card_vector)
        if ((mod(card_vector(i) - 20, 13)) >= 1 && (mod(card_vector(i) - 20, 13)) <= 10)
            cardCount = cardCount + mod(card_vector(i) - 20, 13);
        elseif (mod(card_vector(i) - 20, 13) > 10 || mod(card_vector(i) - 20, 13) == 0)
            % checks for face cards
            cardCount = cardCount + 10;
        end
    end

end