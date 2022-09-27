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
    public partial class Meetings : Form
    {
        SqlConnection connection;
        public Meetings()
        {
            InitializeComponent();
            connection = new SqlConnection(@"Data Source=DESKTOP-CACPOGO\SERVERSQL;database=AnnaBrzezinskaZadanieDomowe_3;Trusted_Connection=yes");
            monthCalendarMeeting.MinDate = DateTime.Now.Date;// pokazuje aktualna date
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
            dataGridViewMeeting.DataSource = table;

        }
        private void Meetings_Load(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// 
        /// Pokazuje tabele o danej nazwie w oknie
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonShow_Click(object sender, EventArgs e)
        {
            ShowData("MeetingView");
        }
        /// <summary>
        /// zamyka okno
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonClose_Click(object sender, EventArgs e)
        {
            Close();
        }
        /// <summary>
        ///  dodaje spotkanie jezeli tabele nie sa puste i zamyka okno
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private async void buttonAdd_Click(object sender, EventArgs e)
        {
            if (textBoxMeeting.Text.Length > 0)
            {
                string query = @"INSERT INTO Meetings (Name,Meeting) VALUES (@Name, @Meeting)";
                using (SqlConnection connection = new SqlConnection($@"Data Source=DESKTOP-CACPOGO\SERVERSQL; database=AnnaBrzezinskaZadanieDomowe3; Trusted_Connection=yes;"))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.Add("@Name", SqlDbType.NVarChar).Value = textBoxMeeting.Text;
                    command.Parameters.Add("@Meeting", SqlDbType.Date).Value = monthCalendarMeeting.SelectionStart.Date;
                    await connection.OpenAsync();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
                Close();
            }
        }
    }
}
