using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace Zadanie_Domowe_3
{
    public partial class Form1 : Form
    {
        SqlConnection connection;
        public Form1()
        {
            InitializeComponent();
            connection = new SqlConnection(@"Data Source=DESKTOP-CACPOGO\SERVERSQL;database=AnnaBrzezinskaZadanieDomowe_3;Trusted_Connection=yes");
           
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
        // przekierowuje do innego okan 
        private void toolStripButton1_Click(object sender, EventArgs e)
        {

            Meetings mm = new Meetings();
            mm.ShowDialog();
        }
        // przekierowuje do innego okan 
        private void toolStripButton1_Click_1(object sender, EventArgs e)
        {
            Persons pp = new Persons();
            pp.ShowDialog();

        }
        // przekierowuje do innego okan 
        private void toolStripButtonThings_Click(object sender, EventArgs e)
        {
            Favourite ff = new Favourite();
            ShowDialog();

        }
        // przekierowuje do innego okan 
        private void toolStripButton2_Click(object sender, EventArgs e)
        {
            ToDo t = new ToDo();
            t.ShowDialog();
        }
    }
}
