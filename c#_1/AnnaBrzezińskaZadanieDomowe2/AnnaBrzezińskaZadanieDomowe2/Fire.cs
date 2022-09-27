using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AnnaBrzezińskaZadanieDomowe2
{
    class Fire:Shield
    {//wartosc przez ktora mnozymy w klasie Shield Enregie
        public int firePower = 5;
    
        public Fire()
        {
            Energy = firePower;
        }

    }
   
}
