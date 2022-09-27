namespace Zadanie_Domowe_3
{
    partial class Persons
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
            this.dataGridViewPersons = new System.Windows.Forms.DataGridView();
            this.labelSurname = new System.Windows.Forms.Label();
            this.labelName = new System.Windows.Forms.Label();
            this.textBoxLastName = new System.Windows.Forms.TextBox();
            this.textBoxName = new System.Windows.Forms.TextBox();
            this.buttonShow = new System.Windows.Forms.Button();
            this.buttonAdd = new System.Windows.Forms.Button();
            this.buttonDelate = new System.Windows.Forms.Button();
            this.textBoxOcupation = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.textBoxSalary = new System.Windows.Forms.TextBox();
            this.labelSalary = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewPersons)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridViewPersons
            // 
            this.dataGridViewPersons.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewPersons.Location = new System.Drawing.Point(26, 21);
            this.dataGridViewPersons.Name = "dataGridViewPersons";
            this.dataGridViewPersons.Size = new System.Drawing.Size(240, 150);
            this.dataGridViewPersons.TabIndex = 0;
            // 
            // labelSurname
            // 
            this.labelSurname.AutoSize = true;
            this.labelSurname.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.labelSurname.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.labelSurname.Location = new System.Drawing.Point(328, 75);
            this.labelSurname.Name = "labelSurname";
            this.labelSurname.Size = new System.Drawing.Size(73, 19);
            this.labelSurname.TabIndex = 13;
            this.labelSurname.Text = "Nazwisko";
            // 
            // labelName
            // 
            this.labelName.AutoSize = true;
            this.labelName.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.labelName.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.labelName.Location = new System.Drawing.Point(344, 13);
            this.labelName.Name = "labelName";
            this.labelName.Size = new System.Drawing.Size(39, 19);
            this.labelName.TabIndex = 12;
            this.labelName.Text = "Imię";
            // 
            // textBoxLastName
            // 
            this.textBoxLastName.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.textBoxLastName.Location = new System.Drawing.Point(288, 97);
            this.textBoxLastName.Name = "textBoxLastName";
            this.textBoxLastName.Size = new System.Drawing.Size(171, 20);
            this.textBoxLastName.TabIndex = 9;
            // 
            // textBoxName
            // 
            this.textBoxName.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.textBoxName.Location = new System.Drawing.Point(288, 35);
            this.textBoxName.Name = "textBoxName";
            this.textBoxName.Size = new System.Drawing.Size(171, 20);
            this.textBoxName.TabIndex = 8;
            // 
            // buttonShow
            // 
            this.buttonShow.Location = new System.Drawing.Point(44, 190);
            this.buttonShow.Name = "buttonShow";
            this.buttonShow.Size = new System.Drawing.Size(75, 23);
            this.buttonShow.TabIndex = 27;
            this.buttonShow.Text = "Pkaż";
            this.buttonShow.UseVisualStyleBackColor = true;
            this.buttonShow.Click += new System.EventHandler(this.buttonShow_Click);
            // 
            // buttonAdd
            // 
            this.buttonAdd.Location = new System.Drawing.Point(147, 190);
            this.buttonAdd.Name = "buttonAdd";
            this.buttonAdd.Size = new System.Drawing.Size(75, 23);
            this.buttonAdd.TabIndex = 28;
            this.buttonAdd.Text = "Dodaj";
            this.buttonAdd.UseVisualStyleBackColor = true;
            this.buttonAdd.Click += new System.EventHandler(this.buttonAdd_Click);
            // 
            // buttonDelate
            // 
            this.buttonDelate.Location = new System.Drawing.Point(97, 236);
            this.buttonDelate.Name = "buttonDelate";
            this.buttonDelate.Size = new System.Drawing.Size(75, 23);
            this.buttonDelate.TabIndex = 29;
            this.buttonDelate.Text = "Usuń";
            this.buttonDelate.UseVisualStyleBackColor = true;
            // 
            // textBoxOcupation
            // 
            this.textBoxOcupation.Location = new System.Drawing.Point(289, 218);
            this.textBoxOcupation.Name = "textBoxOcupation";
            this.textBoxOcupation.Size = new System.Drawing.Size(171, 20);
            this.textBoxOcupation.TabIndex = 17;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label2.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.label2.Location = new System.Drawing.Point(356, 196);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(52, 19);
            this.label2.TabIndex = 18;
            this.label2.Text = "Zawód";
            this.label2.Click += new System.EventHandler(this.label2_Click);
            // 
            // textBoxSalary
            // 
            this.textBoxSalary.Location = new System.Drawing.Point(289, 156);
            this.textBoxSalary.Name = "textBoxSalary";
            this.textBoxSalary.Size = new System.Drawing.Size(171, 20);
            this.textBoxSalary.TabIndex = 20;
            // 
            // labelSalary
            // 
            this.labelSalary.AutoSize = true;
            this.labelSalary.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.labelSalary.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.labelSalary.Location = new System.Drawing.Point(356, 134);
            this.labelSalary.Name = "labelSalary";
            this.labelSalary.Size = new System.Drawing.Size(45, 19);
            this.labelSalary.TabIndex = 19;
            this.labelSalary.Text = "Płaca";
            // 
            // Persons
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Maroon;
            this.ClientSize = new System.Drawing.Size(572, 271);
            this.Controls.Add(this.buttonDelate);
            this.Controls.Add(this.buttonAdd);
            this.Controls.Add(this.buttonShow);
            this.Controls.Add(this.textBoxSalary);
            this.Controls.Add(this.labelSalary);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.textBoxOcupation);
            this.Controls.Add(this.labelSurname);
            this.Controls.Add(this.labelName);
            this.Controls.Add(this.textBoxLastName);
            this.Controls.Add(this.textBoxName);
            this.Controls.Add(this.dataGridViewPersons);
            this.Name = "Persons";
            this.Text = "Persons";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewPersons)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridViewPersons;
        private System.Windows.Forms.Label labelSurname;
        private System.Windows.Forms.Label labelName;
        private System.Windows.Forms.TextBox textBoxLastName;
        private System.Windows.Forms.TextBox textBoxName;
        private System.Windows.Forms.Button buttonShow;
        private System.Windows.Forms.Button buttonAdd;
        private System.Windows.Forms.Button buttonDelate;
        private System.Windows.Forms.TextBox textBoxOcupation;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBoxSalary;
        private System.Windows.Forms.Label labelSalary;
    }
}