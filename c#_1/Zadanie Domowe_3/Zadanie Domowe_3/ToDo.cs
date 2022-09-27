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
    public partial class ToDo : Form
    {
        SqlConnection connection;
        public ToDo()
        {

            InitializeComponent();
            connection = new SqlConnection(@"Data Source=DESKTOP-CACPOGO\SERVERSQL;database=AnnaBrzezinskaZadanieDomowe_3;Trusted_Connection=yes");
        }
        /// <summary>
        /// Pokazuje tabele o danej nazwie w oknie
        /// </summary>
        /// <param name="query"></param>
        private void ShowData(string query)
        {


            SqlDataAdapter data = new SqlDataAdapter($"SELECT * FROM {query} ", connection);
            DataTable table = new DataTable();
            data.Fill(table);
            dataGridViewToDo.DataSource = table;

        }
        /// <summary>
        /// pokazuje tabele o danej nazwie w oknie
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonShow_Click(object sender, EventArgs e)
        {
            ShowData("ToDoView");
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// 
        /// usuwa z tabeli wers o podanej nazwie i zamyka okno
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        async private void buttonDelate_Click(object sender, EventArgs e)
        {
            string query = @"Delete from ToDo where Name=@Name";
            using (SqlConnection connection = new SqlConnection($@"Data Source=DESKTOP-CACPOGO\SERVERSQL; database=AnnaBrzezinskaZadanieDomowe_3; Trusted_Connection=yes;"))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.Add("@Name", SqlDbType.NVarChar).Value = textBox1.Text;
              
                await connection.OpenAsync();
                command.ExecuteNonQuery();
                connection.Close();
            }
            Close();
        }
    }
}
