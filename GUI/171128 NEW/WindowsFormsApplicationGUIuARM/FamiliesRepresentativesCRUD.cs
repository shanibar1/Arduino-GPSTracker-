using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WindowsFormsApplicationGUIuARM
{
    public partial class FamiliesRepresentativesCRUD : Form
    {
        
        public FamiliesRepresentativesCRUD()
        {
            InitializeComponent();
        }

        private void Form_isidata_Load(object sender, EventArgs e)
        {
            //if (Variabel_share.id1 == 1)
            //    comboBox_id.Items.Add("01");
            //if (Variabel_share.id2 == 1)
            //    comboBox_id.Items.Add("02");

        }

        // SIMPAN DATA PERSONIL
        private void button2_Click(object sender, EventArgs e)
        {
            if (textBox_representativeId.Text == "" || textBox_Address.Text == "" || textBox_FirstName.Text == "" || textBox_LastName.Text == "")
            {
                MessageBox.Show("אנא ודא כי אין שדות ריקים!");
            }
            else
            {
                Variabel_share.id = textBox_representativeId.Text;
                Variabel_share.nama_lengkap = textBox_Address.Text;
                if(radioButton_p.Checked = true)
                    Variabel_share.kelamin = "TRUE";
                else
                    Variabel_share.kelamin = "FULSE";
                Variabel_share.nrp = textBox_FirstName.Text;
                Variabel_share.tempat_lahir = textBox_LastName.Text;


                Variabel_share.tanggal_lahir = dateTimePicker_lahir.Text;
                //textBox1.Text = Variabel_share.tanggal_lahir;

                MessageBox.Show("המידע נשמר בהצלחה!");
            }


        }

        
    }
}
