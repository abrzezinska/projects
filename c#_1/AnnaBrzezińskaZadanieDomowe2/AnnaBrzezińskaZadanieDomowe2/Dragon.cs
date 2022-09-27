using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AnnaBrzezińskaZadanieDomowe2
{
    class Dragon:Power
    {//wartosc przez ktora mnozymy w klasie Power Siłe i Szybkośc
        public  int dragonPower = 55;

        public Dragon()
        {
            Strenght = dragonPower;
            Speed = dragonPower;
        }

    }
}
