module: amicable

/*
Copyright (C) 2011 Rosario Raulin

This file is part of amicable.

amicable is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

amicable is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with amicable. If not, see <http://www.gnu.org/licenses/>.
*/

// This program calculates the first n amicable numbers

define macro inc!
  { inc!(?place:expression, ?amount:expression) }
    =>
    { ?place := ?place + ?amount }
  { inc!(?place:expression) }
    => { inc!(?place, 1) }
end macro;

define variable *sum-table* = make(<table>);

define function sqrt(x)
  => (sqrt)
  x ^ 0.5;
end function sqrt;

define function factor-sum (n)
  => (sum)
  let table-element = element(*sum-table*, n, default: #f);

  if(table-element)
    table-element
  else
    let sum = 1;
    for(x from 2 to (1 + sqrt(n)))
      if(modulo(n, x) = 0)
        inc!(sum, x + truncate/(n, x));
      end if;
    end for;
    element-setter(sum, *sum-table*, n);
    sum;
  end if;
end;

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
  
  reverse!(pairs);
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
