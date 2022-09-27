using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AnnaBrzezińskaZadanieDomowe2
{
    class MagicWall:Shield
    {//wartosc przez ktora mnozymy w klasie Shield Enregie
        public int wallPower = 25;

        public MagicWall()
        {
           Energy = wallPower;
        }


    }
}
