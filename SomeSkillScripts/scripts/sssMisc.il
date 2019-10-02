procedure( SSSDivisors(number)
let( ( i (divs list()) )
    for( i 1 number
        when( remainder(number i) == 0 divs = append1(divs i) )
    )
    divs
);let
);procedure
