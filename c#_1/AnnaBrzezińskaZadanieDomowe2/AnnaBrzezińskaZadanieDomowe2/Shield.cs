using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AnnaBrzezińskaZadanieDomowe2
{//klasa tarcza
    public class Shield
    {//własciwości:
     //energia
        public int Energy { get; set; }
        // przypisywanie wartosci do wlasciwosci klasy
        public int CurrentEnergy()
        {// losowanie liczby o i mnoży ja razy wartoś Energy która bd rozna dla klas ktore dziedzicza po klasie Shield
            Random o = new Random();
            Energy = (int)(Energy * o.NextDouble());
            //funkcja zwraca wartości energi
            return Energy;
        }
    }
}
