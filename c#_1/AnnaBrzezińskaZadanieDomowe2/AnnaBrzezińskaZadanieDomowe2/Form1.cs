using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AnnaBrzezińskaZadanieDomowe2
{
    public partial class MainForm : Form
    {// zmienna time jest rowna 0 , bd słuzyła do liczenia czasu
        int time = 0;
        //zmienna przy pomocy której liczy sie pieniadze
        int money;
        //zmienne shield i btn bd sluzyly pozniej do sprawdzenia czy gracz nacisnal przycisk w odpowiednim czasie
        bool shield = false;
        bool btn = false;
        //tworzymy zmienne smoka,feniksa,czarodzeja,wojownika,ogien,magiczna sciane,bariere ktore sluza do stworzenia tych rzeczy w dalszej czesci programu
        Dragon bigDragon;
        Fenix bigFenix;
        Wizard bigWizard;
        Warior bigWarior;
        Fire bigFire;
        MagicWall bigMagicWall;
        Barier bigBarier;
        public MainForm()
        {
            InitializeComponent();
            /// ustawiam kolor tła na biały
            this.BackColor = Color.White;
            ///kolor buttonClose na czarny
            buttonClose.BackColor = Color.Black;
            ///kolor przyciskow na rozowy
            buttonBuy.BackColor = Color.LightPink;
            buttonAddMoney.BackColor = Color.LightPink;
            buttonHospital.BackColor = Color.LightPink;
            buttonDefense.BackColor = Color.LightPink;
            ///ustawiam obrazki aby mieściły sie w picturebox'ach
            pictureBoxCastle.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBoxHospital.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBoxCreature.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBoxWarior.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBoxEquipment.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBoxDefence.SizeMode = PictureBoxSizeMode.StretchImage;
            ///interwał to 1000s
            timer.Interval = 1000;
            //czas zaczyna sie odliczac wraz z rozpoczęciem programu 
            timer.Start();
            //tworzymy smoka,wojownika,feniksa,czarodzeja,ogien,magiczna sciane,bariere o własciwosciach z klas
            bigDragon = new Dragon();
            bigWarior=new Warior();
            bigWizard = new Wizard();
            bigFenix = new Fenix();
            bigFire = new Fire();
            bigMagicWall = new MagicWall();
            bigBarier = new Barier();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentSpeed z klasy smoka ,czyli pokazuje szybkosc smoka
            labelS.Text=bigDragon.CurrentSpeed().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentSpeed z klasy feniksa ,czyli pokazuje szybkosc feniksa
            labelSpeed2.Text= bigFenix.CurrentSpeed().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentSpeed z klasy wojownika ,czyli pokazuje szybkosc wojownika
            labelWariorSpeed.Text = bigWarior.CurrentSpeed().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentStrenght z klasy smoka ,czyli pokazuje siłe smoka
            labelStrenght1.Text = bigDragon.CurrentStrenght().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentStrenght z klasy feniks ,czyli pokazuje siłe feniksa
            labelStrenght2.Text = bigFenix.CurrentStrenght().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentStrenght z klasy wojownika ,czyli pokazuje siłe wojownika
            labelWariorStrenght.Text = bigWarior.CurrentStrenght().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentEnergy z klasy Wizard ,czyli pokazuje energie Wizarda
            labelWizardEnergy.Text = bigWizard.CurrentEnergy().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentEnergy z klasy Barier ,czyli pokazuje energie bariery
            labelBarierEnergy.Text = bigBarier.CurrentEnergy().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentEnergy z klasy MagicWall ,czyli pokazuje energie Wmagicznej ściany
            labelMagicWallEnergy.Text = bigMagicWall.CurrentEnergy().ToString();
            //w podanym nizej labelowi przypisujemy wartosci z funkcji CurrentEnergy z klasy Fire ,czyli pokazuje energie ognia
            labelFireEnergy.Text = bigFire.CurrentEnergy().ToString();
        }
        //funkcja odejmujaca pieniadze(10zl)
        void MinusMoney()
        {
            /// zmienna money ma pszypisana wartosc wpisana w texBoxMoney
            money = Int32.Parse(textBoxMoney.Text);
            // Po klinknieciu przycisku odejmuje od budzetu 10
            money -= 10;
            /// obliczona wartosc pieniedzy jest wpisywana w TextBoxMoney
            textBoxMoney.Text = money.ToString();
            
        }
        //funkcja dodajaca pieniadze(25zl)
        void AddMoney()
        {
            /// zmienna money ma pszypisana wartosc wpisana w texBoxMoney
            money = Int32.Parse(textBoxMoney.Text);
            // Po klinknieciu przycisku odejmuje od budzetu 10
            money +=25;
            /// obliczona wartosc pieniedzy jest wpisywana w TextBoxMoney
            textBoxMoney.Text = money.ToString();
        }
        //funkcja sprawdzajca czy sa pieniadze
        void NoMoney()
        {/// zmienna money ma pszypisana wartosc wpisana w texBoxMoney
            money = Int32.Parse(textBoxMoney.Text);
            //sprawdzamy czy wartosc jest mniejsza niz 0
            if (money <= 0)
            {//jesli tak to wyswietlamy wiadomosc
                MessageBox.Show("Zamek bankrutuje.Klęska");
            }
        }
        //funkcja łącząca funkcje NoMoney i MinusMoney
        void MinusAndNoMoney()
        {//najpierw odejmujemy pieniadze a potem sprawdzamy czy zamek nie zbankrutował
            MinusMoney();
            NoMoney();
        }
        private void MainForm_Load(object sender, EventArgs e)
        {

        }

        private void labelCastle_Click(object sender, EventArgs e)
        {

        }

        private void buttonClose_Click(object sender, EventArgs e)
        {///close the window(program)
            Close(); 
        }

        private void timer_Tick(object sender, EventArgs e)
        {// zmienna time liczy czas
            time++;
            /// naliczajacy sie czas pokazuje sie w  labelTimer
            labelTimer.Text = time.ToString();
            //poazanie na progresBarTime ile juz pragram dziala a ile mniej wiecej zostało do końca
            this.progressBarTime.Increment(1);
            //program ma trwac 100s po tym czasie sie zameka
            if(time%100==0)
            {//zamkniecie programu
                Close();
            }
            // info czy brak pieniedzy i inne zdarzenia
            if (money > 0)
            {/// co kazde 130 sekund zamek dostaje od rzadu 250 zl
                if (time % 130 == 0)
                {
                    money += 250;
                    // przypisanie wartości do TextBoxMoney
                    textBoxMoney.Text = money.ToString();
                }
                if (time%50==6 && shield == false)
                {
                    btn = true;
                    //wyświetlenie komunikatu
                    MessageBox.Show("Masz 5 sekundy żeby przetestowac działanie tarczy ineczej z budzetu zamku zostana odjete 10 zl");
                }
                if (time % 50 == 16)
                {
                    if (shield == true && btn == true)
                    {  //wyświetlenie komunikatu
                        MessageBox.Show("wcisnieto shield");
                        shield = false;
                    }
                    else
                    {//komunikat dla gracza
                        MessageBox.Show("Od budzetu zamku zostaje odjete 10 zl za bark czynnego udzialu w cwiczeniach w razie ataku");
                        //funkcja odejmujaca pieniadze od budzetu zamku i sprawdzajaca czy zamek nie bankrutuje

                        MinusAndNoMoney();
                    }
                }
            }
            else
            {//funkcja sprawdza czy sa pieniadze w budzecie
                NoMoney();
            }
            //co 20 sekund atak na zamek przez smoka
            if (time % 20 == 0)
            {  //wyświetlenie komunikatu
                MessageBox.Show("Zamek atakuje smok do walki z nim staje wielki wojownik");
                //sprawdzamy czy wojownik czy smok jest potezniejszy przez porownanie sum ich szybkosci i sily
                if (bigWarior.CurrentStrenght() + bigWarior.CurrentSpeed() > bigDragon.CurrentSpeed() + bigDragon.CurrentStrenght())
                {  //wyświetlenie komunikatu
                    MessageBox.Show("Wojownik obronił zamek.Hura!!!");

                }
                else
                {  //wyświetlenie komunikatu
                    MessageBox.Show("Zamek upadł.Wojownik poległ");
                    //zamkniecie programu
                    Close();
                }
            }
            //co 30 s zamek atakuje feniks
            if (time % 30 == 0)
            {  //wyświetlenie komunikatu
                MessageBox.Show("Zamek atakuje Feniks do walki z nim staje wielki wojownik");
                //sprawdzamy czy wojownik czy feniks jest potezniejszy przez porownanie sum ich szybkosci i sily
                if (bigWarior.CurrentStrenght() + bigWarior.CurrentSpeed() > bigFenix.CurrentSpeed() + bigDragon.CurrentStrenght())
                {  //wyświetlenie komunikatu
                    MessageBox.Show("Wojownik pokonał wroga.Hura!!!");

                }
                else
                {//wyświetlenie komunikatu
                    MessageBox.Show("Wojownik poniósł klęske...");
                    //zamkniecie programu
                     Close();
                }
            }
            // co 55 s czarodziej przywoluje ogien sprawdzamy czy tarcze i bariery sa wstanie wytrzymac
            if (time % 55 == 0)
            {//wyświetlenie komunikatu
                MessageBox.Show("Zły czarodziej użył zakazanej mocy i wezwał ogień piekielny! Czy obrona zamku wytrzyma ?");
                //sprawdzamy czybariera w połaczeniu z magiczna sciana   czy ogien w polaczeniu z czarodzejem jest potezniejszy przez porownanie sum ich energii
                if (bigWizard.CurrentEnergy() + bigFire.CurrentEnergy() > bigBarier.CurrentEnergy() + bigMagicWall.CurrentEnergy())
                {//wyświetlenie komunikatu
                    MessageBox.Show("Bariery nie wytrzymały z nowe trzeba zapłacic 500 zl");
                    /// zmienna money ma pszypisana wartosc wpisana w texBoxMoney
                    money = Int32.Parse(textBoxMoney.Text);
                    // Po klinknieciu przycisku odejmuje od budzetu 500
                    money -= 500;
                    /// obliczona wartosc pieniedzy jest wpisywana w TextBoxMoney
                    textBoxMoney.Text = money.ToString();

                }
                else
                {//wyświetlenie komunikatu
                    MessageBox.Show("Uh... bariery wytrzymały");
                }
            }
           
        }

        private void buttonBuy_Click(object sender, EventArgs e)
        {/// funkcja ktora odejmuje pieniadze a potem sprawdza czy zamek nie zbankrutował
            MinusAndNoMoney();
        }

        private void buttonHospital_Click(object sender, EventArgs e)
        {
            /// funkcja ktora odejmuje pieniadze a potem sprawdza czy zamek nie zbankrutował
            MinusAndNoMoney();
        }

        private void buttonDefense_Click(object sender, EventArgs e)
        {// po wcisnieciu przycisku tło bd niebieskie
            this.BackColor = Color.LightSkyBlue;
            //wyświetlenie komunikatu
            MessageBox.Show("Tarcza działa");
            //powrot do białego koloru tła
            this.BackColor = Color.White;
            // sprawdzenie czy przycisk został wcisniety 
            shield = true;
        }

        private void buttonAddMoney_Click(object sender, EventArgs e)
        {// Dodajemy pieniądze z darowizny za pomaca funkcji AddMoney
            AddMoney();
        }

        private void labelWariorStrenght_Click(object sender, EventArgs e)
        {

        }

        private void progressBarTime_Click(object sender, EventArgs e)
        {
            //kolor tych małych kwadracikow na niebieski
            progressBarTime.ForeColor = Color.Blue;
           
        }
    }
}
