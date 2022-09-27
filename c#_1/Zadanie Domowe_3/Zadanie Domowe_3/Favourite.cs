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
    public partial class Favourite : Form
    {
        SqlConnection connection;
        public Favourite()
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
            dataGridViewFavourite.DataSource = table;
        }
        private void Favourite_Load(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// jezeli texboxy nie sa puste to dodaje i zamyka okno
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private async void buttonAdd_Click(object sender, EventArgs e)
        {
     
                if (textBoxName.Text.Length > 0 && textBoxLastName.Text.Length > 0 && textBoxColour.Text.Length > 0 && textBoxAnimal.Text.Length > 0 && textBoxFood.Text.Length > 0)
                {
                    string query = @"INSERT INTO Persons (FirstNameLastName,Food,Animal,Colour) VALUES (@FirstName, @LastName,@Food,@Animal,@Colour)";
                    using (SqlConnection connection = new SqlConnection($@"Data Source=DESKTOP-CACPOGO\SERVERSQL; database=AnnaBrzezinskaZadanieDomowe3; Trusted_Connection=yes;"))
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = textBoxName.Text;
                        command.Parameters.Add("@LastName", SqlDbType.Date).Value = textBoxLastName.Text;
                        command.Parameters.Add("@Animal", SqlDbType.Date).Value = textBoxAnimal.Text;
                        command.Parameters.Add("@Food", SqlDbType.Date).Value = textBoxFood.Text;
                        command.Parameters.Add("@Colour", SqlDbType.Date).Value = textBoxColour.Text;
                        await connection.OpenAsync();
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                    Close();
                }
            }
        /// <summary>
        ///  Pokazuje tabele o danej nazwie w oknie
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonShow_Click(object sender, EventArgs e)
        {
            ShowData("PersonsView2");
        }
    }
}
