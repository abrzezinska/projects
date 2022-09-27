namespace Zadanie_Domowe_3
{
    partial class ToDo
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
            this.buttonShow = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.dataGridViewToDo = new System.Windows.Forms.DataGridView();
            this.buttonDelate = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewToDo)).BeginInit();
            this.SuspendLayout();
            // 
            // buttonShow
            // 
            this.buttonShow.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.buttonShow.Location = new System.Drawing.Point(187, 46);
            this.buttonShow.Name = "buttonShow";
            this.buttonShow.Size = new System.Drawing.Size(75, 23);
            this.buttonShow.TabIndex = 0;
            this.buttonShow.Text = "Pokaż";
            this.buttonShow.UseVisualStyleBackColor = true;
            this.buttonShow.Click += new System.EventHandler(this.buttonShow_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(57, 46);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(92, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Co do zrobiaenia?";
            // 
            // dataGridViewToDo
            // 
            this.dataGridViewToDo.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewToDo.Location = new System.Drawing.Point(44, 86);
            this.dataGridViewToDo.Name = "dataGridViewToDo";
            this.dataGridViewToDo.Size = new System.Drawing.Size(240, 143);
            this.dataGridViewToDo.TabIndex = 3;
            // 
            // buttonDelate
            // 
            this.buttonDelate.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.buttonDelate.Location = new System.Drawing.Point(318, 147);
            this.buttonDelate.Name = "buttonDelate";
            this.buttonDelate.Size = new System.Drawing.Size(75, 23);
            this.buttonDelate.TabIndex = 4;
            this.buttonDelate.Text = "Usuń";
            this.buttonDelate.UseVisualStyleBackColor = true;
            this.buttonDelate.Click += new System.EventHandler(this.buttonDelate_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(318, 106);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(100, 20);
            this.textBox1.TabIndex = 5;
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(326, 73);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(96, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Nazwa wydarzenia";
            this.label2.Click += new System.EventHandler(this.label2_Click);
            // 
            // ToDo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Maroon;
            this.ClientSize = new System.Drawing.Size(476, 261);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.buttonDelate);
            this.Controls.Add(this.dataGridViewToDo);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.buttonShow);
            this.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.Name = "ToDo";
            this.Text = "ToDo";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewToDo)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonShow;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DataGridView dataGridViewToDo;
        private System.Windows.Forms.Button buttonDelate;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label label2;
    }
}