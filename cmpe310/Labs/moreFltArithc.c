#include <stdio.h>
#include <stdlib.h>
int main()
 { 
   double a=3.0, b=4.0, c;
   long int i=8;
                        
   c=-5.0;
   printf("%-8s, a=%e, b=%e, c=%e\n","c=-5.0", a, b, c);
   c=abs(c);
   printf("%-8s, a=%e, b=%e, c=%e\n","c=abs(c)", a, b, c);
   c=a+b;
   printf("%-8s, a=%e, b=%e, c=%e\n","c=a+b", a, b, c);
   c=a-b;
   printf("%-8s, a=%e, b=%e, c=%e\n","c=a-b", a, b, c);
   c=a*b;
   printf("%-8s, a=%e, b=%e, c=%e\n","c=a*b", a, b, c);
   c=c/a;
   printf("%-8s, a=%e, b=%e, c=%e\n","c=c/a", a, b, c);
   a=i;
   b=a+i;
   i=b;
   c=i;
   if(a<b) printf("%-8s, a=%e, b=%e, c=%e\n","a<=b ", a, b, c);
   else    printf("%-8s, a=%e, b=%e, c=%e\n","a>b  ", a, b, c);
   if(b==c)printf("%-8s, a=%e, b=%e, c=%e\n","b==c ", a, b, c);
   else    printf("%-8s, a=%e, b=%e, c=%e\n","b!=c ", a, b, c);
   return 0;
}
