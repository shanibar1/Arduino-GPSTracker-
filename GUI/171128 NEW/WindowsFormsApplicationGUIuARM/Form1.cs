using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;


using System.IO;
using GMap.NET;
using GMap.NET.MapProviders;
using GMap.NET.WindowsForms;
using GMap.NET.WindowsForms.Markers;
using GMap.NET.WindowsForms.ToolTips;


using Microsoft.VisualBasic;


namespace WindowsFormsApplicationGUIuARM
{
    public partial class Form1 : Form
    {
       // private FamiliesRepresentatives exist_FamiliesRepresentatives;

        public Form1()
        {
            InitializeComponent();
            this.SerialPort.Encoding = Encoding.GetEncoding(28591);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            my_init_gps();
            //groupBox1.Visible = false;
            
            
        }

        GMapOverlay markersOverlay = new GMapOverlay();
        
        private void my_init_gps()
        {
            gMapControl1.MapProvider = GMap.NET.MapProviders.GoogleMapProvider.Instance;
            GMap.NET.GMaps.Instance.Mode = GMap.NET.AccessMode.ServerAndCache;
            gMapControl1.Position = new PointLatLng(31.25111, 34.79806); 
            gMapControl1.MinZoom = 0;
            gMapControl1.MaxZoom = 30;
            gMapControl1.Zoom = 18;
            gMapControl1.DragButton = MouseButtons.Left;

            GMarkerGoogle marker = new GMarkerGoogle(new PointLatLng(31.25111, 34.79806), GMarkerGoogleType.green);

            markersOverlay = new GMapOverlay();
            markersOverlay.Markers.Add(marker);
            gMapControl1.Overlays.Add(markersOverlay);
        }

        // TAMPIL PETA
        double lat_sebelum, long_sebelum;
        private void gps_marker(double latitude,double longitude)
        {
            gMapControl1.Position = new PointLatLng(latitude, longitude);
            gMapControl1.MinZoom = 0;
            gMapControl1.MaxZoom = 30;
            gMapControl1.Zoom = 18;

            GMarkerGoogle marker = new GMarkerGoogle(new PointLatLng(latitude, longitude), GMarkerGoogleType.green);
            marker.Position = new PointLatLng(latitude, longitude);

            markersOverlay.Clear();

            markersOverlay.Markers.Add(marker);
        }

        private void my_COMPortAvaliable()
        {

            cboPortName.Items.Clear();
            string[] SerialPort = System.IO.Ports.SerialPort.GetPortNames();
            foreach (string item in SerialPort)
            {
                cboPortName.Items.Add(item);
                cboPortName.Text = item;
            }

        }

       

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            About Form21 = new About();
            Form21.Show();
        }


        string data = "";

