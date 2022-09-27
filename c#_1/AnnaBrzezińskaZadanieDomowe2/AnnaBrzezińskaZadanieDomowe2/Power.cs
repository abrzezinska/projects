using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AnnaBrzezińskaZadanieDomowe2
{/// <summary>
/// klasa publiczna Power
/// </summary>
    public abstract  class Power
    {//wlasciwosci klasy:
     // latanie 
     public int Speed { get; set; }
     //zianie ogniem
     public int Strenght { get; set; }
        public int CurrentSpeed()
        {// funkcja losuje liczbe r i mnoży ją razy wartośc Speed ktora bd rozna dla klas ktore dziedzicza po tej klasie Power
            Random r = new Random();
            Speed = (int)(Speed * r.NextDouble());
            //zwracanie wartosci Speed
            return Speed;
        }
public int CurrentStrenght()
        {// funkcja losuje liczbe q i mnoży ją razy wartośc Strenght ktora bd rozna dla klas ktore dziedzicza po tej klasie Power
            Random q = new Random();
            Strenght = (int)(Speed * q.NextDouble());
            //zwracanie wartosci Speed
            return Strenght;
        }
     
    }
}
   
