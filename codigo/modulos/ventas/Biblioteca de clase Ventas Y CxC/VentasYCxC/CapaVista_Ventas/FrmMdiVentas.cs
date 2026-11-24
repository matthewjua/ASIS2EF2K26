// Matthew Juárez | 0901-23-4250 | 24/11/2026
// Contenedor de Ventas y acceso al catálogo de pacientes.
using System;
using System.Windows.Forms;
using CapaVista_Mantenimientos;

namespace CapaVista_Ventas
{
    public class FrmMdiVentas : Form
    {
        public FrmMdiVentas(string NombreUsuario, string RolUsuario)
        {
            Text = "Ventas y cuentas por cobrar";
            IsMdiContainer = true;
            WindowState = FormWindowState.Maximized;

            var Menu = new MenuStrip();
            var Catalogos = new ToolStripMenuItem("Catálogos");
            Catalogos.DropDownItems.Add("Pacientes", null, VentasMetAbrirPacientes);
            Menu.Items.Add(Catalogos);
            MainMenuStrip = Menu;
            Controls.Add(Menu);

            var Estado = new StatusStrip();
            Estado.Items.Add("Usuario: " + NombreUsuario);
            Estado.Items.Add("Rol: " + RolUsuario);
            Controls.Add(Estado);
        }

        private void VentasMetAbrirPacientes(object Origen, EventArgs Evento)
        {
            foreach (Form Hijo in MdiChildren)
            {
                if (Hijo is FrmMantenimientosVentas)
                {
                    Hijo.Activate();
                    return;
                }
            }

            try
            {
                if (!FrmMantenimientosVentas.VentasFuncPuedeAbrirPacientes())
                {
                    MessageBox.Show(this, "El usuario no tiene acceso al catálogo de pacientes.");
                    return;
                }

                var Pacientes = new FrmMantenimientosVentas(true) { MdiParent = this };
                Pacientes.Show();
            }
            catch (Exception Excepcion)
            {
                MessageBox.Show(this, Excepcion.Message, "Pacientes", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