        string data_in;
        int byte_data;
        string buffer;
        private void SerialPort_DataReceived(object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
        {
            buffer = SerialPort.ReadExisting();
            data_in += buffer;
            this.BeginInvoke(new EventHandler(my_tampilbuffer));


            if (data_in.Contains("AG_"))
            {
                SerialPort.DiscardNull = false;
                this.BeginInvoke(new EventHandler(my_parse_data_gambar));
            }

            //else 
            if (data_in.Contains("GG"))
            {
                SerialPort.DiscardNull = true;
                this.BeginInvoke(new EventHandler(my_parse_data_rutin));
            }

            

            //try
            //{
            //    data_in = SerialPort.ReadLine();              //data ditampung sampai ada enter    
            //}
            //catch { }
            //this.BeginInvoke(new EventHandler(parse));

            
        }

        
        

        double longitude1, latitude1,satelite1, BPM1;
        
        private void my_parse_data_rutin(object sender, EventArgs e)
        {
            try
            {
                int i = 0;
                string[] data_str = new string[25];

                richTextBox_serial.AppendText(DateTime.Now.ToString("HH:mm:ss ")+data_in+"\n");
                richTextBox_serial.ScrollToCaret();

                foreach (string n in data_in.Split('_'))       //data dipisah dengan character "_"
                {
                    if (n == "#")
                        i = 1;
                    data_str[i] = n;                        //data yang sudah dipisah disimpan disini
                    i++;
                }

                if (data_str[1] == "#")
                {
                    try
                    {
                        if (data_str[2] == "01")
                        {
                            // TAMPIL HEART RATE DAN GPS
                            latitude1 = Convert.ToDouble(data_str[3]);
                            longitude1 = Convert.ToDouble(data_str[4]);
                            satelite1 = Convert.ToDouble(data_str[5]);
                            BPM1 = Convert.ToDouble(data_str[6]);

                            label60.Text = data_str[3];
                            label58.Text = data_str[4];
                            label12.Text = data_str[5];



                          

                            //>>>>>>>>>>>>>>>>PAKSA -7.276384, 112.793983
                            label60.Text = "-7.276384";
                            //label58.Text = "112.793983";
                            //label12.Text = "4";
                            //textBox_status_1.BackColor = Color.Lime;
                            //textBox_status_1.Text = "NORMAL";
                            //textBox36.Text = "NORMAL";


                        }
                        //==================#99
                    
                    }
                    catch { }
                }
                data_in = "";

                
            }
            catch { }
        }
        




    private void button16_Click_1(object sender, EventArgs e)
    {
        
    }

    private void button21_Click(object sender, EventArgs e)
    {

    }

    //////////////////////////////////////////////////////////////////////// UX SEPERTI APLIKASI WINDOWS PADA UMUNYA {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
    // DISABLE X BUTTON
    //private const int CP_NOCLOSE_BUTTON = 0x200;
    //protected override CreateParams CreateParams
    //{
    //    get
    //    {
    //        CreateParams myCp = base.CreateParams;
    //        myCp.ClassStyle = myCp.ClassStyle | CP_NOCLOSE_BUTTON;
    //        return myCp;
    //    }
    //}

    protected override void OnFormClosing(FormClosingEventArgs e)
    {
        base.OnFormClosing(e);
        if (PreClosingConfirmation() == System.Windows.Forms.DialogResult.Yes)
        {
            if (SerialPort.IsOpen)
            {
                SerialPort.Write("D");
                try
                {
                    SerialPort.Close();
                }
                catch { }

            }


            Dispose(true);

            Application.Exit();
        }
        else
        {
            e.Cancel = true;
        }
    }

    private DialogResult PreClosingConfirmation()
    {
        DialogResult res = System.Windows.Forms.MessageBox.Show(" האם אתתה בטוח שאתה רוצה לצאת?          ", "", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
        return res;
    }
    //////////////////////////////////////////////////////////////////////// UX SEPERTI APLIKASI WINDOWS PADA UMUNYA  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

    private void button1_Click(object sender, EventArgs e)
    {
        
        var f2 = new About();
        f2.Owner = this;  // <-- This is the important thing
        f2.ShowDialog(); // VS Show
    }
    

    //  TAMBAH PASUKAN 
    private void pictureBox1_Click_1(object sender, EventArgs e)
    {
        var f2 = new FamiliesRepresentativesCRUD();
        f2.Owner = this;  // <-- This is the important thing
        f2.ShowDialog(); // VS Show
    }

    private void pictureBox_1_Click(object sender, EventArgs e)
    {
        if (MessageBox.Show("Apakah akan menghapus personil?", "", MessageBoxButtons.YesNo) == DialogResult.Yes)
        {
            groupBox1.Visible = false;
            Variabel_share.id1 = 1;
        }
    }

    private void pictureBox4_Click(object sender, EventArgs e)
    {
        //groupBox2.Visible = false;
        //Variabel_share.id2 = 1;

    }

    private void pictureBox6_Click(object sender, EventArgs e)
    {
        //groupBox3.Visible = false;
    }

    private void pictureBox8_Click(object sender, EventArgs e)
    {
        //groupBox4.Visible = false;
    }

    private void pictureBox10_Click(object sender, EventArgs e)
    {
        //groupBox5.Visible = false;
    }

    private void pictureBox12_Click(object sender, EventArgs e)
    {
        //groupBox6.Visible = false;
    }
    //PERINTAH KONEK DAN TIDAK KONEK

    private void buttonConnect_Click(object sender, EventArgs e)
    {
        if (!SerialPort.IsOpen)
        {
            try
            {
                SerialPort.PortName = cboPortName.Text;
                SerialPort.BaudRate = Convert.ToInt32( comboBox_baud.Text);
                SerialPort.Open();
                if (SerialPort != null)
                {

                    //MessageBox.Show("Connection is succesfully to " + serialPort_rx.PortName);
                    Properties.Settings.Default.COM = SerialPort.PortName;
                    Properties.Settings.Default.Save();

                    cboPortName.Enabled = false;
                    buttonConnect.Text = "Disconnect";
                    toolStripStatusLabel2.Text = "CONNECTED TO "+ SerialPort.PortName ;
                    toolStripProgressBar1.Value = 100;

                    //serialPort_rx.Write("C");
                }
            }
            catch (Exception ex)
            {
                
                MessageBox.Show("Connection Failed");
                
            }
        }
        else
        {
            try
            {
                SerialPort.Close();
            }
            catch { }
            cboPortName.Enabled = true;
            buttonConnect.Text = "Connect";
            toolStripStatusLabel2.Text = "DISCONNECTED";
            toolStripProgressBar1.Value = 0;
        }
    }

    private void cboPortName_SelectedIndexChanged(object sender, EventArgs e)
    {
        my_COMPortAvaliable();
    }

    private void Form1_Activated(object sender, EventArgs e)
    {
        if (Variabel_share.id == "01")
        {
            groupBox1.Visible = true;
            Variabel_share.id1 = 0;
            textBox_Address.Text = Variabel_share.nama_lengkap;
            textBox_FirstName.Text = Variabel_share.kelamin;
            textBox_LastName.Text = Variabel_share.pangkat;

        }
        //else if (Variabel_share.id == "02")
        //{
        //    Variabel_share.id2 = 0;
        //    groupBox2.Visible = true;
        //    textBox5.Text = Variabel_share.nama_lengkap;
        //    textBox2.Text = Variabel_share.kelamin;
        //    textBox4.Text = Variabel_share.pangkat;
        //    textBox7.Text = Variabel_share.nrp;
        //    textBox6.Text = Variabel_share.tempat_lahir;
        //    textBox3.Text = Variabel_share.tanggal_lahir;

        //}
        Variabel_share.id = "";
    }

    private void cboPortName_Click(object sender, EventArgs e)
    {
        my_COMPortAvaliable();
    }

    private void button21_Click_1(object sender, EventArgs e)
    {
        if (MessageBox.Show("             Apakah akan menghapus terminal?", "Hapus terminal", MessageBoxButtons.YesNo) == DialogResult.Yes)
        {
            richTextBoxDataReceived.Clear();
            richTextBoxDataReceived.Focus();
        }
        else
        {
            this.Activate();
        }
    }

    private void button16_Click_2(object sender, EventArgs e)
    {
        saveFileDialog1.Filter = "csv files (*.csv)|*.csv";

        saveFileDialog1.FileName = String.Format("Data {0}.csv", DateTime.Now.ToString(" yyy-MMM-dd HH mm ss"));

        if (saveFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK && saveFileDialog1.FileName.Length > 0)
        {

            richTextBoxDataReceived.SaveFile(saveFileDialog1.FileName, RichTextBoxStreamType.PlainText); //jika di save
        }
    }

  
    
    //TAMPIL PETA
    private void Button6_Click(object sender, EventArgs e)
    {
        tabControl2.SelectedIndex = 1;
        gps_marker(Convert.ToDouble(label60.Text),Convert.ToDouble(label58.Text));
        gps_marker(31.25111, 34.79806);
            label14.Text = Convert.ToDouble(label60.Text).ToString();
            label15.Text = Convert.ToDouble(label58.Text).ToString();
        }

    private void pictureBox4_Click_1(object sender, EventArgs e)
    {
        var f2 = new FamiliesRepresentativesCRUD();
        f2.Owner = this;  // <-- This is the important thing
        f2.ShowDialog(); // VS Show
    }

    private void button4_Click(object sender, EventArgs e)
    {
        gps_marker(31.25111, 34.79806);
    }

    private void Button7_Click(object sender, EventArgs e)
    {
        if (SerialPort.IsOpen)
        {

            SerialPort.Write("V");
        }
    }


    

    private void RadioButton2_CheckedChanged(object sender, EventArgs e)
    {
        this.pictureBox1.Size = new System.Drawing.Size(320, 240);
    }

    private void radioButton3_CheckedChanged(object sender, EventArgs e)
    {
        this.pictureBox1.Size = new System.Drawing.Size(160, 120);
    }

    private void button8_Click(object sender, EventArgs e)
    {
        if (SerialPort.IsOpen)
            SerialPort.Write("G");
    }

    Int16[] data_gambar_buffer = new Int16[10000];
    int panjang_paket_gambar;
    private void my_parse_data_gambar(object sender, EventArgs e)
    {
        try
        {

            string_DEC = "";
            label23.Text = data_in.Length.ToString();
            panjang_paket_gambar = data_in.Length - 3;

            byte[] data1 = new byte[panjang_paket_gambar + 1];

            for (int i = 0; i <= panjang_paket_gambar; i++)
            {
                data1[i] = (byte)Strings.Asc(data_in[i]);



                string_DEC += Convert.ToInt16(data1[i]).ToString() + "_";
                data_gambar_buffer[i] = Convert.ToInt16(data_in[i]);

            }

            richTextBox2.Text = string_DEC;
            richTextBox2.ScrollToCaret();

            this.BeginInvoke(new EventHandler(my_tampilgambar));

            data_in = "";
        }
        catch { }
        

    }
    string string_DEC;
    string string_DEC_BUF;



        private void my_tampilbuffer(object sender, EventArgs e)
    {
        richTextBoxDataReceived.AppendText(buffer);
        richTextBoxDataReceived.ScrollToCaret();

        label_length.Text = buffer.Length.ToString();

        for (int i = 0; i <= buffer.Length - 3; i++)
            string_DEC_BUF += Convert.ToChar(buffer[i]).ToString() + "_" + Convert.ToInt16(buffer[i]).ToString() + "_";

        richTextBox3.Text = string_DEC_BUF;
        richTextBox3.ScrollToCaret();
        string_DEC_BUF = "";

        label_BytesToRead.Text = SerialPort.BytesToRead.ToString();


    }
    private void button12_Click(object sender, EventArgs e)
    {
       
        this.BeginInvoke(new EventHandler(my_tampilgambar));
    }


    private void my_tampilgambar(object sender, EventArgs e)
    {
        try
        {
            label18.Text = panjang_paket_gambar.ToString();

            richTextBox1.Clear();

            byte[] data_gambar_matang = new byte[panjang_paket_gambar + 1];
            for (int i = 0; i <= panjang_paket_gambar; i++)
            {
                data_gambar_matang[i] = (byte)data_gambar_buffer[i];
                label21.Text = i.ToString();
                richTextBox1.AppendText(data_gambar_matang[i].ToString() + "_");
                richTextBox1.ScrollToCaret();
            }

            try
            {
                string hasil = "D:\\coba100.jpg";
                System.IO.File.WriteAllBytes(@hasil, data_gambar_matang);
                pictureBox1.ImageLocation = @hasil;
            }
            catch { }
        }
        catch { };
    }

    private void tabPage2_Click(object sender, EventArgs e)
    {

    }
    }


      
    public static class Variabel_share
    {
        public static String id="0";
        public static String nama_lengkap;
        public static String kelamin;
        public static String pangkat;
        public static String nrp;
        public static String tempat_lahir;
        public static String tanggal_lahir;

        public static Byte id1=1;
        public static Byte id2 = 1;
    }
}
