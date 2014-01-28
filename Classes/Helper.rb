def bool_prompt(question)
    puts question + " (y/n)"
    bool_response = gets.chomp
    if bool_response == "y" || bool_response == "Y"
        return true
    end
    return false
end
    
