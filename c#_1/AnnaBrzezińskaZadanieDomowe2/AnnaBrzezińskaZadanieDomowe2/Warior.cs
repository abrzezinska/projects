using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AnnaBrzezińskaZadanieDomowe2
{
    class Warior:Power
    {//wartosc przez ktora mnozymy w klasie Power Siłe i Szybkośc
        public int wariorPower = 40;

        public Warior()
        {
            Strenght = wariorPower;
            Speed = wariorPower;
        }
    }
}
