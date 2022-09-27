using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AnnaBrzezińskaZadanieDomowe2
{
    class Barier:Shield
    {//wartosc przez ktora mnozymy w klasie Shield Enregie
        public int barierPower = 60;

        public Barier()
        {
            
            Energy = barierPower;
        }
    }
}
