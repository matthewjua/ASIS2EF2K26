// Matthew Juárez | 0901-23-4250 | 24/11/2026
// Contenedor de Ventas y usuario autenticado.

using System.Windows.Forms;


namespace CapaVista_Ventas
{
    public class FrmMdiVentas : Form
    {
        public FrmMdiVentas(string NombreUsuario, string RolUsuario)
        {
            Text = "Ventas y cuentas por cobrar";
            IsMdiContainer = true;
            WindowState = FormWindowState.Maximized;

            var Estado = new StatusStrip();
            Estado.Items.Add("Usuario: " + NombreUsuario);
            Estado.Items.Add("Rol: " + RolUsuario);
            Controls.Add(Estado);
        }

    }
}
