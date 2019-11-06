procedure( SSSDivisors(number)
let( ( i (divs list()) )
    for( i 1 number
        when( remainder(number i) == 0 divs = append1(divs i) )
    )
    divs
);let
);procedure

procedure( SSSGetUnique(elements)
let( ( (uelemnts list()) )
	foreach( element elements
	    when( !member(element uelemnts) uelemnts = append1(uelemnts element) )
	)
    uelemnts
);let
);procedure
