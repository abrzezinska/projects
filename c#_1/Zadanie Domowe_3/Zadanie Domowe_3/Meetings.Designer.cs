namespace Zadanie_Domowe_3
{
    partial class Meetings
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.textBoxMeeting = new System.Windows.Forms.TextBox();
            this.monthCalendarMeeting = new System.Windows.Forms.MonthCalendar();
            this.dataGridViewMeeting = new System.Windows.Forms.DataGridView();
            this.label1Meeting = new System.Windows.Forms.Label();
            this.buttonShow = new System.Windows.Forms.Button();
            this.buttonClose = new System.Windows.Forms.Button();
            this.buttonAdd = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewMeeting)).BeginInit();
            this.SuspendLayout();
            // 
            // textBoxMeeting
            // 
            this.textBoxMeeting.Location = new System.Drawing.Point(76, 26);
            this.textBoxMeeting.Name = "textBoxMeeting";
            this.textBoxMeeting.Size = new System.Drawing.Size(189, 20);
            this.textBoxMeeting.TabIndex = 0;
            // 
            // monthCalendarMeeting
            // 
            this.monthCalendarMeeting.Location = new System.Drawing.Point(24, 58);
            this.monthCalendarMeeting.Name = "monthCalendarMeeting";
            this.monthCalendarMeeting.TabIndex = 1;
            // 
            // dataGridViewMeeting
            // 
            this.dataGridViewMeeting.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewMeeting.Location = new System.Drawing.Point(338, 58);
            this.dataGridViewMeeting.Name = "dataGridViewMeeting";
            this.dataGridViewMeeting.Size = new System.Drawing.Size(240, 162);
            this.dataGridViewMeeting.TabIndex = 2;
            // 
            // label1Meeting
            // 
            this.label1Meeting.AutoSize = true;
            this.label1Meeting.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label1Meeting.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.label1Meeting.Location = new System.Drawing.Point(140, 9);
            this.label1Meeting.Name = "label1Meeting";
            this.label1Meeting.Size = new System.Drawing.Size(71, 15);
            this.label1Meeting.TabIndex = 3;
            this.label1Meeting.Text = "Spotkanie";
            // 
            // buttonShow
            // 
            this.buttonShow.Location = new System.Drawing.Point(419, 23);
            this.buttonShow.Name = "buttonShow";
            this.buttonShow.Size = new System.Drawing.Size(75, 23);
            this.buttonShow.TabIndex = 4;
            this.buttonShow.Text = "Pokaż";
            this.buttonShow.UseVisualStyleBackColor = true;
            this.buttonShow.Click += new System.EventHandler(this.buttonShow_Click);
            // 
            // buttonClose
            // 
            this.buttonClose.Location = new System.Drawing.Point(103, 247);
            this.buttonClose.Name = "buttonClose";
            this.buttonClose.Size = new System.Drawing.Size(75, 23);
            this.buttonClose.TabIndex = 5;
            this.buttonClose.Text = "Zamknij";
            this.buttonClose.UseVisualStyleBackColor = true;
            this.buttonClose.Click += new System.EventHandler(this.buttonClose_Click);
            // 
            // buttonAdd
            // 
            this.buttonAdd.Location = new System.Drawing.Point(203, 247);
            this.buttonAdd.Name = "buttonAdd";
            this.buttonAdd.Size = new System.Drawing.Size(75, 23);
            this.buttonAdd.TabIndex = 6;
            this.buttonAdd.Text = "Dodaj";
            this.buttonAdd.UseVisualStyleBackColor = true;
            this.buttonAdd.Click += new System.EventHandler(this.buttonAdd_Click);
            // 
            // Meetings
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Maroon;
            this.ClientSize = new System.Drawing.Size(609, 306);
            this.Controls.Add(this.buttonAdd);
            this.Controls.Add(this.buttonClose);
            this.Controls.Add(this.buttonShow);
            this.Controls.Add(this.label1Meeting);
            this.Controls.Add(this.dataGridViewMeeting);
            this.Controls.Add(this.monthCalendarMeeting);
            this.Controls.Add(this.textBoxMeeting);
            this.Name = "Meetings";
            this.Text = "Meetings";
            this.Load += new System.EventHandler(this.Meetings_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewMeeting)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxMeeting;
        private System.Windows.Forms.MonthCalendar monthCalendarMeeting;
        private System.Windows.Forms.DataGridView dataGridViewMeeting;
        private System.Windows.Forms.Label label1Meeting;
        private System.Windows.Forms.Button buttonShow;
        private System.Windows.Forms.Button buttonClose;
        private System.Windows.Forms.Button buttonAdd;
    }
}