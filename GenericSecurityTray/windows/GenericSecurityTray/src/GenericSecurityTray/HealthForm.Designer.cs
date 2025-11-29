namespace GenericSecurityTray
{
    partial class HealthForm
    {
        private System.ComponentModel.IContainer components = null;
        private TextBox summaryText;

        protected override void Dispose(bool disposing)
        {
            if (disposing && components != null)
                components.Dispose();
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.summaryText = new TextBox();
            this.SuspendLayout();

            this.summaryText.Multiline = true;
            this.summaryText.ReadOnly = true;
            this.summaryText.ScrollBars = ScrollBars.Vertical;
            this.summaryText.Dock = DockStyle.Fill;

            this.ClientSize = new System.Drawing.Size(400, 250);
            this.Controls.Add(this.summaryText);
            this.Text = "System Health";
            this.ResumeLayout(false);
        }
    }
}
