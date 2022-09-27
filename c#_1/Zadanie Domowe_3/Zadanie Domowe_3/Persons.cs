using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
namespace Zadanie_Domowe_3
{
    

    public partial class Persons : Form
    {
        SqlConnection connection;
        public Persons()
        {
            InitializeComponent();
            connection = new SqlConnection(@"Data Source=DESKTOP-CACPOGO\SERVERSQL;database=AnnaBrzezinskaZadanieDomowe_3;Trusted_Connection=yes");
        }
        /// <summary>
        ///  Pokazuje tabele o danej nazwie w oknie
        /// </summary>
        /// <param name="query"></param>
        private void ShowData(string query)
        {


            SqlDataAdapter data = new SqlDataAdapter($"SELECT * FROM {query} ", connection);
            DataTable table = new DataTable();
            data.Fill(table);
            dataGridViewPersons.DataSource = table;

        }
        private void label2_Click(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// Pokazuje tabele o danej nazwie w oknie
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonShow_Click(object sender, EventArgs e)
        {
            ShowData("PersonsView1");
        }
        /// <summary>
        /// dodajekontakt jeżeli okna nie sa puste i zamyka okno
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private async void buttonAdd_Click(object sender, EventArgs e)
        {

            if (textBoxName.Text.Length > 0 && textBoxLastName.Text.Length >0 && textBoxOcupation.Text.Length > 0 && textBoxSalary.Text.Length > 0)
            {
                string query = @"INSERT INTO Persons (FirstNameLastName,Ocupation,Salary) VALUES (@FirstName, @LastName,@Ocupation,@Salary)";
                using (SqlConnection connection = new SqlConnection($@"Data Source=DESKTOP-CACPOGO\SERVERSQL; database=AnnaBrzezinskaZadanieDomowe3; Trusted_Connection=yes;"))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = textBoxName.Text;
                    command.Parameters.Add("@LastName", SqlDbType.Date).Value = textBoxLastName.Text;
                    command.Parameters.Add("@Ocupation", SqlDbType.Date).Value = textBoxOcupation.Text;
                    command.Parameters.Add("@Salary", SqlDbType.Date).Value = textBoxSalary.Text;
                    await connection.OpenAsync();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
                Close();
            }
        }
    }
}
