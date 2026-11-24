/*
 * INICIO DEL CÓDIGO — Jose Torres
 * Carné: 0901-23-1091 | Fecha: 15/10/2026
 * Área: Ventas y cuentas por cobrar
 * Propósito: Iniciar Ventas mediante el login del componente de Seguridad.
 */
using System;
using System.Windows.Forms;
using CapaVista_Seguridad;

namespace Ejecucion_Ventas
{
    internal static class Program
    {
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            // Matthew Juárez | 0901-23-4250 | 24/11/2026 | Inicio del examen.
            Environment.SetEnvironmentVariable("ASIS_EXAMEN_DSN", "Dsn=asis22k26");
            using (var Login = new FrmLogin("Seguridad", "Ventas"))
            {
                // Conserva la seleccion de modulo y la autenticacion originales de Seguridad.
                Application.Run(Login);
            }
        }
    }
}

// FIN DEL CÓDIGO — Jose Torres | Carné: 0901-23-1091 | Fecha: 15/10/2026
