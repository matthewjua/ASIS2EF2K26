using CapaVista_Navegador;
using System.Windows.Forms;

namespace CapaVista_Mantenimientos
{
    public partial class FrmMantenimientosVentas : Form
    {
        public const int VentasIdModuloPacientes = 7000;
        public const int VentasIdAplicacionPacientes = 7017;

        public static bool VentasFuncPuedeAbrirPacientes()
        {
            return ClsNavegadorPermisos.NavegadorMetInicializarPermisos(
                VentasIdModuloPacientes, VentasIdAplicacionPacientes, null).TieneAcceso;
        }

        public FrmMantenimientosVentas() : this(false) { }

        // Matthew Juarez | 0901-23-4250 | 24/11/2026 | Catalogo de pacientes.
        public FrmMantenimientosVentas(bool Pacientes)
        {
            InitializeComponent();
            var AreaTrabajo = Screen.FromControl(this).WorkingArea;
            AutoScrollMinSize = ClientSize;
            AutoScroll = true;
            MinimumSize = System.Drawing.Size.Empty;
            Size = new System.Drawing.Size(System.Math.Min(Width, System.Math.Max(1, AreaTrabajo.Width - 32)),
                System.Math.Min(Height, System.Math.Max(1, AreaTrabajo.Height - 32)));
            if (!Pacientes)
            {
                VentasUsrNavegador.NavegadorMetConfigurar("tblcliente", 4, 4);
                return;
            }

            Text = "7017 – Pacientes";
            VentasLblTitulo.Text = "Pacientes";
            VentasLblCodigo.Text = VentasIdAplicacionPacientes.ToString();
            VentasUsrNavegador.NavegadorMetConfigurar("tbl_paciente",
                VentasIdModuloPacientes, VentasIdAplicacionPacientes);
            VentasUsrNavegador.NavegadorMetConfigurarCatalogo(
                "Pulse Ingresar, complete los datos y pulse Guardar. Para editar o borrar, " +
                "pulse Modificar o Eliminar y seleccione el registro por su ID. " +
                "Use Consultar para filtrar e Imprimir para ver el reporte del catálogo. " +
                "Estado: 1 = activo, 0 = inactivo.", "Pacientes");
        }
    }
}
