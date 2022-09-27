using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AnnaBrzezińskaZadanieDomowe2
{
    class Fenix:Power
    {//wartosc przez ktora mnozymy w klasie Power Siłe i Szybkośc
        public int fenixPower = 25;

        public Fenix()
        {
            Strenght = fenixPower;
            Speed = fenixPower;
        }

    }
}
