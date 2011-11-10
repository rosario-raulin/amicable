module: amicable

// This program calculates the first n amicable numbers

define macro inc!
  { inc!(?place:expression, ?amount:expression) }
    =>
    { ?place := ?place + ?amount }
  { inc!(?place:expression) }
    => { inc!(?place, 1) }
end macro;

define function sqrt(x)
  => (sqrt)
  x ^ 0.5;
end function sqrt;

define function factor-sum (n)
  => (sum)
  let sum = 1;
  
  for(x from 2 to (1 + sqrt(n)))
    if(modulo(n, x) = 0)
      inc!(sum, x + truncate/(n, x));
    end if;
  end for;

  values(sum);
end function factor-sum;

define function amicable(n)
  => (pairs)
  let pairs = list();
  let n-pairs = 0;

  for(x from 2, while: n-pairs ~= n)
    let s1 = factor-sum(x);
    let s2 = if(s1 > x)
               factor-sum(s1);
             else
               0;
             end if;

    if(x == s2)
      pairs := add!(pairs, pair(x, s1));
      inc!(n-pairs);
    end if;
  end for;
  
  values(reverse!(pairs));
end function amicable;

begin
  let args = application-arguments();
  if(args.size > 0)
    let pairs = amicable(string-to-integer(args[0]));

    for(x in pairs)
      format-out("%d %d\n", head(x), tail(x));
    end for;
  end if;
end;
